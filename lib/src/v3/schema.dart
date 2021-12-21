import '../serialization/serializable.dart';

import '_helpers.dart';
import 'external_docs.dart';
import 'property.dart';
import 'reference.dart';

/// OpenAPI v3 schema information.
class Schema extends Serializable {
  Schema(String type,
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs}) {
    assert(isBaseType(type));
    this.type = type;
    if (format != null) this.format = format;
    if (defaultValue != null) this.defaultValue = defaultValue;
    if (title != null) this.title = title;
    if (nullable != null) this.nullable = nullable;
    if (deprecated != null) this.deprecated = deprecated;
    if (example != null) this.example = example;
    if (externalDocs != null) this.externalDocs = externalDocs;
  }

  Schema.reference(
      {String? typeName,
      Reference<Schema>? reference,
      String? title,
      bool? nullable,
      bool? deprecated}) {
    if (reference != null) {
      assert(typeName == null);
      ref = reference.ref;
      _component = reference.component;
    } else {
      assert(typeName != null);
      ref = '#/components/schemas/$typeName';
    }
    if (title != null) this.title = title;
    if (nullable != null) this.nullable = nullable;
    if (deprecated != null) this.deprecated = deprecated;
  }

  Schema.string(
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : this('string',
            format: format,
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Schema.integer(
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : this('integer',
            format: format,
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Schema.number(
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : this('number',
            format: format,
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Schema.boolean(
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : this('boolean',
            format: format,
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Schema.object(
      {dynamic defValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : this('object',
            defaultValue: defValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Schema.array(
      {dynamic defValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : this('array',
            defaultValue: defValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Schema.image(
      {dynamic defValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : this('string',
            format: 'binary',
            defaultValue: defValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Schema.file(
      {dynamic defValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : this('string',
            format: 'binary',
            defaultValue: defValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Schema addProperty(Property property, {bool required = false}) {
    addToMap('properties', property.name, property);
    if (property.hasFile) {
      _hasFile = true;
    }
    if (required) {
      addToList('required', property.name);
    }
    return this;
  }

  Property? getProperty(String name) => getProp('properties')[name];

  set type(String value) => setProp('type', value);
  String get type => getProp('type') ?? '';

  set format(String? value) => setProp('format', value);
  String? get format => getProp('format');

  set ref(String value) => setProp(r'$ref', value);
  set defaultValue(dynamic value) => setProp('default', value);
  set title(String value) => setProp('title', value);
  set nullable(bool value) => setProp('nullable', value);
  set deprecated(bool value) => setProp('deprecated', value);
  set example(String value) => setProp('example', value);
  set externalDocs(ExternalDocs value) => setProp('externalDocs', value);

  set items(Schema value) => setProp('items', value);

  bool? _hasFile;

  bool get hasFile =>
      _component?._hasFile ??
      _hasFile ??
      (type == 'string' && format == 'binary');

  Schema? _component;

  Schema? get component => _component;
}
