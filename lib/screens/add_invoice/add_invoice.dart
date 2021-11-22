import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/components/custom_button.dart';
import 'package:petrol_naas/components/custom_dropdown.dart';
import 'package:petrol_naas/components/custom_text_field.dart';
import 'package:petrol_naas/mobx/added_items_to_new_invoice/added_items_to_new_invoice.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/models/invoice_header.dart';
import 'package:petrol_naas/screens/add_items_screen/add_items_screen.dart';
import 'package:petrol_naas/utils/utils.dart';
import 'package:petrol_naas/widget/item_add_in_add_invoice.dart';
import 'package:petrol_naas/widget/screen_layout.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:petrol_naas/mobx/items/items.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/create_invoice.dart';
import 'package:petrol_naas/models/customer.dart';
import 'package:petrol_naas/models/invoice_item.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/widget/add_invoice_widget/expand_custom_text_field.dart';
import 'package:petrol_naas/widget/add_invoice_widget/invoice_details.dart';

import '../../constants.dart';
import '../invoice_screen/invoice_screen.dart';

class AddInvoice extends StatefulWidget {
  const AddInvoice({
    Key? key,
  }) : super(key: key);

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  CreateInvoice createInvoice = CreateInvoice();
  late bool isLoading;
  Customer? _selectedCustomer;
  String? invNo;
  double fee = 0.0;

  late TextEditingController _qtyController;
  late TextEditingController _noteController;
  late TextEditingController _customerVATnumController;
  late ScrollController _scrollController;
  late DropdownEditingController<Customer> _customerDropDownController;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    initializeCustomersAndItemsAndFee();

