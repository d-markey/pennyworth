/// Annotation for REST operations, i.e. methods that implement a REST API.
/// Several annotations may be used together to fully qualify the REST operation.
class RestOperation {
  /// General purpose constructor.
  const RestOperation(
      {String? method,
      this.uri,
      this.operationId,
      this.summary,
      this.tags,
      this.input,
      this.output,
      this.middleware})
      : httpMethod = method;

  /// Constructor specifying tags only.
  const RestOperation.tags(this.tags)
      : httpMethod = null,
        uri = null,
        operationId = null,
        summary = null,
        input = null,
        output = null,
        middleware = null;

  /// Constructor specifying middleware only.
  const RestOperation.middleware(this.middleware)
      : httpMethod = null,
        uri = null,
        operationId = null,
        summary = null,
        input = null,
        output = null,
        tags = null;

  /// Constant for the `GET` HTTP method.
  static const RestOperation get = RestOperation(method: 'get');

  /// Constant for the `POST` HTTP method.
  static const RestOperation post = RestOperation(method: 'post');

  /// Constant for the `PUT` HTTP method.
  static const RestOperation put = RestOperation(method: 'put');

  /// Constant for the `PATCH` HTTP method.
  static const RestOperation patch = RestOperation(method: 'patch');

  /// Constant for the `DELETE` HTTP method.
  static const RestOperation delete = RestOperation(method: 'delete');

  /// The HTTP method for the REST API.
  final String? httpMethod;

  /// The URI of the REST API.
  final String? uri;

  /// The
  final String? operationId;

  /// A description of the REST API.
  final String? summary;

  /// Tags associated with the REST API.
  final List<String>? tags;

  /// The type of the input JSON message (typically, a class marked as a REST Entity).
  final Type? input;

  /// The type of the output JSON message (typically, a class marked as a REST Entity).
  final Type? output;

  /// List of operation-level middleware.
  final List<List>? middleware;
}
