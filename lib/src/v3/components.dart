import '../serialization/serializable.dart';

import 'parameter.dart';
import 'reference.dart';
import 'schema.dart';
import 'security_scheme.dart';

class Components extends Serializable {
  final Map<String, Schema Function()> _builders =
      <String, Schema Function()>{};

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

  Components addSecurityScheme(SecurityScheme security) {
    addToMap('securitySchemes', security.name, security);
    return this;
  }

  SecurityScheme? findSecurityScheme(String name) {
    return getProp('securitySchemes')?[name];
  }

  Components registerSchemaBuilder<T>(Schema Function() builder) {
    _builders[T.toString()] = builder;
    return this;
  }

  Schema? findSchema(String name) {
    var value = getProp('schemas')?[name];
    if (value != null) return value;
    value = _builders[name];
    if (value != null) return value();
    print('schema $name not found, stacktrace = ${StackTrace.current}');
    return null;
  }

  Reference<Schema>? getSchemaRef(String name) {
    final schema = findSchema(name);
    if (schema == null) return null;
    return Reference<Schema>('#/components/schemas/$name', schema);
  }

  Components addParameter(Parameter parameter) {
    addToMap('parameters', parameter.name, parameter);
    return this;
  }

  Parameter? findParameter(String name) {
    return getProp('parameters')?[name];
  }
}
