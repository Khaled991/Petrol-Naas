import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/filters.dart';
import 'package:petrol_naas/screens/add_invoice/add_invoice.dart';
import 'package:petrol_naas/utils/utils.dart';
import 'package:petrol_naas/widget/header/custom_header.dart';
import 'package:petrol_naas/widget/screen_layout.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:petrol_naas/widget/my_invoices_screen_header.dart';
import 'package:petrol_naas/widget/invoice_list_style.dart';
import 'package:petrol_naas/mobx/my_invoice/my_invoices.dart';
import 'package:petrol_naas/models/invoice.dart';
import '../../constants.dart';
import 'my_invoice_info.dart';
import 'my_invoice_skeleton.dart';

class MyInvoicesScreen extends StatefulWidget {
  const MyInvoicesScreen({Key? key}) : super(key: key);

  @override
  State<MyInvoicesScreen> createState() => _MyInvoicesScreenState();
}

class _MyInvoicesScreenState extends State<MyInvoicesScreen> {
  bool isLoading = true;
  int _page = 1;
  final ScrollController _myInvoicesScrollController = ScrollController();
  final _myInvoices = MyInvoices();
  Filters filters = Filters();

  @override
  void initState() {
    super.initState();
    getCustomers();

    // if (storeMyInvoices.myInvoices.isEmpty) {
    changeLoadingState(true);
    getInvoices();
    // } else {
    //   changeLoadingState(false);
    // }

    _myInvoicesScrollController.addListener(() {
      final double currentScrollPosition =
          _myInvoicesScrollController.position.pixels;
      final double maxScrollPosition =
          _myInvoicesScrollController.position.maxScrollExtent;
      if (currentScrollPosition == maxScrollPosition) {
        _page++;
        getInvoices();
      }
    });
  }

  Future<void> getCustomers() async {
    try {
      final String salesman = context.read<UserStore>().user.salesman ?? '';

      changeLoadingState(true);
      Response response = await Dio(dioOptions).get(
        '/customer?Salesman=$salesman',
      );
      if (!mounted) return;
      var jsonRespone = response.data;
      final customersStore = context.read<CustomerStore>();

      customersStore.setCustomers(jsonRespone);
      changeLoadingState(false);
    } on DioError {
      changeLoadingState(false);
    }
  }

  @override
  void dispose() {
    _myInvoicesScrollController.dispose();
    super.dispose();
  }

  void changeLoadingState(bool state) => setState(() => isLoading = state);

  Future<void> getInvoices() async {
    try {
      final userStore = context.read<UserStore>();

      String url =
          '/invoice?Createduserno=${userStore.user.userNo}&page=$_page';

      if (filters.hasDateFilter()) {
        url +=
            "&from=${filters.firstDate.current}&to=${filters.lastDate.current}";
      }
      if (filters.hasCustomerFilter()) {
        url += "&Custno=${filters.custNo.current}";
      }

      Response response = await Dio(dioOptions).get(url);

      final storeMyInvoices = _myInvoices;
      var jsonRespone = response.data;
      storeMyInvoices.jsonToInvoicesList(jsonRespone);
      changeLoadingState(false);
    } on DioError {
      showSnackBar(context, 'حدث خطأ ما، الرجاء المحاولة مرة اخرى');
      changeLoadingState(false);
    }
  }

  Widget _buildnotFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.mood_bad_outlined,
            size: 60.0, color: darkColor.withOpacity(0.75)),
        Text(
          'لا توجد نتائج',
          style: TextStyle(
            color: darkColor.withOpacity(0.75),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void setFirstPage() {
    _page = 1;
  }

  void moveScrollToTop() {
    _myInvoicesScrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final storeMyInvoices = _myInvoices;

    return Provider<MyInvoices>(
      create: (_) => _myInvoices,
      child: ScreenLayout(
        title: "الفواتير",
        trailing: HeaderTrailingModel(
            icon: Icons.add,
            onPressed: () => navigatePush(context, AddInvoice())),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              MyInvoicesScreenHeader(
                changeLoadingState: changeLoadingState,
                filters: filters,
                getInvoices: getInvoices,
                setFirstPage: setFirstPage,
                moveScrollToTop: moveScrollToTop,
              ),
              Expanded(
                child: isLoading
                    ? MyInvoiceSkeleton()
                    : storeMyInvoices.myInvoices.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(0.0),
                            controller: _myInvoicesScrollController,
                            itemCount: storeMyInvoices.myInvoices.length,
                            itemBuilder: (BuildContext context, int index) {
                              Invoice invoice =
                                  storeMyInvoices.myInvoices[index];

                              final date =
                                  invoice.header!.invdate!.split(' ')[0];
                              final invno = invoice.header!.invno!;

                              return InvoiceList(
                                tittle: invoice.header!.custName!,
                                billNumber: invno,
                                date: date,
                                onTap: () => {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MyInvoiceInfo(
                                        invno: invno,
                                        invoice: invoice,
                                      ),
                                    ),
                                  ),
                                },
                              );
                            },
                          )
                        : _buildnotFound(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
