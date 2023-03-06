import 'json_serializer.dart';
import 'serialization_exception.dart';
import 'yaml_serializer.dart';

enum Mode { json, yaml }

/// Returns true if [value] is natively serializable (ie [value] is a [String], a [num]
/// or a [bool]).
bool isScalar(dynamic value) =>
    value == null || value is String || value is num || value is bool;

/// Base class for serializable data structures.
abstract class Serializable {
  final _map = <String, dynamic>{};

  /// Sets [property] field with [value].
  void setProp(String property, dynamic value) {
    if (value == null) {
      _map.remove(property);
    } else {
      _map[property] = value;
    }
  }

  /// Adds [value] to the [property] list.
  void addToList<T>(String property, T value) {
    if (value != null) {
      _map.putIfAbsent(property, () => <T>[]).add(value);
    }
  }

  /// Sets entry [key] with [value] in the [property] map.
  void addToMap<T>(String property, String key, T value) {
    final map = _map.putIfAbsent(property, () => <String, T>{});
    if (value == null) {
      map.remove(key);
    } else {
      map[key] = value;
    }
  }

  /// Returns the value of [property].
  dynamic getProp(String property) => _map[property];

  /// JSON serialization
  String toJson() =>
      JsonSerializer(indent: '   ').serialize(_serialize(Mode.json));

  /// YAML serialization
  String toYaml() =>
      YamlSerializer(indent: '  ').serialize(_serialize(Mode.yaml));

  Map<String, dynamic> _serialize(Mode mode) => __serialize(_map, mode);
}

dynamic __serialize(dynamic value, Mode mode) {
  if (isScalar(value)) return value;
  if (value is Serializable) return value._serialize(mode);
  if (value is Iterable<dynamic>) return value._serialize(mode);
  if (value is Map<String, dynamic>) return value._serialize(mode);
  throw SerializationException.unsupported(value);
}

bool __isSerializable(dynamic value) => (value is MapEntry<String, dynamic>)
    ? __isSerializable(value.value)
    : ((value is Map<String, dynamic>) ||
        (value is Iterable<dynamic>) ||
        (value is Serializable) ||
        isScalar(value));

extension _ListSerialization on Iterable {
  Iterable _whereSerializable() => where(__isSerializable);

  List _serialize(Mode mode) =>
      List.from(_whereSerializable().map((e) => __serialize(e, mode)));
}

extension _MapSerialization on Map<String, dynamic> {
  Iterable<MapEntry<String, dynamic>> _whereSerializable() =>
      entries.where(__isSerializable);

  Map<String, dynamic> _serialize(Mode mode) =>
      Map.fromEntries(_whereSerializable()
          .map((p) => MapEntry(p.key, __serialize(p.value, mode))));
}
