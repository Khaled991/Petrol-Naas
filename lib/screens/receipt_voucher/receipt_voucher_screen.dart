import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/constants.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/customer.dart';
import 'package:petrol_naas/models/receipt_voucher.dart';
import 'package:petrol_naas/widget/add_invoice_widget/expand_custom_text_field.dart';
import 'package:petrol_naas/widget/custom_button.dart';
import 'package:petrol_naas/widget/custom_dropdown.dart';
import 'package:petrol_naas/widget/custom_input.dart';
import 'package:petrol_naas/widget/snack_bars/show_snack_bar.dart';
import 'package:provider/src/provider.dart';

class ReceiptVoucherScreen extends StatefulWidget {
  const ReceiptVoucherScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptVoucherScreen> createState() => _ReceiptVoucherScreenState();
}

class _ReceiptVoucherScreenState extends State<ReceiptVoucherScreen> {
  Customer? _selectedCustomer;
  // final TextEditingController _moneyAmountController = TextEditingController();
  // final TextEditingController _statmentController = TextEditingController();
  final ReceiptVoucher receiptVoucher = ReceiptVoucher();

  @override
  void dispose() {
    // _moneyAmountController.dispose();
    // _statmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0.0),
      children: [
        _renderCustomerDropDown(context),
        _renderMoneyAmount(),
        _renderStatmentTextArea(),
        _renderSaveButton(),
      ],
    );
  }

  Observer _renderCustomerDropDown(BuildContext context) {
    return Observer(builder: (_) {
      final customerStore = context.watch<CustomerStore>();
      return CustomDropdown<Customer>(
        elements: customerStore.customers,
        textProperty: "AccName",
        label: "اسم العميل",
        onChanged: (Customer? customer) {
          setState(() {
            _selectedCustomer = customer;
            receiptVoucher.accNo = customer!.accNo;
          });
        },
        selectedValue: _selectedCustomer,
      );
    });
  }

  CustomInput _renderMoneyAmount() {
    return CustomInput(
      type: CustomInputTypes.yellow,
      hintText: "المبلغ",
      // controller: _moneyAmountController,
      //TODO: add textfield pattern to accept numbers and dots only
      keyboardType: TextInputType.number,
      onChanged: onAmountChanged,
    );
  }

  void onAmountChanged(String amount) {
    try {
      receiptVoucher.amount = double.parse(amount);
    } catch (e) {
      if (amount != "") {
        receiptVoucher.amount = 0.0;
        return;
      }
      showSnackBar(context, "من فضلك أدخل المبلغ بشكل صحيح");
    }
  }

  ExpandCustomTextField _renderStatmentTextArea() {
    return ExpandCustomTextField(
      onChanged: onDescriptionChanged,
      label: "البيان",
    );
  }

  void onDescriptionChanged(String description) {
    receiptVoucher.description = description;
  }

  CustomButton _renderSaveButton() {
    return CustomButton(
      buttonColors: greenColor,
      textColors: Colors.white,
      label: "حفظ",
      onPressed: onPressSave,
    );
  }

  void onPressSave() async {
    fillInRestJsonData();
    if (!isDataFilled()) {
      showSnackBar(context, "من فضلك املأ جميع البيانات");
      return;
    }
    if (!isMoneyAmountValid()) {
      showSnackBar(context, "من فضلك أدخل المبلغ بشكل صحيح بحيث تكون عدد موجب");
      return;
    }
    print(receiptVoucher);
    await Dio(dioOptions).post("/receipt", data: receiptVoucher.toJson());
  }

  void fillInRestJsonData() {
    final userStore = context.read<UserStore>();
    final user = userStore.user;

    receiptVoucher.cashAccNo = user.cashAccno;
    receiptVoucher.userNo = user.userNo;
  }

  bool isDataFilled() {
    bool isCustomerSelected = receiptVoucher.accNo != null;
    bool isAmountFilled =
        receiptVoucher.amount != null && receiptVoucher.amount != "";
    bool isDescriptionFilled =
        receiptVoucher.description != null && receiptVoucher.description != "";
    bool iscashAccNoValid = receiptVoucher.cashAccNo != null;
    bool isUserNoValid = receiptVoucher.userNo != null;

    return isCustomerSelected &&
        isAmountFilled &&
        isDescriptionFilled &&
        iscashAccNoValid &&
        isUserNoValid;
  }

  bool isMoneyAmountValid() {
    return receiptVoucher.amount != null && receiptVoucher.amount! > 0;
  }
}
