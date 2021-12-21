import 'package:alfred/alfred.dart';

import 'open_api_service.dart';

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

  final HttpRoute route;
  final Type? input;
  final Type? output;

  final String? operationId;
  final String? summary;
  final bool? deprecated;

  List<String>? _tags;

  Iterable<String> get tags => _tags ?? [];

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

  String get uri => route.route;

  Iterable<HttpRouteParam> get uriParams => route.params;

  Iterable<AlfredMiddleware> get middleware => route.middleware;
}
