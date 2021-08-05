// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CustomerStore on _CustomerStoreBase, Store {
  final _$customersAtom = Atom(name: '_CustomerStoreBase.customers');

  @override
  List<Customer> get customers {
    _$customersAtom.reportRead();
    return super.customers;
  }

  @override
  set customers(List<Customer> value) {
    _$customersAtom.reportWrite(value, super.customers, () {
      super.customers = value;
    });
  }

  final _$_CustomerStoreBaseActionController =
      ActionController(name: '_CustomerStoreBase');

  @override
  dynamic setCustomers(List<Customer> value) {
    final _$actionInfo = _$_CustomerStoreBaseActionController.startAction(
        name: '_CustomerStoreBase.setCustomers');
    try {
      return super.setCustomers(value);
    } finally {
      _$_CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
customers: ${customers}
    ''';
  }
}
