// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_receipts.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$myReceiptsStore on _myReceiptsStoreBase, Store {
  final _$receiptsAtom = Atom(name: '_myReceiptsStoreBase.receipts');

  @override
  List<CreateReceipt> get receipts {
    _$receiptsAtom.reportRead();
    return super.receipts;
  }

  @override
  set receipts(List<CreateReceipt> value) {
    _$receiptsAtom.reportWrite(value, super.receipts, () {
      super.receipts = value;
    });
  }

  final _$_myReceiptsStoreBaseActionController =
      ActionController(name: '_myReceiptsStoreBase');

  @override
  dynamic jsonToInvoicesList(dynamic json) {
    final _$actionInfo = _$_myReceiptsStoreBaseActionController.startAction(
        name: '_myReceiptsStoreBase.jsonToInvoicesList');
    try {
      return super.jsonToInvoicesList(json);
    } finally {
      _$_myReceiptsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic resetList() {
    final _$actionInfo = _$_myReceiptsStoreBaseActionController.startAction(
        name: '_myReceiptsStoreBase.resetList');
    try {
      return super.resetList();
    } finally {
      _$_myReceiptsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
receipts: ${receipts}
    ''';
  }
}
