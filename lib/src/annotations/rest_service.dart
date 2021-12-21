/// Annotation for REST services, i.e. classes that implement the methods for REST APIs.
/// Several annotations may be used together to fully qualify the REST service.
class RestService {
  /// General purpose constructor.
  const RestService(String uri, {this.title, this.tags, this.middleware})
      // ignore: prefer_initializing_formals
      : uri = uri;

  /// Constructor specifying middleware only.
  const RestService.middleware(this.middleware)
      : uri = null,
        title = null,
        tags = null;

  /// The base URI of the service.
  final String? uri;

  /// A description of the service.
  final String? title;

  /// Tags associated with the service.
  final List<String>? tags;

  /// List of service-level middleware.
  final List<List>? middleware;
}
