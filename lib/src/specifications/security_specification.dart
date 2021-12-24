import 'oauth2_flow_specification.dart';

/// Base class for OpenAPI security specifications (version agnostic).
abstract class SecuritySpecification {
  SecuritySpecification(this.name, this.description);

  final String name;
  final String description;
}

/// OpenAPI - no security (version agnostic).
class NoSecuritySpecification implements SecuritySpecification {
  @override
  String get name => '';

  @override
  String get description => 'no security';
}

/// OpenAPI - API Key security (version agnostic).
class ApiKeySpecification extends SecuritySpecification {
  ApiKeySpecification(
      String name, String description, this.location, this.apiKeyName)
      : super(name, description);

  final String location;
  final String apiKeyName;
}

/// OpenAPI - HTTP security (version agnostic).
class HttpSpecification extends SecuritySpecification {
  HttpSpecification(String name, String description,
      {required this.scheme, this.bearerFormat})
      : super(name, description);

  final String scheme;
  final String? bearerFormat;
}

/// OpenAPI - OAuth2 security (version agnostic).
class OAuth2Specification extends SecuritySpecification {
  OAuth2Specification(String name, String description)
      : super(name, description);

  OAuth2FlowSpecification? implicit;
  OAuth2FlowSpecification? password;
  OAuth2FlowSpecification? clientCredentials;
  OAuth2FlowSpecification? authorizationCode;
}

/// OpenAPI - OpenID security(version agnostic).
class OpenIdConnectSpecification extends SecuritySpecification {
  OpenIdConnectSpecification(
      String name, String description, this.openIdConnectUrl)
      : super(name, description);

  final String openIdConnectUrl;
}
