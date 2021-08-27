// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_invoices.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MyInvoices on _MyInvoicesBase, Store {
  final _$myInvoicesAtom = Atom(name: '_MyInvoicesBase.myInvoices');

  @override
  List<Invoice> get myInvoices {
    _$myInvoicesAtom.reportRead();
    return super.myInvoices;
  }

  @override
  set myInvoices(List<Invoice> value) {
    _$myInvoicesAtom.reportWrite(value, super.myInvoices, () {
      super.myInvoices = value;
    });
  }

  final _$_MyInvoicesBaseActionController =
      ActionController(name: '_MyInvoicesBase');

  @override
  dynamic jsonToInvoicesList(dynamic json) {
    final _$actionInfo = _$_MyInvoicesBaseActionController.startAction(
        name: '_MyInvoicesBase.jsonToInvoicesList');
    try {
      return super.jsonToInvoicesList(json);
    } finally {
      _$_MyInvoicesBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic resetList() {
    final _$actionInfo = _$_MyInvoicesBaseActionController.startAction(
        name: '_MyInvoicesBase.resetList');
    try {
      return super.resetList();
    } finally {
      _$_MyInvoicesBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
myInvoices: ${myInvoices}
    ''';
  }
}
