class MemorizableState<T> {
  T? pervious;
  T? current;
  MemorizableState({
    this.pervious,
    this.current,
  });

  resetState() {
    pervious = null;
    current = null;
  }

  @override
  String toString() =>
      'MemorizableState(pervious: $pervious, current: $current)';
}
