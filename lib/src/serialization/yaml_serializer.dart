import 'serializable.dart';

class YamlSerializer {
  YamlSerializer({String? indent}) : _indent = indent ?? '  ';

  final String _indent;

  String _serializeScalar(dynamic value) =>
      (value is bool) ? (value ? 'true' : 'false') : value.toString();

  Iterable<String> _serializeList(List<dynamic> list) sync* {
    final firstIndent = '-' + _indent.substring(1);
    for (var value in list) {
      var indent = firstIndent;
      if (isScalar(value)) {
        yield indent + _serializeScalar(value);
      } else if (value is Map<String, dynamic>) {
        for (var line in _serializeMap(value)) {
          yield indent + line;
          indent = _indent;
        }
      } else if (value is List) {
        for (var line in _serializeList(value)) {
          yield indent + line;
          indent = _indent;
        }
      }
    }
  }

  Iterable<String> _serializeMap(Map<String, dynamic> map) sync* {
    for (var entry in map.entries) {
      if (isScalar(entry.value)) {
        yield '${entry.key}: ' + _serializeScalar(entry.value);
      } else if (entry.value is Map) {
        yield '${entry.key}:';
        for (var line in _serializeMap(entry.value)) {
          yield '$_indent$line';
        }
      } else if (entry.value is List) {
        yield '${entry.key}:';
        for (var line in _serializeList(entry.value)) {
          yield '$_indent$line';
        }
      }
    }
  }

  Iterable<String> _serialize(dynamic data) sync* {
    if (isScalar(data)) {
      yield _serializeScalar(data);
    } else if (data is Map<String, dynamic>) {
      for (var line in _serializeMap(data)) {
        yield line;
      }
    } else if (data is List) {
      for (var line in _serializeList(data)) {
        yield line;
      }
    }
  }

  String serialize(Map<String, dynamic> map) => _serialize(map).join('\n');
}
