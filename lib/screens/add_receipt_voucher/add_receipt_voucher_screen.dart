import 'package:dio/dio.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/widget/screen_layout.dart';
import 'package:provider/src/provider.dart';

import 'package:petrol_naas/components/custom_button.dart';
import 'package:petrol_naas/components/custom_dropdown.dart';
import 'package:petrol_naas/components/custom_text_field.dart';
import 'package:petrol_naas/constants.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/create_receipt.dart';
import 'package:petrol_naas/models/customer.dart';
import 'package:petrol_naas/utils/utils.dart';
import 'package:petrol_naas/widget/add_invoice_widget/expand_custom_text_field.dart';

class AddReceiptScreen extends StatefulWidget {
  const AddReceiptScreen({Key? key}) : super(key: key);

  @override
  State<AddReceiptScreen> createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  Customer? _selectedCustomer;
  late final TextEditingController _moneyAmountController;
  late final TextEditingController _descriptionController;
  final CreateReceipt receipt = CreateReceipt();

  @override
  void initState() {
    _moneyAmountController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _moneyAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'إضافة سند قبض',
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          _renderCustomerDropDown(context),
          _renderMoneyAmount(),
          _renderDescriptionTextArea(),
          _renderSaveButton(),
        ],
      ),
    );
  }

  Observer _renderCustomerDropDown(BuildContext context) {
    return Observer(builder: (_) {
      final borderStyle = OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: primaryColor,
            style: BorderStyle.solid,
            width: 1.2,
          ));

      final customerStore = context.watch<CustomerStore>();
      final List<Customer> customers = customerStore.customers;

      final isKeyboardShown = MediaQuery.of(context).viewInsets.bottom != 0.0;

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
              findFn: (dynamic str) async => customers,
              filterFn: (dynamic customer, str) =>
                  customer.accName.toLowerCase().indexOf(str.toLowerCase()) >=
                  0,
              dropdownItemFn: (dynamic customer, position, focused,
                      dynamic lastSelectedItem, onTap) =>
                  ListTile(
                title: Text(customer.accName),
                subtitle: Text(
                  customer?.remainingBalance.toStringAsFixed(2) ?? '',
                ),
                tileColor:
                    focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
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

      //  CustomDropdown<Customer>(
      //   elements: customerStore.customers,
      //   textProperty: "AccName",
      //   label: "اسم العميل",
      //   onChanged: (Customer? customer) {
      //     setState(() {
      //       _selectedCustomer = customer;
      //       receipt.accNo = customer!.accNo;
      //     });
      //   },
      //   selectedValue: _selectedCustomer,
      // );
    });
  }

  void setCustomerDropDownValue(customer) {
    _selectedCustomer = customer;
    receipt.accNo = customer!.accNo;
  }

  CustomTextField _renderMoneyAmount() {
    return CustomTextField(
      type: CustomTextFieldTypes.yellow,
      hintText: "المبلغ",
      controller: _moneyAmountController,
      //TODO: add textfield pattern to accept numbers and dots only
      keyboardType: TextInputType.number,
      onChanged: onAmountChanged,
    );
  }

  void onAmountChanged(String amount) {
    try {
      receipt.amount = double.parse(amount);
    } catch (e) {
      if (amount != "") {
        receipt.amount = 0.0;
        return;
      }
      showSnackBar(context, "من فضلك أدخل المبلغ بشكل صحيح");
    }
  }

  ExpandCustomTextField _renderDescriptionTextArea() {
    return ExpandCustomTextField(
      onChanged: onDescriptionChanged,
      label: "البيان",
      controller: _descriptionController,
    );
  }

  void onDescriptionChanged(String description) {
    receipt.description = description;
  }

  CustomButton _renderSaveButton() {
    return CustomButton(
      buttonColors: greenColor,
      textColors: Colors.white,
      label: "حفظ",
      onPressed: _showPrintAlert,
    );
  }

  Future<String?> _showPrintAlert() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'تنبيه!!',
          style: TextStyle(fontSize: 25.0),
        ),
        content: const Text(
          'هل انت متأكد من الحفظ لأنه لا يمكن التعديل علي السند',
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
            onPressed: () => onSubmitSaving(),
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
  }

  void onSubmitSaving() async {
    fillInRestJsonData();
    if (!areAllDataValid()) return;

    await sendDataToApi();
  }

  void fillInRestJsonData() {
    final userStore = context.read<UserStore>();
    final user = userStore.user;

    receipt.cashAccNo = user.cashAccno;
    receipt.userNo = user.userNo;
  }

  bool areAllDataValid() {
    if (!isDataFilled()) {
      showSnackBar(context, "من فضلك املأ جميع البيانات");
      return false;
    }
    if (!isMoneyAmountValid()) {
      showSnackBar(context, "من فضلك أدخل المبلغ بشكل صحيح بحيث تكون عدد موجب");
      return false;
    }
    return true;
  }

  bool isDataFilled() {
    bool isCustomerSelected = receipt.accNo != null;
    bool isAmountFilled = receipt.amount != null && receipt.amount != null;
    bool isDescriptionFilled =
        receipt.description != null && receipt.description != "";
    bool iscashAccNoValid = receipt.cashAccNo != null;
    bool isUserNoValid = receipt.userNo != null;

    return isCustomerSelected &&
        isAmountFilled &&
        isDescriptionFilled &&
        iscashAccNoValid &&
        isUserNoValid;
  }

  bool isMoneyAmountValid() {
    return receipt.amount != null && receipt.amount! > 0;
  }

  Future<void> sendDataToApi() async {
    try {
      final Response response =
          await Dio(dioOptions).post("/receipt", data: receipt.toJson());
      final bool isSavedSuccessfully = response.data == "1" ? true : false;
      if (isSavedSuccessfully) {
        resetFields();
        showSnackBar(context, "تم الحفظ بنجاح");
      }
    } catch (e) {
      print(e);
      showSnackBar(context, "حدث خطأ ما، الرجاء المحاولة مرة أخرى");
    }
  }

  void resetFields() {
    _descriptionController.clear();
    _moneyAmountController.clear();
    setState(() {
      _selectedCustomer = null;
    });
  }
}
