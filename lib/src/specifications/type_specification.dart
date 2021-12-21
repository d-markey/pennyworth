import 'dart:io';

import 'property_specification.dart';
import 'image.dart';

class TypeSpecification {
  TypeSpecification(this.type, {this.title, this.nullable, this.deprecated})
      : items = null,
        format = null,
        mimeType = null;

  TypeSpecification.object(
      {this.title, Type? type, this.nullable, this.deprecated})
      : type = type ?? Object,
        items = null,
        format = null,
        mimeType = null;

  TypeSpecification.array(
      {this.title, required this.items, this.nullable, this.deprecated})
      : type = List,
        format = null,
        mimeType = null;

  TypeSpecification.string(
      {this.title, this.format, this.nullable, this.deprecated})
      : type = String,
        items = null,
        mimeType = null;

  TypeSpecification.integer(
      {this.title, this.format, this.nullable, this.deprecated})
      : type = int,
        items = null,
        mimeType = null;

  TypeSpecification.double({this.title, this.nullable, this.deprecated})
      : type = double,
        items = null,
        format = null,
        mimeType = null;

  TypeSpecification.boolean({this.title, this.nullable, this.deprecated})
      : type = bool,
        items = null,
        format = null,
        mimeType = null;

  TypeSpecification.image({this.title, this.nullable, this.deprecated})
      : type = Image,
        items = null,
        format = 'binary',
        mimeType = 'image/*';

  TypeSpecification.file(this.mimeType,
      {this.title, this.nullable, this.deprecated})
      : type = File,
        items = null,
        format = 'binary';

  TypeSpecification.reference(this.type)
      : format = null,
        title = null,
        nullable = null,
        deprecated = null,
        items = null,
        mimeType = null;

  final Type type;
  final String? format;
  final String? title;
  final bool? nullable;
  final bool? deprecated;
  final TypeSpecification? items;
  final String? mimeType;

  final List<PropertySpecification> properties = <PropertySpecification>[];

  TypeSpecification addProperty(PropertySpecification prop) {
    properties.add(prop);
    return this;
  }
}
