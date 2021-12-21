import 'package:pennyworth/pennyworth.dart' as base;

import 'open_api_service.dart';
import 'property.dart';
import 'schema.dart';
import 'security_definition.dart';

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
        schema.items = buildSchema(spec.items!, openApiService, withRef: true);
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
        // case Image:
        //   prop = Property.image(p.name);
        //   break;
        // case File:
        //   prop = Property.file(p.name);
        //   break;
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

  static void _setOAuth2FlowInfo(SecurityDefinition securityDefinition,
      base.OAuth2FlowSpecification flowSpec) {
    if (flowSpec.authorizationUrl != null) {
      securityDefinition.authorizationUrl = flowSpec.authorizationUrl!;
    }
    if (flowSpec.tokenUrl != null) {
      securityDefinition.tokenUrl = flowSpec.tokenUrl!;
    }
  }

  static SecurityDefinition? _buildOAuth2SecuritySpecification(
      base.OAuth2Specification securitySpec) {
    if (securitySpec.implicit != null) {
      final securityDefinition = SecurityDefinition.oauth2(
          securitySpec.name, 'implicit',
          description: securitySpec.description);
      _setOAuth2FlowInfo(securityDefinition, securitySpec.implicit!);
      return securityDefinition;
    }
    if (securitySpec.password != null) {
      final securityDefinition = SecurityDefinition.oauth2(
          securitySpec.name, 'password',
          description: securitySpec.description);
      _setOAuth2FlowInfo(securityDefinition, securitySpec.password!);
      return securityDefinition;
    }
    if (securitySpec.clientCredentials != null) {
      final securityDefinition = SecurityDefinition.oauth2(
          securitySpec.name, 'application',
          description: securitySpec.description);
      _setOAuth2FlowInfo(securityDefinition, securitySpec.clientCredentials!);
      return securityDefinition;
    }
    if (securitySpec.authorizationCode != null) {
      final securityDefinition = SecurityDefinition.oauth2(
          securitySpec.name, 'accessCode',
          description: securitySpec.description);
      _setOAuth2FlowInfo(securityDefinition, securitySpec.authorizationCode!);
      return securityDefinition;
    }
    return null;
  }

  static SecurityDefinition? buildSecuritySpecification(
      base.SecuritySpecification securitySpec) {
    if (securitySpec is base.ApiKeySpecification) {
      return SecurityDefinition.apiKey(securitySpec.name, securitySpec.location,
          keyName: securitySpec.apiKeyName,
          description: securitySpec.description);
    } else if (securitySpec is base.HttpSpecification &&
        securitySpec.scheme == 'basic') {
      return SecurityDefinition.basic(securitySpec.name,
          description: securitySpec.description);
    } else if (securitySpec is base.OAuth2Specification) {
      return _buildOAuth2SecuritySpecification(securitySpec);
    } else {
      return null;
    }
  }
}
