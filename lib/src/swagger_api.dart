import 'dart:io';

import 'package:alfred/alfred.dart';

import 'extensions.dart';
import 'open_api_route.dart';
import 'open_api_service.dart';
import 'opened_api.dart';

class SwaggerApi extends OpenApi {
  SwaggerApi(this._parent, this._openApiService, [this._swaggerUiDir]);

  final NestedRoute _parent;
  final OpenApiService _openApiService;
  final Directory? _swaggerUiDir;

  @override
  List<OpenApiRoute> mount(OpenApiService openApiService) {
    final routes = <OpenApiRoute>[];

    // documented routes

    // undocumented routes
    _parent.get('/definition', (req, res) => _openApiService.documentation);

    _parent.get('/definition.json', (req, res) {
      req.forceHeader(HttpHeaders.acceptHeader, 'application/json');
      return _openApiService.documentation;
    });

    _parent.get('/definition.yaml', (req, res) {
      req.forceHeader(HttpHeaders.acceptHeader, 'application/x-yaml');
      return _openApiService.documentation;
    });

    if (_swaggerUiDir != null) {
      _parent.get('/*', (req, res) => _swaggerUiDir);
    }

    return routes;
  }
}
