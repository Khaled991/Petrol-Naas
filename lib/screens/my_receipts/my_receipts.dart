import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/components/custom_list_tile.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/filters.dart';
import 'package:petrol_naas/models/receipt.dart';
import 'package:petrol_naas/models/state_node.dart';
import 'package:petrol_naas/screens/add_receipt/add_receipt_screen.dart';
import 'package:petrol_naas/screens/receipt_print_screen/receipt_print_screen.dart';
import 'package:petrol_naas/utils/utils.dart';
import 'package:petrol_naas/widget/filters_header.dart';
import 'package:petrol_naas/widget/header/custom_header.dart';
import 'package:petrol_naas/widget/list_tile_skelton/list_tile_skelton.dart';
import 'package:petrol_naas/widget/screen_layout.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import '../../constants.dart';

class MyReceiptsScreen extends StatefulWidget {
  const MyReceiptsScreen({Key? key}) : super(key: key);

  @override
  State<MyReceiptsScreen> createState() => _MyReceiptsScreenState();
}

class _MyReceiptsScreenState extends State<MyReceiptsScreen> {
  bool isLoading = true;
  int _page = 1;
  final ScrollController _myReceiptsScrollController = ScrollController();
  late final StateNode<List<Receipt>> _myReceipts;
  Filters filters = Filters();

  @override
  void initState() {
    super.initState();
    getReceipts();

    _myReceipts = StateNode<List<Receipt>>([], setState);

    // if (_myReceipts.isEmpty) {
    changeLoadingState(true);
    getReceipts();
    // } else {
    //   changeLoadingState(false);
    // }

    _myReceiptsScrollController.addListener(() {
      final double currentScrollPosition =
          _myReceiptsScrollController.position.pixels;
      final double maxScrollPosition =
          _myReceiptsScrollController.position.maxScrollExtent;
      if (currentScrollPosition == maxScrollPosition) {
        _page++;
        getReceipts();
      }
    });
  }

  Future<void> getReceipts() async {
    try {
      final userStore = context.read<UserStore>();
      final user = userStore.user;
      final userNo = user.userNo;

      String url = '/receipt?Createduserno=$userNo&page=$_page';

      if (filters.hasDateFilter()) {
        url +=
            "&from=${filters.firstDate.current}&to=${filters.lastDate.current}";
      }
      if (filters.hasCustomerFilter()) {
        url += "&Custno=${filters.custNo.current}";
      }

      Response response = await Dio(dioOptions).get(url);

      _myReceipts.value += Receipt.fromJsonList(response.data);
    } on DioError catch (e) {
      print(e);
      showSnackBar(context, 'حدث خطأ ما، الرجاء المحاولة مرة اخرى');
    } finally {
      changeLoadingState(false);
    }
  }

  @override
  void dispose() {
    _myReceiptsScrollController.dispose();
    super.dispose();
  }

  void changeLoadingState(bool state) => setState(() => isLoading = state);

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
    _myReceiptsScrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: "سندات القبض",
      trailing: HeaderTrailingModel(
          icon: Icons.add,
          onPressed: () => navigatePush(context, AddReceiptScreen())),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            FiltersHeader<Receipt>(
              changeLoadingState: changeLoadingState,
              filters: filters,
              fetchData: getReceipts,
              setFirstPage: setFirstPage,
              moveScrollToTop: moveScrollToTop,
              data: _myReceipts,
            ),
            Expanded(
              child: isLoading
                  ? ListTileSkelton(isThreeLine: true)
                  : _myReceipts.value.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(0.0),
                          controller: _myReceiptsScrollController,
                          itemCount: _myReceipts.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            Receipt receipt = _myReceipts.value[index];

                            final String date =
                                receipt.createdDate!.split(' ')[0];
                            final String recNo = receipt.recNo!;
                            final String amount =
                                receipt.amount!.toStringAsFixed(2);

                            return CustomListTile(
                              title: receipt.accName ?? "",
                              subtitle: "رقم: $recNo",
                              thirdLine: "المبلغ: $amount ريال",
                              date: date.substring(0, 10),
                              onTap: () {
                                final userStore = context.read<UserStore>();
                                final user = userStore.user;
                                final String userName = user.name!;

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ReceiptPrintScreen(
                                      headerData: {
                                        "الرقم": receipt.recNo!,
                                        "التاريخ": prepareDateToPrint(
                                            receipt.createdDate!),
                                        "الملبغ":
                                            receipt.amount!.toStringAsFixed(2),
                                        "العميل": receipt.accName!,
                                        "البيان": receipt.description!,
                                        "المندوب": userName,
                                        "وقت الطباعة": prepareTimeToPrint(
                                            receipt.createdDate!),
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: Icons.receipt_long_rounded,
                            );
                          },
                        )
                      : _buildnotFound(),
            ),
          ],
        ),
      ),
    );
  }
}
