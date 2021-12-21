class RestOperation {
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

  const RestOperation.tags(this.tags)
      : httpMethod = null,
        uri = null,
        operationId = null,
        summary = null,
        input = null,
        output = null,
        middleware = null;

  const RestOperation.middleware(this.middleware)
      : httpMethod = null,
        uri = null,
        operationId = null,
        summary = null,
        input = null,
        output = null,
        tags = null;

  static const RestOperation get = RestOperation(method: 'get');
  static const RestOperation post = RestOperation(method: 'post');
  static const RestOperation put = RestOperation(method: 'put');
  static const RestOperation patch = RestOperation(method: 'patch');
  static const RestOperation delete = RestOperation(method: 'delete');

  final String? httpMethod;
  final String? uri;
  final String? operationId;
  final String? summary;
  final List<String>? tags;
  final Type? input;
  final Type? output;
  final List<List>? middleware;
}
