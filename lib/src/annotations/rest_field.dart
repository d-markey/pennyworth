class RestField {
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

  static const RestField ignore = RestField._ignore();

  final bool ignored;

  final String? title;
  final List<String>? tags;

  final String? format;
  final String? mimeType;
  final bool? nullable;
  final bool? required;
}
