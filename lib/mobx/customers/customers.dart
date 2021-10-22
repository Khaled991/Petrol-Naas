import 'package:mobx/mobx.dart';
import 'package:petrol_naas/models/customer.dart';
part 'customers.g.dart';

class CustomerStore = _CustomerStoreBase with _$CustomerStore;

abstract class _CustomerStoreBase with Store {
  @observable
  List<Customer> customers = [];

  @action
  setCustomers(dynamic customersList) =>
      customers = prepareCustomersList(customersList);

  List<Customer> prepareCustomersList(dynamic customersList) {
    List<Customer> customers = List<Customer>.from(
      customersList.map(
        (customer) => Customer.fromJson(customer),
      ),
    );
    return customers;
  }
}
