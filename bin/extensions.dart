// ignore: prefer_void_to_null
Null _null() => null;

bool _notNull(dynamic x) => x != null;

bool _notEmpty(dynamic x) {
  if (x == null) return false;
  if (x is Map) return x.isNotEmpty;
  if (x is String) return x.isNotEmpty;
  if (x is Iterable) return x.isNotEmpty;
  return false;
}

extension NullableExt<T> on Iterable<T?> {
  Iterable<T> whereNotNull() => where(_notNull).cast<T>();

  Iterable<T> whereNotEmpty() => where(_notEmpty).cast<T>();
}

extension NonNullableExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get singleOrNull => isEmpty ? null : single;

  T? firstOrNullWhere(bool Function(T) predicate) => cast<T?>().firstWhere((x) => predicate(x!), orElse: _null);
  T? singleOrNullWhere(bool Function(T) predicate) => cast<T?>().singleWhere((x) => predicate(x!), orElse: _null);
}
