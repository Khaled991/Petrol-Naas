import 'package:mobx/mobx.dart';
import 'package:petrol_naas/models/create_receipt.dart';
part 'my_receipts.g.dart';

class myReceiptsStore = _myReceiptsStoreBase with _$myReceiptsStore;

abstract class _myReceiptsStoreBase with Store {
  @observable
  List<CreateReceipt> receipts = [];

  @action
  jsonToInvoicesList(dynamic json) {
    receipts.addAll(prepareInvoiceList(json));
  }

  @action
  resetList() {
    receipts = [];
  }

  List<CreateReceipt> prepareInvoiceList(dynamic myInvoiceList) {
    List<CreateReceipt> receipts = List<CreateReceipt>.from(
      myInvoiceList.map(
        (receipt) => CreateReceipt.fromJson(receipt),
      ),
    );
    return receipts;
  }
}
