import 'dart:async';
import 'dart:io';

import 'specifications/security_specification.dart';
import 'specifications/type_specification.dart';
import 'specifications/api_specification.dart';
import 'opened_api.dart';

typedef AlfredMiddleware = FutureOr Function(HttpRequest req, HttpResponse res);

typedef SecurityResolver = SecuritySpecification? Function(
    ApiSpecification, AlfredMiddleware);

/// Base class for OpenAPI service.
/// See implementation in v2 (OpenAPI Standard v2 aka Swagger) and v3 (OpenAPI Standard v3).
abstract class OpenApiService {
  /// API documentation
  ApiSpecification get documentation;

  /// Registers OpenAPI service specifications.
  void mount(List<OpenApi> api);

  /// Sets REST API server.
  void addServer(HttpServer server);

  /// Registers OpenAPI type specifications.
  TypeSpecification registerTypeSpecification<T>(TypeSpecification spec);
}
