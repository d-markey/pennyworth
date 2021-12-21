import '../serialization/serializable.dart';

import '_helpers.dart';
import 'schema.dart';

/// OpenAPI v3 parameter information.
class Parameter extends Serializable {
  Parameter(String name, String location,
      {String? description,
      Schema? schema,
      String? format,
      bool? required,
      bool? deprecated}) {
    assert(isValidLocation(location));
    this.name = name;
    this.location = location;
    if (description != null) this.description = description;
    if (schema != null) this.schema = schema;
    if (format != null) this.format = format;
    if (required != null) this.required = required;
    if (deprecated != null) this.deprecated = deprecated;
  }

  @override
  dynamic getProp(String property) {
    if (property == 'required' && location == 'path') {
      return true;
    }
    return super.getProp(property);
  }

  set name(String value) => setProp('name', value);
  String get name => getProp('name');

  set location(String value) {
    assert(isValidLocation(value));
    setProp('in', value);
  }

  String get location => getProp('in');

  set description(String value) => setProp('description', value);
  set schema(Schema value) => setProp('schema', value);
  set format(String value) => setProp('format', value);
  set required(bool value) => setProp('required', value);
  set deprecated(bool value) => setProp('deprecated', value);
}
