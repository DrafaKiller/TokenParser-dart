extension IterableNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? firstWhereOrNull(bool Function(T element) test) => where(test).firstOrNull;

  T? get lastOrNull => isEmpty ? null : last;
  T? lastWhereOrNull(bool Function(T element) test) => where(test).lastOrNull;
}
