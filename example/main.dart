import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart';
import 'package:pennyworth/open_api_v3.dart' as v3;
import 'package:pennyworth/open_api_v2.dart' as v2;

import 'hello_api.dart';
import 'math_api.dart';

void main(List<String> args) async {
  startServer();
}

void startServer() async {
  final app = Alfred();

  app.typeHandlers.insert(0, openApiTypeHandler);

  // final openApiService = setupOpenApiDocumentation_v2(app);   // Swagger (OpenAPI v2)
  final openApiService = setupOpenApiDocumentation_v3(app); // OpenAPI v3

  openApiService.mount([
    MathApi(app.route('/math')),
    HelloApi(app.route('/hello')),
    SwaggerApi(app.route('/dev/open-api'), openApiService,
        Directory('assets/swagger-ui-4.1.2/')),
  ]);

  final server = await app.listen(8080);

  openApiService.addServer(server);

  app.printRoutes();
}

// ignore: non_constant_identifier_names
OpenApiService setupOpenApiDocumentation_v3(Alfred app) {
  final openApiService = v3.OpenApiService('Example API backend', 'v1');

  return openApiService;
}

// ignore: non_constant_identifier_names
OpenApiService setupOpenApiDocumentation_v2(Alfred app) {
  final openApiService = v2.OpenApiService('Example API backend', 'v1');

  return openApiService;
}
