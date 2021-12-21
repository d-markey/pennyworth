import 'type_specification.dart';

/// Base class for OpenAPI property specifications (version agnostic).
class PropertySpecification extends TypeSpecification {
  PropertySpecification(Type type, this.name,
      {String? title, bool? nullable, bool? deprecated, this.required = false})
      : super(type, title: title, nullable: nullable, deprecated: deprecated);

  /// Constructor for array property specification.
  PropertySpecification.array(this.name,
      {String? title,
      bool? nullable,
      bool? deprecated,
      this.required = false,
      required TypeSpecification items})
      : super.array(
            items: items,
            title: title,
            nullable: nullable,
            deprecated: deprecated);

  /// Constructor for boolean property specification.
  PropertySpecification.boolean(this.name,
      {String? title, bool? nullable, bool? deprecated, this.required = false})
      : super.boolean(title: title, nullable: nullable, deprecated: deprecated);

  /// Constructor for integer property specification.
  PropertySpecification.integer(this.name,
      {String? title,
      String? format,
      bool? nullable,
      bool? deprecated,
      this.required = false})
      : super.integer(
            title: title,
            format: format,
            nullable: nullable,
            deprecated: deprecated);

  /// Constructor for floating-point (double) property specification.
  PropertySpecification.double(this.name,
      {String? title,
      String? format,
      bool? nullable,
      bool? deprecated,
      this.required = false})
      : super.integer(
            title: title,
            format: format,
            nullable: nullable,
            deprecated: deprecated);

  /// Constructor for string property specification.
  PropertySpecification.string(this.name,
      {String? title,
      String? format,
      bool? nullable,
      bool? deprecated,
      this.required = false})
      : super.string(
            title: title,
            format: format,
            nullable: nullable,
            deprecated: deprecated);

  /// Constructor for custom type property specification.
  PropertySpecification.object(this.name,
      {String? title,
      String? format,
      bool? nullable,
      bool? deprecated,
      this.required = false,
      Type? type})
      : super.object(
            title: title,
            type: type,
            nullable: nullable,
            deprecated: deprecated);

  /// Constructor for image property specification.
  PropertySpecification.image(this.name,
      {String? title, bool? nullable, bool? deprecated, this.required = false})
      : super.image(title: title, nullable: nullable, deprecated: deprecated);

  /// Constructor for file property specification.
  PropertySpecification.file(this.name,
      {String? title, bool? nullable, bool? deprecated, this.required = false})
      : super.file(null,
            title: title, nullable: nullable, deprecated: deprecated);

  @override
  PropertySpecification addProperty(PropertySpecification prop) {
    properties.add(prop);
    return this;
  }

  /// The property name.
  final String name;

  /// Whether the property is required or not.
  final bool required;
}
