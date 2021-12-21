import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart' as base;

import '../specifications/image.dart';
import '../specifications/type_specification.dart';
import '_helpers.dart';
import '_spec_mapper.dart';
import 'info.dart';
import 'open_api_document.dart';
import 'operation.dart';
import 'parameter.dart';
import 'path.dart';
import 'reference.dart';
import 'response.dart';
import 'schema.dart';
import 'security_definition.dart';
import 'tag.dart';

class OpenApiService implements base.OpenApiService {
  OpenApiService(String title, String version, this._securityResolver) {
    _doc = OpenApiDocument(Info(title, version: version));
    registerTypeSpecification<Image>(
        TypeSpecification.string(title: 'Image', format: 'binary'));
  }

  @override
  OpenApiDocument get documentation => _generate();

  late final OpenApiDocument _doc;
  final base.SecuritySpecification? Function(
      OpenApiDocument, base.AlfredMiddleware) _securityResolver;

  final _documentedRoutes = <base.OpenApiRoute>[];
  final _routes = <base.OpenApiRoute>[];

  @override
  void mount(base.OpenedApi api) {
    _routes.addAll(api.mount(this));
  }

  @override
  void addServer(HttpServer server) {
    _doc.host = 'localhost:${server.port}';
    _doc.basePath = '/';
    _doc.addScheme('http');
  }

  // void registerSchema<T>(Schema schema, [Type? type]) {
  //   type ??= T;
  //   _doc.addSchema(type.toString(), schema);
  // }

  @override
  TypeSpecification registerTypeSpecification<T>(TypeSpecification spec) {
    // final schema = SpecMapper.buildSchema(spec, this);
    _doc.registerSchemaBuilder<T>(() => SpecMapper.buildSchema(spec, this));
    return spec;
  }

  Reference? getSchemaRef(Type? type) {
    final ref = _doc.getSchemaRef(type.toString());
    // if (ref == null) throw AlfredException(500, 'Unknown schema $type');
    return ref;
  }

  Schema getSchema(Type? type) {
    switch (type) {
      case null:
        return Schema.object();
      case bool:
        return Schema.boolean();
      case int:
        return Schema.integer();
      case double:
        return Schema.number();
      case num:
        return Schema.number();
      case String:
        return Schema.string();
      default:
        return Schema.reference(reference: getSchemaRef(type));
    }
  }

  Schema getArraySchema<T>({Type? type, String? title, bool? nullable}) {
    type ??= T;
    final array = Schema.array(title: title, nullable: nullable);
    array.items = getSchema(type);
    return array;
  }

  void registerParameter(Parameter parameter) {
    _doc.addParameter(parameter);
  }

  OpenApiDocument _generate() {
    _doc.generate();
    while (_routes.isNotEmpty) {
      final route = _routes.removeAt(0);
      _documentedRoutes.add(route);

      final method = route.method;
      if (isValidMethod(method) || method == '*') {
        final path = _getPath(route);
        final operation = _getOperation(route);
        for (var middleware in route.middleware) {
          final securitySpec = _securityResolver(_doc, middleware);
          if (securitySpec != null) {
            SecurityDefinition? securityScheme =
                _doc.findSecurityDefinition(securitySpec.name);
            if (securityScheme == null) {
              securityScheme =
                  SpecMapper.buildSecuritySpecification(securitySpec);
              if (securityScheme == null) {
                throw AlfredException(HttpStatus.internalServerError,
                    'Unsupported security specification $securitySpec');
              }
              _doc.addSecurityDefinition(securityScheme);
            } else if (securitySpec is base.OAuth2Specification) {
              securityScheme
                  .mergeScopes(securitySpec.implicit?.scopes)
                  .mergeScopes(securitySpec.password?.scopes)
                  .mergeScopes(securitySpec.clientCredentials?.scopes)
                  .mergeScopes(securitySpec.authorizationCode?.scopes);
            }
            operation.addSecurity(securityScheme);
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
        final pathParam =
            _doc.findParameter(param.name) ?? Parameter(param.name, 'path');
        path.addParameter(pathParam);
      }
      _doc.addPath(path);
    }

    return path;
  }

  Operation _getOperation(base.OpenApiRoute route) {
    Schema? schemaIn;
    if (route.input != null) {
      switch (route.input) {
        case bool:
          schemaIn = Schema.boolean();
          break;
        case int:
          schemaIn = Schema.integer();
          break;
        case double:
          schemaIn = Schema.number();
          break;
        case num:
          schemaIn = Schema.number();
          break;
        case String:
          schemaIn = Schema.string();
          break;
        default:
          schemaIn = getSchema(route.input!);
          break;
      }
    }

    Response? response;
    if (route.output != null) {
      Schema schemaOut;
      switch (route.output) {
        case bool:
          schemaOut = Schema.boolean();
          break;
        case int:
          schemaOut = Schema.integer();
          break;
        case double:
          schemaOut = Schema.number();
          break;
        case num:
          schemaOut = Schema.number();
          break;
        case String:
          schemaOut = Schema.string();
          break;
        default:
          schemaOut = getSchema(route.output!);
          break;
      }
      response = Response();
      response.schema = schemaOut;
    }

    final operation = Operation(
      summary: route.summary,
      deprecated: route.deprecated,
      operationId: route.operationId,
    );

    if (schemaIn != null) {}

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
