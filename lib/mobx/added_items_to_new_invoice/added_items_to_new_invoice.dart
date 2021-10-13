import 'package:mobx/mobx.dart';
import 'package:petrol_naas/models/item.dart';

part 'added_items_to_new_invoice.g.dart';

class AddedItemsToNewInvoiceStore = _AddedItemsToNewInvoiceStoreBase
    with _$AddedItemsToNewInvoiceStore;

abstract class _AddedItemsToNewInvoiceStoreBase with Store {
  @observable
  ObservableList<Item> items = ObservableList();
  @observable
  ObservableList<int> quantities = ObservableList();
  @computed
  double get totalPrice => calculateTotalPrice();
  @computed
  double Function(double) get vat => calculateVat;
  @computed
  double Function(double) get invoiceTotal => calculateInvoiceTotal;

  @action
  addItem(Item item, int quantity) {
    items.add(item);
    quantities.add(quantity);
  }

  @action
  removeItemByIndex(int idx) {
    items.removeAt(idx);
    quantities.removeAt(idx);
  }

  @action
  editQuantityByIndex(int quantity, int idx) {
    quantities[idx] = quantity;
  }

  @action
  reset() {
    items = ObservableList<Item>();
    quantities = ObservableList<int>();
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;

    for (int i = 0; i < items.length; i++) {
      totalPrice += items[i].sellPrice! * quantities[i];
    }

    return totalPrice;
  }

  double calculateVat(double fee) {
    double vat = fee * totalPrice;

    return vat;
  }

  double calculateInvoiceTotal(double fee) {
    double vat = this.vat(fee);
    double invoiceTotal = totalPrice + vat;

    return invoiceTotal;
  }
}
