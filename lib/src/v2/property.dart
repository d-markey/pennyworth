import 'external_docs.dart';
import 'reference.dart';
import 'schema.dart';

/// Swagger property information.
class Property extends Schema {
  Property(this.name, String type,
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : super(type,
            format: format,
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Property.string(this.name,
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : super.string(
            format: format,
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Property.integer(this.name,
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : super.integer(
            format: format,
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Property.number(this.name,
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : super.number(
            format: format,
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Property.dateTime(this.name,
      {dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : super.string(
            format: 'date-time',
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Property.boolean(this.name,
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : super.boolean(
            format: format,
            defaultValue: defaultValue,
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Property.array(this.name,
      {String? format,
      dynamic defaultValue,
      String? title,
      bool? nullable,
      bool? deprecated,
      String? example,
      ExternalDocs? externalDocs})
      : super.array(
            title: title,
            nullable: nullable,
            deprecated: deprecated,
            example: example,
            externalDocs: externalDocs);

  Property.reference(this.name,
      {String? typeName, Reference? reference, bool? nullable})
      : super.reference(
            typeName: typeName, reference: reference, nullable: nullable);

  final String name;
}
