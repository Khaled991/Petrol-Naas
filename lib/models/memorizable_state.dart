class MemorizableState<T> {
  T? pervious;
  T? current;
  MemorizableState({
    this.pervious,
    this.current,
  });

  resetState() {
    this.pervious = null;
    this.current = null;
  }

  @override
  String toString() =>
      'MemorizableState(pervious: $pervious, current: $current)';
}
