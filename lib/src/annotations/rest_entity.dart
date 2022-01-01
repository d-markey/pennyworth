/// Annotation for REST entities, i.e. JSON data structures sent to/from REST APIs.
/// Several annotations may be used together to fully qualify the REST entity.
class RestEntity {
  /// General purpose constructor.
  const RestEntity({this.title, this.tags, this.autoSerialize});

  /// Constant to disable code generation for auto-de/serialization methods
  static const noAutoSerialization = RestEntity(autoSerialize: false);

  /// Constant to force code generation for auto-de/serialization methods
  static const autoSerialization = RestEntity(autoSerialize: true);

  /// A description for the REST entity
  final String? title;

  /// Tags associated with the REST entity
  final List<String>? tags;

  /// Whether Pennyworth should generate JSON de/serialization methods
  final bool? autoSerialize;
}