    _qtyController = TextEditingController();
    _noteController = TextEditingController();
    _customerVATnumController = TextEditingController();
    _scrollController = ScrollController();
    _customerDropDownController = DropdownEditingController<Customer>();
  }

  Future<void> initializeCustomersAndItemsAndFee() async {
    await getItems();
    await getFee();
  }

  void changeLoadingState(bool state) => setState(() => isLoading = state);

  Future<void> getItems() async {
    try {
      changeLoadingState(true);
      final userStore = context.read<UserStore>();

      Response response = await Dio(dioOptions).get(
          "/items?sellPriceNo=${userStore.user.sellPriceNo}&whno=${userStore.user.whno}");
      var jsonRespone = response.data;
      final itemsStore = context.read<ItemsStore>();
      itemsStore.setItems(prepareItemsList(jsonRespone));

      changeLoadingState(false);
    } on DioError catch (error) {
      // ignore: avoid_print
      print(error);
      changeLoadingState(false);
    }
  }

  List<Item> prepareItemsList(dynamic itemsList) {
    List<Item> items = List<Item>.from(
      itemsList.map(
        (item) => Item.fromJson(item),
      ),
    );
    return items;
  }

  Future<void> getFee() async {
    try {
      Response response = await Dio(dioOptions).get(
        '/fee',
      );
      setState(() {
        final double fee = double.parse(response.data) / 100.0;
        this.fee = fee;
      });
    } on DioError {
      showSnackBar(context,
          'حدث خطأ ما اثناء الحصول علي الضريبة، الرجاء التواصل مع الادارة');
    }
  }

  @override
  void dispose() {
    super.dispose();

    _qtyController.dispose();
    _noteController.dispose();
    _customerVATnumController.dispose();
    _scrollController.dispose();
    _customerDropDownController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      showBackButton: true,
      title: "إضافة فاتورة",
      child: Container(
        color: Colors.white,
        child: isLoading
            ? _customLoading()
            : ListView(
                controller: _scrollController,
                padding: EdgeInsets.all(0),
                children: [
                  _renderPayTypeDropdown(),
                  _renderCustomerDropdown(),
                  _renderCustomerVATnumTextField(),
                  _renderNotesTextArea(),
                  _renderItemsList(),
                  _renderAddItemButton(),
                  _renderTotal(),
                  _renderVat(),
                  _renderInoviceTotal(),
                  _renderPrintButton(),
                ],
              ),
      ),
    );
  }

  //-----------------------------------------------------------------

  Widget _customLoading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe8bd34)),
      ),
    );
  }

  //-----------------------------------------------------------------

  CustomDropdown<String> _renderPayTypeDropdown() {
    return CustomDropdown<String>(
      elements: <String>["نقدي كاش", "آجل"],
      label: 'نوع الدفع',
      selectedValue: InoviceHeader.decodePayType(createInvoice.payType),
      onChanged: setPayTypeDropDownValue,
    );
  }

  void setPayTypeDropDownValue(String? payTypeText) {
    final String? payType = InoviceHeader.encodePayType(payTypeText);
    if (payType != null) {
      setState(() {
        createInvoice.payType = payType;
      });
    }
  }

  //-----------------------------------------------------------------

  Widget _renderCustomerDropdown() {
    final customerStore = context.read<CustomerStore>();
    final List<Customer> customers = customerStore.customers;

    final borderStyle = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: primaryColor,
          style: BorderStyle.solid,
          width: 1.2,
        ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "العميل",
              style: TextStyle(
                fontSize: 18.0,
                color: darkColor,
              ),
            ),
          ),
          DropdownFormField<Customer>(
            onChanged: setCustomerDropDownValue,
            controller: _customerDropDownController,
            findFn: (dynamic str) async => customers,
            filterFn: (dynamic customer, str) =>
                customer.accName!.toLowerCase().contains(str.toLowerCase()),
            dropdownItemFn: (dynamic customer, position, focused,
                    dynamic lastSelectedItem, onTap) =>
                ListTile(
              title: Text(
                customer.accName,
                style: TextStyle(
                  // color: primaryColor,
                  color: darkColor,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الرصيد: ${customer.remainingBalance?.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 17.0),
                  ),
                  Text(
                    "الحد الائتماني: ${customer.creditLimit?.toStringAsFixed(2)}",
                  ),
                  Divider(
                    height: 5.0,
                    color: darkColor.withOpacity(0.3),
                  )
                ],
              ),
              // trailing: Text(trailing),
              onTap: onTap,
            ),
            displayItemFn: (dynamic customer) => Text(
              customer?.accName ?? '',
              style: TextStyle(fontSize: 16),
            ),
            // TODO: next line
            // searchTextStyle: TextStyle(fontFamily: "Changa", color: Colors.red),
            decoration: InputDecoration(
              floatingLabelStyle: TextStyle(color: Colors.black54),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: primaryColor,
              focusColor: primaryColor,
              hoverColor: primaryColor,
              enabledBorder: borderStyle,
              focusedBorder: borderStyle,
              focusedErrorBorder: borderStyle,
              border: borderStyle,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              isDense: true,
              suffixIcon: Icon(
                Icons.expand_more,
                color: primaryColor,
                size: 25.0,
              ),
              labelText: "العميل",
              labelStyle: TextStyle(color: Colors.black45),
            ),
            dropdownHeight: 200,
          ),
        ],
      ),
    );
  }

  Future<List<Customer>> getData(filter) async {
    final customerStore = context.read<CustomerStore>();

    return customerStore.customers;
  }

  void setCustomerDropDownValue(customer) {
    _customerDropDownController.value = customer;
    createInvoice.custno = customer.accNo;
    _selectedCustomer = customer;
    setState(() {});
  }

  //-----------------------------------------------------------------

  Widget _renderCustomerVATnumTextField() {
    bool isCustomerHasVatAccNo = _selectedCustomer == null ||
        _selectedCustomer!.vaTnum != null &&
            (_selectedCustomer!.vaTnum!.contains(RegExp(r"^[0-9]")));

    if (_selectedCustomer?.vaTnum != null) _customerVATnumController.clear();

    return !isCustomerHasVatAccNo && createInvoice.payType == "3"
        ? CustomTextField(
            type: CustomTextFieldTypes.yellow,
            hintText: "الرقم الضريبي للعميل",
            keyboardType: TextInputType.number,
            controller: _customerVATnumController,
          )
        : SizedBox();
  }

  //-----------------------------------------------------------------

  ExpandCustomTextField _renderNotesTextArea() {
    return ExpandCustomTextField(
      controller: _noteController,
      label: 'ملاحظات',
    );
  }

  //-----------------------------------------------------------------

  Padding _renderItemsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 20.0,
      ),
      child: Observer(builder: (_) {
        final addedItemsToNewInvoiceStore =
            context.watch<AddedItemsToNewInvoiceStore>();

        final List<Item> items = addedItemsToNewInvoiceStore.items;
        final List<int> quantities = addedItemsToNewInvoiceStore.quantities;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الأصناف',
              style: TextStyle(
                fontSize: 18.0,
                color: darkColor,
              ),
            ),
            ..._renderAddItemsList(items, quantities)
          ],
        );
      }),
    );
  }

  List<Widget> _renderAddItemsList(List<Item> items, List<int> quantities) {
    return List.generate(
      items.length,
      (index) {
        final item = items[index];
        final qty = quantities[index];
        return ItemAddedInAddInvoice(
          index: index,
          item: item,
          qty: qty,
        );
      },
    ).toList();
  }

  //-----------------------------------------------------------------

  CustomButton _renderAddItemButton() {
    return CustomButton(
      label: 'اضافة صنف',
      buttonColors: greenColor,
      textColors: Colors.white,
      icon: Icons.add,
      onPressed: () => onPressAddItem(<Item>[]),
    );
  }

  void onPressAddItem(List<Item> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddItemScreen(),
      ),
    );
  }

  //-----------------------------------------------------------------

  Observer _renderTotal() {
    return Observer(builder: (_) {
      final addedItemsToNewInvoiceStore =
          context.watch<AddedItemsToNewInvoiceStore>();

      final double totalPrice = addedItemsToNewInvoiceStore.totalPrice;

      return InvoiceDetails(
        title: 'الاجمالي :',
        result: totalPrice.toStringAsFixed(2),
      );
    });
  }

  //-----------------------------------------------------------------

  Observer _renderVat() {
    return Observer(builder: (_) {
      final addedItemsToNewInvoiceStore =
          context.watch<AddedItemsToNewInvoiceStore>();
      final double vat = addedItemsToNewInvoiceStore.vat(fee);

      return InvoiceDetails(
        title: 'الضريبـــة :',
        result: vat.toStringAsFixed(2),
      );
    });
  }

  //-----------------------------------------------------------------

  Observer _renderInoviceTotal() {
    return Observer(builder: (_) {
      final addedItemsToNewInvoiceStore =
          context.watch<AddedItemsToNewInvoiceStore>();
      final total = addedItemsToNewInvoiceStore.invoiceTotal(fee);

      return InvoiceDetails(
        title: 'اجمالي الفاتورة :',
        result: total.toStringAsFixed(2),
      );
    });
  }

  //-----------------------------------------------------------------

  CustomButton _renderPrintButton() {
    return CustomButton(
      label: 'طباعة الفاتورة',
      buttonColors: primaryColor,
      textColors: Colors.white,
      icon: Icons.print,
      onPressed: () => _showPrintAlert(context),
    );
  }

  Future<String?>? _showPrintAlert(BuildContext context) async {
    try {
      fillInRestDataOfInvoice();
      isFieldsFilled();
      checkVatAccNoDigitsOnly();
      if (createInvoice.payType == "3") {
        // آجل
        await checkExceedingCreditLimit();
      }

      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            'تنبيه!!',
            style: TextStyle(fontSize: 25.0),
          ),
          content: const Text(
            'هل انت متأكد من الاستمرار لأنه لا يمكن التعديل علي الفاتورة',
            style: TextStyle(fontSize: 18.0),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'الغاء',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              onPressed: onSubmitPrint,
              child: Text(
                'تأكيد',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> onSubmitPrint() async {
    await sendInvoiceToApi();

    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();

    final String payType = InoviceHeader.decodePayType(createInvoice.payType!)!;
    final double vat = addedItemsToNewInvoiceStore.calculateVat(fee);
    final double totalPrice = addedItemsToNewInvoiceStore.calculateTotalPrice();

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => InvoiceScreen(
          customerName: _selectedCustomer!.accName!,
          customerVATnum: _selectedCustomer!.vaTnum,
          invNo: invNo!,
          payType: payType,
          vat: vat,
          total: totalPrice,
        ),
      ),
    )
        .then((_) {
      resetPerviousData();
    });
  }

  void fillInRestDataOfInvoice() {
    createInvoice.vatAccNo =
        _selectedCustomer?.vaTnum ?? _customerVATnumController.text;
    createInvoice.notes = _noteController.text;

    final userStore = context.read<UserStore>();
    createInvoice.userno = userStore.user.userNo!;
    createInvoice.salesman = userStore.user.salesman!;
    createInvoice.whno = userStore.user.whno!;

    if (createInvoice.payType == "1") {
      createInvoice.accno = userStore.user.cashAccno!;
    } else if (createInvoice.payType == "3") {
      if (_selectedCustomer == null) throw ('الرجاء اختيار عميل');
      createInvoice.accno = _selectedCustomer!.accNo!;
    }

    createInvoice.sellPriceNo = userStore.user.sellPriceNo!;

    fillInItemsToViewInAddInviceAndInvoiceToPrint();
  }

  void fillInItemsToViewInAddInviceAndInvoiceToPrint() {
    clearAddItemsFromCreateInvoiceObj();

    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();

    final int listLength = addedItemsToNewInvoiceStore.items.length;

    for (int i = 0; i < listLength; i++) {
      final item = addedItemsToNewInvoiceStore.items[i];
      final qty = addedItemsToNewInvoiceStore.quantities[i];

      addItemToCreateInvoiceItems(item, qty);
    }
  }

  void clearAddItemsFromCreateInvoiceObj() {
    createInvoice.items = [];
  }

  void addItemToCreateInvoiceItems(Item item, int qty) {
    createInvoice.items ??= [];
    final int freeQty = Item.calcFreeQty(
        qty: qty,
        promotionQtyReq: item.promotionQtyReq!,
        promotionQtyFree: item.promotionQtyFree!);

    createInvoice.items!
        .add(InvoiceItem(itemno: item.itemno!, freeQty: freeQty, qty: qty));
  }

  void isFieldsFilled() {
    //TODO:validate number as digits only
    final bool isPayTypeFilled =
        createInvoice.payType == "1" || createInvoice.payType == "3";
    final bool isCustnoFilled = createInvoice.custno != null;
    final bool isVatAccNoFilled = _customerVATnumController.text.isNotEmpty ||
        (_selectedCustomer!.vaTnum != null && _selectedCustomer!.vaTnum != "");
    final bool isUsernoFilled = createInvoice.userno != "";
    final bool isSalesmanFilled = createInvoice.salesman != "";
    final bool isWhnoFilled = createInvoice.whno != "";
    final bool isAccnoFilled = createInvoice.accno != "";
    final bool isSellPriceNoFilled = createInvoice.sellPriceNo != "";
    final bool isItemsFilled =
        createInvoice.items != null && createInvoice.items!.isNotEmpty;

    if (!isPayTypeFilled) throw ('الرجاء اختيار نوع الدفع');
    if (!isCustnoFilled) throw ('الرجاء اختيار عميل');
    if (!isVatAccNoFilled) throw ('الرجاء تحديد رقم ضريبي');
    if (!isItemsFilled) throw ('الرجاء اضافة أصناف للفاتورة');

    if (!isUsernoFilled ||
        !isSalesmanFilled ||
        !isWhnoFilled ||
        !isAccnoFilled ||
        !isSellPriceNoFilled) {
      throw ('يوجد خطأ ما اثناء انشاء الفاتورة الرجاء التواصل مع الادارة لحل المشكلة');
    }
  }

  void checkVatAccNoDigitsOnly() {
    final bool isVatAccNoNotValid =
        (createInvoice.vatAccNo?.contains(RegExp(r'[^0-9]')) ?? true);

    if (isVatAccNoNotValid) throw ('الرقم الضريبي يجب أن يحتوي على أرقام فقط');
  }

  Future<void> checkExceedingCreditLimit() async {
    try {
      final userStore = context.read<UserStore>();
      final user = userStore.user;
      final delegateNo = user.delegateNo;

      final accNo = createInvoice.accno;

      Response response = await Dio(dioOptions)
          .get("/creditLimit?delegateNo=$delegateNo&AccNo=$accNo");

      final double maxAcceptableBalance = double.parse(response.data);

      final addedItemsToNewInvoiceStore =
          context.read<AddedItemsToNewInvoiceStore>();
      final total = addedItemsToNewInvoiceStore.invoiceTotal(fee);

      if (total > maxAcceptableBalance) {
        throw 'لقد تخطيت الحد الأقصى للائتمان، أقصى مبلغ يمكن الشراء به بالآجل هو: $maxAcceptableBalance ريال سعودي';
      }
    } catch (e) {
      rethrow;
    }
  }

  double getRemainingAcceptableCreditBasedOnTotalUserCreditLimit() {
    final userStore = context.read<UserStore>();
    final user = userStore.user;
    final double userCreditLimit = user.creditLimit!;

    final customerStore = context.read<CustomerStore>();
    final totalCustomersCreditLimit = customerStore.totalUserCreditLimit;

    final remainingAcceptableCredit =
        userCreditLimit - totalCustomersCreditLimit;
    return remainingAcceptableCredit;
  }

  double getRemainingAcceptableCreditBasedOnTotalCustomerCreditLimit() {
    final double remainingAcceptableCredit =
        _selectedCustomer!.creditLimit! - _selectedCustomer!.remainingBalance!;
    return remainingAcceptableCredit;
  }

  Future<void> sendInvoiceToApi() async {
    try {
      const String url = "/invoice";
      Response res =
          await Dio(dioOptions).post(url, data: createInvoice.toJson());
      final response = res.data;
      invNo = response;
    } catch (e) {
      throw "حدث خطأ ما، الرجاء المحاولة مرة أخرى";
    } finally {
      Navigator.pop(context, 'Cancel');
    }
  }

  void updateRemainingBalance() {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();
    final double totalPrice = addedItemsToNewInvoiceStore.calculateTotalPrice();

    final customerStore = context.read<CustomerStore>();
    final customers = customerStore.customers;
    customerStore.setCustomers(
      customers
          .map(
            (Customer customer) => customer.accNo == _selectedCustomer?.accNo
                ? customer.copyWith(
                    creditLimit: customer.remainingBalance! + totalPrice)
                : customer,
          )
          .toList(),
    );
  }

  Future<void> resetPerviousData() async {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();
    addedItemsToNewInvoiceStore.reset();
    createInvoice = CreateInvoice();

    _selectedCustomer = null;
    _noteController.clear();

    await initializeCustomersAndItemsAndFee();
    updateRemainingBalance();
    scrollToTop();
  }

  void scrollToTop() {
    _scrollController.jumpTo(0);
  }
}
