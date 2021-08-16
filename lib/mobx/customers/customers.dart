import 'package:mobx/mobx.dart';
import 'package:petrol_naas/models/customer.dart';
part 'customers.g.dart';

class CustomerStore = _CustomerStoreBase with _$CustomerStore;

abstract class _CustomerStoreBase with Store {
  @observable
  List<Customer> customers = [];

  @action
  setCustomers(List<Customer> value) => customers = value;

  @action
  List<String> getCustomersNames(List<Customer> customers) {
    return customers
        .map((Customer customer) => customer.accName ?? "")
        .toList();
  }
}
