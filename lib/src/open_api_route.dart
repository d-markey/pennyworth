import 'package:alfred/alfred.dart';

import 'open_api_service.dart';

/// Wrapper around Alfred's [HttpRoute].
/// The route contains additional information used by the [OpenApiService] to generate OpenAPI specifications useable with Swagger UI.
class OpenApiRoute {
  OpenApiRoute(this.route,
      {this.input,
      this.output,
      this.operationId,
      this.summary,
      this.deprecated,
      Iterable<String>? tags}) {
    if (tags?.isNotEmpty ?? false) {
      _tags = tags!.toList();
    }
  }

  /// Alfred's route.
  final HttpRoute route;

  /// Type of the class mapped from the input JSON message.
  final Type? input;

  /// Type of the class mapped to the output JSON message.
  final Type? output;

  /// The route's operation ID.
  final String? operationId;

  /// A description of the API.
  final String? summary;

  /// Whether the API is deprecated or not.
  final bool? deprecated;

  List<String>? _tags;

  /// Tags associated with the API.
  Iterable<String> get tags => _tags ?? [];

  /// HTTP method for the API.
  String get method {
    switch (route.method) {
      case Method.get:
        return 'get';
      case Method.post:
        return 'post';
      case Method.put:
        return 'put';
      case Method.delete:
        return 'delete';
      case Method.patch:
        return 'patch';
      case Method.options:
        return 'options';
      case Method.head:
        return 'head';
      case Method.copy:
        return 'copy';
      case Method.link:
        return 'link';
      case Method.unlink:
        return 'unlink';
      case Method.purge:
        return 'purge';
      case Method.lock:
        return 'lock';
      case Method.unlock:
        return 'unlock';
      case Method.propfind:
        return 'propfind';
      case Method.view:
        return 'view';
      case Method.all:
        return '*';
    }
  }

  /// URI of the API.
  String get uri => route.route;

  /// URI parameters of the API.
  Iterable<HttpRouteParam> get uriParams => route.params;

  /// List of middleware associated with the API.
  Iterable<AlfredMiddleware> get middleware => route.middleware;
}
