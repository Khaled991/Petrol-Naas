// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ItemsStore on _ItemsStoreBase, Store {
  final _$itemsAtom = Atom(name: '_ItemsStoreBase.items');

  @override
  List<Item> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(List<Item> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  final _$_ItemsStoreBaseActionController =
      ActionController(name: '_ItemsStoreBase');

  @override
  dynamic setItems(List<Item> value) {
    final _$actionInfo = _$_ItemsStoreBaseActionController.startAction(
        name: '_ItemsStoreBase.setItems');
    try {
      return super.setItems(value);
    } finally {
      _$_ItemsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
items: ${items}
    ''';
  }
}
