/// Annotation for REST entities, i.e. JSON data structures sent to/from REST APIs.
/// Several annotations may be used together to fully qualify the REST entity.
class RestEntity {
  /// General purpose constructor.
  const RestEntity({this.title, this.tags});

  /// A description for the REST entity
  final String? title;

  /// Tags associated with the REST entity
  final List<String>? tags;
}
