import 'serializable.dart';
import 'serialization_exception.dart';

/// YAML serializer.
class YamlSerializer {
  factory YamlSerializer({required String indent}) =>
      _cache.putIfAbsent(indent, () => YamlSerializer._(indent));

  static final _cache = <String, YamlSerializer>{};

  YamlSerializer._(this.indent) : dashIndent = '-${indent.substring(1)}';

  final String indent;
  final String dashIndent;

  String _indent(String line) => '$indent$line';
  String _dashIndent(String line) => '$dashIndent$line';

  /// Serialization of a scalar value.
  String _serializeScalar(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return _escape(value);
    if (value is bool) return value ? 'true' : 'false';
    if (value is num) return value.toString();
    throw SerializationException.unsupported(value);
  }

  /// Serialization of a list.
  Iterable<String> _serializeList(List<dynamic> list) sync* {
    for (var value in list) {
      var indenter = _dashIndent;
      if (isScalar(value)) {
        yield indenter(_serializeScalar(value));
      } else if (value is Map<String, dynamic>) {
        final lines = _serializeMap(value);
        yield* lines
            .take(1)
            .map(_dashIndent)
            .followedBy(lines.skip(1).map(_indent));
      } else if (value is List) {
        final lines = _serializeList(value);
        yield* lines
            .take(1)
            .map(_dashIndent)
            .followedBy(lines.skip(1).map(_indent));
      } else {
        throw SerializationException.unsupported(value);
      }
    }
  }

  /// Serialization of a map.
  Iterable<String> _serializeMap(Map<String, dynamic> map) sync* {
    for (var entry in map.entries) {
      if (isScalar(entry.value)) {
        yield '${entry.key}: ${_serializeScalar(entry.value)}';
      } else if (entry.value is Map) {
        yield '${entry.key}:';
        yield* _serializeMap(entry.value).map(_indent);
      } else if (entry.value is List) {
        yield '${entry.key}:';
        yield* _serializeList(entry.value).map(_indent);
      } else {
        throw SerializationException.unsupported(entry.value);
      }
    }
  }

  /// Serialization of a data structure (scalar, list or map).
  Iterable<String> _serialize(dynamic data) sync* {
    if (isScalar(data)) {
      yield _serializeScalar(data);
    } else if (data is Map<String, dynamic>) {
      yield* _serializeMap(data);
    } else if (data is List) {
      yield* _serializeList(data);
    } else {
      throw SerializationException.unsupported(data);
    }
  }

  /// Serialization implementation.
  String serialize(Map<String, dynamic> map) => _serialize(map).join('\n');

  static final _escDoubleQuote = RegExp('["\\\\]');
  static final _escSingleQuote = RegExp('[#\']');

  static String _escape(String data) {
    if (_escDoubleQuote.hasMatch(data)) {
      return '"${data.replaceAll('\\', '\\\\').replaceAll('"', '\\"')}"';
    } else if (_escSingleQuote.hasMatch(data)) {
      return '\'${data.replaceAll('\'', '\'\'')}\'';
    } else if (data.startsWith('-')) {
      return '\'$data\'';
    } else {
      return data;
    }
  }
}
