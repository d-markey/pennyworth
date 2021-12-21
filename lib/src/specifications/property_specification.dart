import 'type_specification.dart';

class PropertySpecification extends TypeSpecification {
  PropertySpecification(Type type, this.name,
      {String? title, bool? nullable, bool? deprecated, this.required = false})
      : super(type, title: title, nullable: nullable, deprecated: deprecated);

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

  PropertySpecification.boolean(this.name,
      {String? title, bool? nullable, bool? deprecated, this.required = false})
      : super.boolean(title: title, nullable: nullable, deprecated: deprecated);

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

  PropertySpecification.image(this.name,
      {String? title, bool? nullable, bool? deprecated, this.required = false})
      : super.image(title: title, nullable: nullable, deprecated: deprecated);

  PropertySpecification.file(this.name,
      {String? title, bool? nullable, bool? deprecated, this.required = false})
      : super.file(null,
            title: title, nullable: nullable, deprecated: deprecated);

  @override
  PropertySpecification addProperty(PropertySpecification prop) {
    properties.add(prop);
    return this;
  }

  final String name;
  final bool required;
}
