import 'package:mobx/mobx.dart';
import 'package:petrol_naas/models/user.dart';
part 'user.g.dart';

class UserStore = _UserStoreBase with _$UserStore;

abstract class _UserStoreBase with Store {
  @observable
  User user = User();

  @action
  setUser(User value) => user = value;
}
