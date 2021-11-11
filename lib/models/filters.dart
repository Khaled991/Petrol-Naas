import 'memorizable_state.dart';

class Filters {
  final MemorizableState<String> firstDate = MemorizableState();
  final MemorizableState<String> lastDate = MemorizableState();
  final MemorizableState<String> custNo = MemorizableState();

  void setFirstDate(String firstDate) {
    this.firstDate.current = firstDate;
  }

  void setLastDate(String lastDate) {
    this.lastDate.current = lastDate;
  }

  void setCustNo(String custNo) {
    this.custNo.current = custNo;
  }

  void resetDateFilter() {
    firstDate.resetState();
    lastDate.resetState();
  }

  void resetCustNoFilter() {
    custNo.resetState();
  }

  void confirmFilters() {
    confirmDateFilter();
    confirmCustomerFilter();
  }

  void confirmDateFilter() {
    firstDate.assignCurrentToPervious();
    lastDate.assignCurrentToPervious();
  }

  void confirmCustomerFilter() {
    custNo.assignCurrentToPervious();
  }

  void cancelFilters() {
    firstDate.assignPerviousToCurrent();
    lastDate.assignPerviousToCurrent();
    custNo.assignPerviousToCurrent();
  }

  bool hasDateFilter() => firstDate.current != null && lastDate.current != null;

  bool hasCustomerSelectedForFilter() => custNo.current != null;

  bool hasCustomerFilter() =>
      custNo.current != null && custNo.current == custNo.pervious;
}
