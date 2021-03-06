import 'package:mobx/mobx.dart';
import 'package:petrol_naas/models/item.dart';
part 'items.g.dart';

class ItemsStore = _ItemsStoreBase with _$ItemsStore;

abstract class _ItemsStoreBase with Store {
  @observable
  List<Item> items = [];

  @action
  setItems(List<Item> value) => items = value;
}
