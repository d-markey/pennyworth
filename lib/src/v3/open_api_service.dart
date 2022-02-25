import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart' as base;

import '../open_api_service.dart';
import '../specifications/image.dart';
import '../specifications/security_specification.dart';
import '../specifications/type_specification.dart';

import '_helpers.dart';
import '_spec_mapper.dart';
import 'info.dart';
import 'media_type.dart';
import 'open_api_document.dart';
import 'operation.dart';
import 'parameter.dart';
import 'path.dart';
import 'reference.dart';
import 'request_body.dart';
import 'response.dart';
import 'schema.dart';
import 'security_scheme.dart';
import 'server.dart';
import 'tag.dart';

/// Service class for OpenAPI Standard v3.
class OpenApiService implements base.OpenApiService {
  OpenApiService(String title, String version, [this._securityResolver]) {
    _doc = OpenApiDocument(Info(title, version: version));
    registerTypeSpecification<Image>(
        TypeSpecification.string(title: 'Image', format: 'binary'));
  }

  @override
  OpenApiDocument get documentation => _generate();

  late final OpenApiDocument _doc;
  final SecurityResolver? _securityResolver;

  final _documentedRoutes = <base.OpenApiRoute>[];
  final _routes = <base.OpenApiRoute>[];

  @override
  void mount(List<base.OpenApi> api) {
    _routes.addAll(api.expand((item) => item.mount(this)));
  }

  @override
  void addServer(HttpServer server) {
    _doc.addServer(Server('http://localhost:${server.port}'));
  }

  @override
  TypeSpecification registerTypeSpecification<T>(TypeSpecification spec) {
    _doc.components
        .registerSchemaBuilder<T>(() => SpecMapper.buildSchema(spec, this));
    return spec;
  }

  Reference<Schema>? getSchemaRef(Type? type) {
    final ref = _doc.components.getSchemaRef(type.toString());
    return ref;
  }

  Schema? getSchema(Type type) {
    switch (type) {
      case bool:
        return Schema.boolean();
      case int:
        return Schema.integer();
      case double:
        return Schema.number();
      case num:
        return Schema.number();
      case Image:
        return Schema.image();
      case File:
        return Schema.file();
      case String:
        return Schema.string();
      default:
        final ref = getSchemaRef(type);
        if (ref == null) return null;
        return Schema.reference(reference: ref);
    }
  }

  void registerParameter(Parameter parameter) {
    _doc.components.addParameter(parameter);
  }

  OpenApiDocument _generate() {
    _doc.components.generate();
    final securityResolver = _securityResolver;
    while (_routes.isNotEmpty) {
      final route = _routes.removeAt(0);
      _documentedRoutes.add(route);

      final method = route.method;
      if (isValidMethod(method) || method == '*') {
        final path = _getPath(route);
        final operation = _getOperation(route);
        for (var middleware in route.middleware) {
          final securitySpec = (securityResolver == null)
              ? null
              : securityResolver(_doc, middleware);
          if (securitySpec != null) {
            SecurityScheme? securityScheme =
                _doc.components.findSecurityScheme(securitySpec.name);
            Set<String>? scopes;
            if (securityScheme == null) {
              securityScheme =
                  SpecMapper.buildSecuritySpecification(securitySpec);
              if (securityScheme == null) {
                throw AlfredException(HttpStatus.internalServerError,
                    'Unsupported security specification $securitySpec');
              }
              _doc.components.addSecurityScheme(securityScheme);
            } else if (securitySpec is OAuth2Specification) {
              final flows = securityScheme.getFlows();
              if (flows != null) {
                flows.getImplicit()?.mergeScopes(securitySpec.implicit?.scopes);
                flows.getPassword()?.mergeScopes(securitySpec.password?.scopes);
                flows
                    .getClientCredentials()
                    ?.mergeScopes(securitySpec.clientCredentials?.scopes);
                flows
                    .getAuthorizationCode()
                    ?.mergeScopes(securitySpec.authorizationCode?.scopes);
              }
            }
            if (securitySpec is OAuth2Specification) {
              // ignore: prefer_collection_literals
              scopes = Set<String>();
              scopes.addAll(securitySpec.implicit?.scopes.keys ?? []);
              scopes.addAll(securitySpec.password?.scopes.keys ?? []);
              scopes.addAll(securitySpec.clientCredentials?.scopes.keys ?? []);
              scopes.addAll(securitySpec.authorizationCode?.scopes.keys ?? []);
            }
            operation.addSecurity(securityScheme, scopes: scopes);
          }
        }

        if (method == '*') {
          for (var m in supportedMethods) {
            path.addOperation(m, operation);
          }
        } else {
          path.addOperation(method, operation);
        }
      }
    }

    return _doc;
  }

  Path _getPath(base.OpenApiRoute route) {
    final components = route.uri.split('/');
    for (var i = 0; i < components.length; i++) {
      if (components[i].startsWith(':')) {
        final param = components[i].split(':')[1];
        components[i] = '{$param}';
      }
    }

    final url = components.join('/');
    var path = _doc.getPath(url);
    if (path == null) {
      path = Path(url);
      for (var param in route.uriParams) {
        final pathParam = _doc.components.findParameter(param.name) ??
            Parameter(param.name, 'path');
        path.addParameter(pathParam);
      }
      _doc.addPath(path);
    }

    return path;
  }

  Operation _getOperation(base.OpenApiRoute route) {
    RequestBody? body;
    if (route.input != null) {
      String mimeType = 'application/json';
      Schema schemaIn = getSchema(route.input!)!;
      switch (route.input) {
        case Image:
          mimeType = 'image/*';
          break;
        case File:
          mimeType = 'application/octet-stream';
          break;
        default:
          if (schemaIn.hasFile) mimeType = 'multipart/form-data';
          break;
      }

      body = RequestBody();
      body.addContent(MediaType(mimeType, schemaIn));
    }

    Response? response;
    if (route.output != null) {
      String mimeType = 'application/json';
      Schema schemaOut = getSchema(route.output!)!;
      switch (route.output) {
        case Image:
          mimeType = 'image/*';
          break;
        case File:
          mimeType = 'application/octet-stream';
          break;
      }
      response = Response();
      response.addContent(MediaType(mimeType, schemaOut));
    }

    final operation = Operation(
      requestBody: body,
      summary: route.summary,
      deprecated: route.deprecated,
      operationId: route.operationId,
    );
    if (response != null) operation.addResponse('2xx', response);

    for (var tagName in route.tags) {
      var tag = _doc.getTag(tagName);
      if (tag == null) {
        tag = Tag(tagName);
        _doc.addTag(tag);
      }
      operation.addTag(tag);
    }

    return operation;
  }
}
