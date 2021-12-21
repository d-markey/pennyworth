import 'dart:io';

import 'property_specification.dart';
import 'image.dart';

/// Base class for OpenAPI type specifications (version agnostic).
class TypeSpecification {
  TypeSpecification(this.type, {this.title, this.nullable, this.deprecated})
      : items = null,
        format = null,
        mimeType = null;

  /// Constructor for custom object type specification.
  TypeSpecification.object(
      {this.title, Type? type, this.nullable, this.deprecated})
      : type = type ?? Object,
        items = null,
        format = null,
        mimeType = null;

  /// Constructor for array type specification.
  TypeSpecification.array(
      {this.title, required this.items, this.nullable, this.deprecated})
      : type = List,
        format = null,
        mimeType = null;

  /// Constructor for string specification.
  TypeSpecification.string(
      {this.title, this.format, this.nullable, this.deprecated})
      : type = String,
        items = null,
        mimeType = null;

  /// Constructor for integer specification.
  TypeSpecification.integer(
      {this.title, this.format, this.nullable, this.deprecated})
      : type = int,
        items = null,
        mimeType = null;

  /// Constructor for floating-point specification.
  TypeSpecification.double({this.title, this.nullable, this.deprecated})
      : type = double,
        items = null,
        format = null,
        mimeType = null;

  /// Constructor for boolean specification.
  TypeSpecification.boolean({this.title, this.nullable, this.deprecated})
      : type = bool,
        items = null,
        format = null,
        mimeType = null;

  /// Constructor for image specification.
  TypeSpecification.image({this.title, this.nullable, this.deprecated})
      : type = Image,
        items = null,
        format = 'binary',
        mimeType = 'image/*';

  /// Constructor for file specification.
  TypeSpecification.file(this.mimeType,
      {this.title, this.nullable, this.deprecated})
      : type = File,
        items = null,
        format = 'binary';

  /// Constructor for reference specification.
  TypeSpecification.reference(this.type)
      : format = null,
        title = null,
        nullable = null,
        deprecated = null,
        items = null,
        mimeType = null;

  /// The actual Dart type mapped associated with this specification.
  final Type type;

  /// How the value should be formatted.
  final String? format;

  /// A description of the type.
  final String? title;

  /// Whether the type is nullable.
  final bool? nullable;

  /// Whether the type is deprecated.
  final bool? deprecated;

  /// For arrays, type specification of array items.
  final TypeSpecification? items;

  /// For files & images, the MIME type of the file.
  final String? mimeType;

  /// Property specifications.
  final List<PropertySpecification> properties = <PropertySpecification>[];

  /// Adds a property specification.
  TypeSpecification addProperty(PropertySpecification prop) {
    properties.add(prop);
    return this;
  }
}
