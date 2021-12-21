import 'dart:io';

import 'package:pennyworth/pennyworth.dart' as base;

import '../specifications/image.dart';
import 'flow.dart';
import 'flows.dart';
import 'open_api_service.dart';
import 'property.dart';
import 'schema.dart';
import 'security_scheme.dart';

/// Class mapping version-agnostic specifications to OpenAPI v3 information.
class SpecMapper {
  static Schema buildSchema(
      base.TypeSpecification spec, OpenApiService openApiService,
      {bool withRef = false}) {
    switch (spec.type) {
      case List:
        final schema = Schema.array(
            title: spec.title,
            nullable: spec.nullable,
            deprecated: spec.deprecated);
        final ref = openApiService.getSchemaRef(spec.items!.type);
        if (ref != null) {
          schema.items = Schema.reference(reference: ref);
        } else {
          schema.items = buildSchema(spec.items!, openApiService);
        }
        return schema;
      case bool:
        return Schema.boolean(
            title: spec.title,
            format: spec.format,
            nullable: spec.nullable,
            deprecated: spec.deprecated);
      case int:
        return Schema.integer(
            title: spec.title,
            format: spec.format,
            nullable: spec.nullable,
            deprecated: spec.deprecated);
      case num:
        return Schema.number(
            title: spec.title,
            format: spec.format,
            nullable: spec.nullable,
            deprecated: spec.deprecated);
      case double:
        return Schema.number(
            title: spec.title,
            format: spec.format,
            nullable: spec.nullable,
            deprecated: spec.deprecated);
      case String:
        return Schema.string(
            title: spec.title,
            format: spec.format,
            nullable: spec.nullable,
            deprecated: spec.deprecated);
      case Image:
        return Schema.string(
            format: 'binary',
            title: spec.title,
            nullable: spec.nullable,
            deprecated: spec.deprecated);
      case File:
        return Schema.string(
            format: 'binary',
            title: spec.title,
            nullable: spec.nullable,
            deprecated: spec.deprecated);
    }

    if (withRef) {
      final ref = openApiService.getSchemaRef(spec.type);
      if (ref != null) {
        return Schema.reference(
            reference: ref,
            title: spec.title,
            nullable: spec.nullable,
            deprecated: spec.deprecated);
      }
    }

    final schema = Schema.object(
        title: spec.title,
        nullable: spec.nullable,
        deprecated: spec.deprecated);
    _buildProperties(schema, spec.properties, openApiService);
    return schema;
  }

  static void _buildProperties(
      Schema schema,
      List<base.PropertySpecification> properties,
      OpenApiService openApiService) {
    for (var p in properties) {
      Property prop;
      switch (p.type) {
        case List:
          prop = Property.array(p.name);
          prop.items = buildSchema(p.items!, openApiService, withRef: true);
          break;
        case bool:
          prop = Property.boolean(p.name);
          break;
        case int:
          prop = Property.integer(p.name);
          break;
        case num:
          prop = Property.number(p.name);
          break;
        case double:
          prop = Property.number(p.name);
          break;
        case String:
          prop = Property.string(p.name);
          break;
        case Image:
          prop = Property.image(p.name);
          break;
        case File:
          prop = Property.file(p.name);
          break;
        default:
          final ref = openApiService.getSchemaRef(p.type);
          if (ref != null) {
            prop = Property.reference(p.name, reference: ref);
          } else {
            prop = Property(p.name, 'object');
            _buildProperties(prop, p.properties, openApiService);
          }
          break;
      }
      if (p.title != null) prop.title = p.title!;
      if (p.nullable != null) prop.nullable = p.nullable!;
      if (p.deprecated != null) prop.deprecated = p.deprecated!;
      schema.addProperty(prop);
    }
  }

  static Flow? _getFlowSpecification(base.OAuth2FlowSpecification? flowSpec) {
    if (flowSpec != null) {
      final flow = Flow(
          authorizationUrl: flowSpec.authorizationUrl,
          tokenUrl: flowSpec.tokenUrl,
          refreshUrl: flowSpec.refreshUrl);
      flow.mergeScopes(flowSpec.scopes);
      return flow;
    } else {
      return null;
    }
  }

  static Flows _getFlowsSpecifications(
      base.OAuth2FlowSpecification? implicitSpec,
      base.OAuth2FlowSpecification? passwordSpec,
      base.OAuth2FlowSpecification? clientCredentialsSpec,
      base.OAuth2FlowSpecification? authorizationCodeSpec) {
    Flow? implicit = _getFlowSpecification(implicitSpec);
    Flow? password = _getFlowSpecification(passwordSpec);
    Flow? clientCredentials = _getFlowSpecification(clientCredentialsSpec);
    Flow? authorizationCode = _getFlowSpecification(authorizationCodeSpec);
    return Flows(
        implicit: implicit,
        password: password,
        clientCredentials: clientCredentials,
        authorizationCode: authorizationCode);
  }

  static SecurityScheme? buildSecuritySpecification(
      base.SecuritySpecification securitySpec) {
    if (securitySpec is base.ApiKeySpecification) {
      return SecurityScheme.apiKey(securitySpec.name, securitySpec.location,
          keyName: securitySpec.apiKeyName,
          description: securitySpec.description);
    } else if (securitySpec is base.HttpSpecification) {
      return SecurityScheme.http(securitySpec.name, securitySpec.scheme,
          bearerFormat: securitySpec.bearerFormat,
          description: securitySpec.description);
    } else if (securitySpec is base.OAuth2Specification) {
      final flows = _getFlowsSpecifications(
          securitySpec.implicit,
          securitySpec.password,
          securitySpec.clientCredentials,
          securitySpec.authorizationCode);
      return SecurityScheme.oauth2(securitySpec.name, flows,
          description: securitySpec.description);
    } else if (securitySpec is base.OpenIdConnectSpecification) {
      return SecurityScheme.openIdConnect(
          securitySpec.name, securitySpec.openIdConnectUrl,
          description: securitySpec.description);
    } else {
      return null;
    }
  }
}
