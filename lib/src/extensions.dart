import 'package:alfred/alfred.dart';

// ignore: prefer_void_to_null
Null _null() => null;

bool _notNull(dynamic x) => (x != null);

bool _notEmpty(dynamic x) {
  if (x == null) return false;
  if (x is String) return x.isNotEmpty;
  if (x is List) return x.isNotEmpty;
  if (x is Map) return x.isNotEmpty;
  return true;
}

extension NotNullExt<T> on Iterable<T?> {
  Iterable<T> whereNotNull() => where(_notNull).cast<T>();
  Iterable<T> whereNotEmpty() => where(_notEmpty).cast<T>();
}

extension NullableExt<T> on Iterable<T> {
  T? firstOrNull([bool Function(T)? predicate]) {
    if (isEmpty) return null;
    return (predicate == null)
        ? first
        : cast<T?>().firstWhere((e) => predicate(e!), orElse: _null);
  }

  T? singleOrNull([bool Function(T)? predicate]) {
    if (isEmpty) return null;
    return (predicate == null)
        ? single
        : cast<T?>().singleWhere((e) => predicate(e!), orElse: _null);
  }
}

extension ForcedHeaders on HttpRequest {
  static const _key = r'$forced_headers';

  void forceHeader(String name, String value) {
    final forcedHeaders = store.getOrSet(_key, () => <String, String>{});
    forcedHeaders[name] = value;
  }

  String? getForcedHeader(String name) {
    final forcedHeaders = store.get(_key);
    return forcedHeaders?[name];
  }
}
