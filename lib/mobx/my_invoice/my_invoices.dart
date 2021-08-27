import 'package:mobx/mobx.dart';
import 'package:petrol_naas/models/invoice.dart';
part 'my_invoices.g.dart';

class MyInvoices = _MyInvoicesBase with _$MyInvoices;

abstract class _MyInvoicesBase with Store {
  @observable
  List<Invoice> myInvoices = [];

  @action
  jsonToInvoicesList(dynamic json) {
    myInvoices.addAll(prepareInvoiceList(json));
  }

  @action
  resetList() {
    myInvoices = [];
  }

  List<Invoice> prepareInvoiceList(dynamic myInvoiceList) {
    List<Invoice> myInvoices = List<Invoice>.from(
      myInvoiceList.map(
        (invoice) => Invoice.fromJson(invoice),
      ),
    );
    return myInvoices;
  }
}
