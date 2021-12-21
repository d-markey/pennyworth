import '../serialization/serializable.dart';

/// OpenAPI v3 variable information.
class Variable extends Serializable {
  Variable(this.name, {required dynamic defaultValue, String? description}) {
    if (defaultValue != null) this.defaultValue = defaultValue;
    if (description != null) this.description = description;
  }

  final String name;

  Variable addEnum(String enumValue) {
    addToList('enums', enumValue);
    return this;
  }

  set defaultValue(String value) => setProp('default', value);
  set description(String value) => setProp('description', value);
}
