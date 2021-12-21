import 'package:pennyworth/pennyworth.dart' as base;

import '../serialization/serializable.dart';
import '../extensions.dart';

import 'external_docs.dart';
import 'info.dart';
import 'parameter.dart';
import 'path.dart';
import 'reference.dart';
import 'schema.dart';
import 'security_definition.dart';
import 'tag.dart';

class OpenApiDocument extends Serializable implements base.ApiSpecification {
  OpenApiDocument(Info info, {ExternalDocs? externalDocs}) {
    version = '2.0.0';
    this.info = info;
    if (externalDocs != null) this.externalDocs = externalDocs;
  }

  final Map<String, Schema Function()> _builders =
      <String, Schema Function()>{};

  void registerSchemaBuilder<T>(Schema Function() builder) {
    _builders[T.toString()] = builder;
  }

  void generate() {
    for (var entry in _builders.entries) {
      addToMap('definitions', entry.key, entry.value());
    }
    _builders.clear();
  }

  OpenApiDocument addPath(Path path) {
    addToMap('paths', path.path, path);
    return this;
  }

  Path? getPath(String path) {
    return getProp('paths')?[path];
  }

  OpenApiDocument addScheme(String scheme) {
    addToList('schemes', scheme);
    return this;
  }

  OpenApiDocument addSchema(String name, Schema schema) {
    addToMap('definitions', name, schema);
    return this;
  }

  Schema? findSchema(String name) {
    var value = getProp('definitions')?[name];
    if (value != null) return value;
    value = _builders[name];
    if (value != null) return value();
    print('schema $name not found, stacktrace = ${StackTrace.current}');
    return null;
  }

  Reference? getSchemaRef(String name) {
    var schema = findSchema(name);
    if (schema == null) return null;
    return Reference('#/definitions/$name');
  }

  OpenApiDocument addParameter(Parameter parameter) {
    addToMap('parameters', parameter.name, parameter);
    return this;
  }

  OpenApiDocument addConsumes(String consumes) {
    addToList('consumes', consumes);
    return this;
  }

  OpenApiDocument addProduces(String produces) {
    addToList('produces', produces);
    return this;
  }

  Parameter? findParameter(String name) {
    return getProp('parameters')?[name];
  }

  OpenApiDocument addSecurityDefinition(SecurityDefinition security) {
    addToMap('securityDefinitions', security.name, security);
    return this;
  }

  SecurityDefinition? findSecurityDefinition(String name) {
    return getProp('securityDefinitions')?[name];
  }

  OpenApiDocument addTag(Tag tag) {
    addToList('tags', tag);
    return this;
  }

  Tag? getTag(String tag) =>
      (getProp('tags') as List<Tag>?)?.firstOrNull((t) => t.name == tag);

  set version(String value) => setProp('swagger', value);
  set info(Info value) => setProp('info', value);
  set host(String value) => setProp('host', value);
  set basePath(String value) => setProp('basePath', value);
  set externalDocs(ExternalDocs value) => setProp('externalDocs', value);
}
