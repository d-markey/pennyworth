import 'json_serializer.dart';
import 'serialization_exception.dart';
import 'yaml_serializer.dart';

enum Mode { json, yaml }

bool isScalar(dynamic value) =>
    value is String ||
    value is int ||
    value is double ||
    value is num ||
    value is bool;

bool isSerializable(dynamic value) {
  if (value == null) return false;
  if (isScalar(value)) return true;
  if (value is Serializable) return true;
  if (value is Iterable<dynamic>) return true;
  if (value is Map<String, dynamic>) return true;
  return false;
}

String _serializeScalar(dynamic value, Mode mode) {
  if (value is String) {
    if (mode == Mode.yaml && value.contains('#')) {
      return '\'' + value.replaceAll('\'', '\\\'') + '\'';
    } else {
      return value;
    }
  } else if (value is bool) {
    return value ? 'true' : 'false';
  } else {
    return value.toString();
  }
}

dynamic _serialize(dynamic value, Mode mode) {
  if (isScalar(value)) return _serializeScalar(value, mode);
  if (value is Serializable) return value.serialize(mode);
  if (value is Iterable<dynamic>) return value.serialize(mode);
  if (value is Map<String, dynamic>) return value.serialize(mode);
  throw SerializationException(value);
}

extension _ListSerialization on Iterable<dynamic> {
  Iterable whereSerializable() => where((e) => isSerializable(e));
  List serialize(Mode mode) =>
      List.from(whereSerializable().map((e) => _serialize(e, mode)));
}

extension _MapSerialization on Map<String, dynamic> {
  Iterable<MapEntry<String, dynamic>> whereSerializable() =>
      entries.where((e) => isSerializable(e.value));
  Map<String, dynamic> serialize(Mode mode) =>
      Map<String, dynamic>.fromEntries(whereSerializable().map(
          (p) => MapEntry<String, dynamic>(p.key, _serialize(p.value, mode))));
}

abstract class Serializable {
  final _map = <String, dynamic>{};

  void setProp(String property, dynamic value) {
    if (value == null) {
      _map.remove(property);
    } else {
      _map[property] = value;
    }
  }

  void addToList<T>(String property, T value) {
    if (value != null) {
      final list = _map.putIfAbsent(property, () => <T>[]);
      list.add(value);
    }
  }

  void addToMap<T>(String property, String key, T value) {
    final map = _map.putIfAbsent(property, () => <String, T>{});
    if (value == null) {
      map.remove(key);
    } else {
      map[key] = value;
    }
  }

  dynamic getProp(String property) => _map[property];

  Map<String, dynamic> serialize(Mode mode) => _serialize(_map, mode);

  String toJson() =>
      JsonSerializer(indent: '   ').serialize(serialize(Mode.json));

  String toYaml() =>
      YamlSerializer(indent: '  ').serialize(serialize(Mode.yaml));
}
