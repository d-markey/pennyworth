import '../serialization/serializable.dart';

import 'parameter.dart';
import 'reference.dart';
import 'schema.dart';
import 'security_scheme.dart';

/// OpenAPI v3 components information.
class Components extends Serializable {
  final Map<String, Schema Function()> _builders =
      <String, Schema Function()>{};

  /// Generates schemas.
  void generate() {
    var schemas = getProp('schemas');
    if (schemas == null) {
      schemas = <String, Schema>{};
      setProp('schemas', schemas);
    }
    for (var entry in _builders.entries) {
      schemas[entry.key] = entry.value();
    }
    _builders.clear();
  }

  /// Registers a security scheme.
  Components addSecurityScheme(SecurityScheme security) {
    addToMap('securitySchemes', security.name, security);
    return this;
  }

  /// Finds a security scheme.
  SecurityScheme? findSecurityScheme(String name) {
    return getProp('securitySchemes')?[name];
  }

  /// Registers a schema builder. Because schemas may reference one another, builders are registered to defer schema generation when all schemas have been reistered.
  Components registerSchemaBuilder<T>(Schema Function() builder) {
    _builders[T.toString()] = builder;
    return this;
  }

  /// Finds a schema.
  Schema? findSchema(String name) {
    var value = getProp('schemas')?[name];
    if (value != null) return value;
    value = _builders[name];
    if (value != null) return value();
    print('schema $name not found, stacktrace = ${StackTrace.current}');
    return null;
  }

  /// Gets a schema reference.
  Reference<Schema>? getSchemaRef(String name) {
    final schema = findSchema(name);
    if (schema == null) return null;
    return Reference<Schema>('#/components/schemas/$name', schema);
  }

  /// Registers a parameter.
  Components addParameter(Parameter parameter) {
    addToMap('parameters', parameter.name, parameter);
    return this;
  }

  /// Finds a parameter.
  Parameter? findParameter(String name) {
    return getProp('parameters')?[name];
  }
}
