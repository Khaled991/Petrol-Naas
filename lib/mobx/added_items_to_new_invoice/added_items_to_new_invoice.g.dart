// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'added_items_to_new_invoice.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddedItemsToNewInvoiceStore on _AddedItemsToNewInvoiceStoreBase, Store {
  Computed<double>? _$totalPriceComputed;

  @override
  double get totalPrice =>
      (_$totalPriceComputed ??= Computed<double>(() => super.totalPrice,
              name: '_AddedItemsToNewInvoiceStoreBase.totalPrice'))
          .value;
  Computed<double Function(double)>? _$vatComputed;

  @override
  double Function(double) get vat =>
      (_$vatComputed ??= Computed<double Function(double)>(() => super.vat,
              name: '_AddedItemsToNewInvoiceStoreBase.vat'))
          .value;
  Computed<double Function(double)>? _$invoiceTotalComputed;

  @override
  double Function(double) get invoiceTotal => (_$invoiceTotalComputed ??=
          Computed<double Function(double)>(() => super.invoiceTotal,
              name: '_AddedItemsToNewInvoiceStoreBase.invoiceTotal'))
      .value;

  final _$itemsAtom = Atom(name: '_AddedItemsToNewInvoiceStoreBase.items');

  @override
  ObservableList<Item> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(ObservableList<Item> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  final _$quantitiesAtom =
      Atom(name: '_AddedItemsToNewInvoiceStoreBase.quantities');

  @override
  ObservableList<int> get quantities {
    _$quantitiesAtom.reportRead();
    return super.quantities;
  }

  @override
  set quantities(ObservableList<int> value) {
    _$quantitiesAtom.reportWrite(value, super.quantities, () {
      super.quantities = value;
    });
  }

  final _$_AddedItemsToNewInvoiceStoreBaseActionController =
      ActionController(name: '_AddedItemsToNewInvoiceStoreBase');

  @override
  dynamic addItem(Item item, int quantity) {
    final _$actionInfo = _$_AddedItemsToNewInvoiceStoreBaseActionController
        .startAction(name: '_AddedItemsToNewInvoiceStoreBase.addItem');
    try {
      return super.addItem(item, quantity);
    } finally {
      _$_AddedItemsToNewInvoiceStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeItemByIndex(int idx) {
    final _$actionInfo =
        _$_AddedItemsToNewInvoiceStoreBaseActionController.startAction(
            name: '_AddedItemsToNewInvoiceStoreBase.removeItemByIndex');
    try {
      return super.removeItemByIndex(idx);
    } finally {
      _$_AddedItemsToNewInvoiceStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic editQuantityByIndex(int quantity, int idx) {
    final _$actionInfo =
        _$_AddedItemsToNewInvoiceStoreBaseActionController.startAction(
            name: '_AddedItemsToNewInvoiceStoreBase.editQuantityByIndex');
    try {
      return super.editQuantityByIndex(quantity, idx);
    } finally {
      _$_AddedItemsToNewInvoiceStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic reset() {
    final _$actionInfo = _$_AddedItemsToNewInvoiceStoreBaseActionController
        .startAction(name: '_AddedItemsToNewInvoiceStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$_AddedItemsToNewInvoiceStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
items: ${items},
quantities: ${quantities},
totalPrice: ${totalPrice},
vat: ${vat},
invoiceTotal: ${invoiceTotal}
    ''';
  }
}
