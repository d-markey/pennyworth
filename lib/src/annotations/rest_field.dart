/// Annotation for REST fields, i.e. attributes of REST entities.
/// By default, Pennyworth considers all public fields (including inherited fields) as part of the data structure.
/// `@RestField.ignore` can be used to exclude a field from the JSON message.
/// Several annotations may be used together to fully qualify the REST field.
class RestField {
  /// General purpose constructor.
  const RestField(
      {this.title,
      this.tags,
      this.format,
      this.mimeType,
      this.nullable,
      this.required})
      : ignored = false;

  const RestField._ignore()
      : format = null,
        mimeType = null,
        nullable = null,
        required = null,
        tags = null,
        title = null,
        ignored = true;

  /// Annotation to exclude a field from a REST entity.
  static const RestField ignore = RestField._ignore();

  /// Whether the field should be ignored or not.
  final bool ignored;

  /// Description of the field.
  final String? title;

  /// Tags associated with the field.
  final List<String>? tags;

  /// How the field value's should be formatted.
  final String? format;

  /// MIME type associated with the field.
  final String? mimeType;

  /// Whether the field value can be null.
  final bool? nullable;

  /// Whether the field is required in the payload or not. By default, non-nullable field are required and non-nullable fields are not.
  final bool? required;
}
