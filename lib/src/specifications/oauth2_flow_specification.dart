/// Base class for OpenAPI OAuth2 flow specifications (version agnostic).
class OAuth2FlowSpecification {
  OAuth2FlowSpecification(
      {this.authorizationUrl, this.tokenUrl, this.refreshUrl});

  final String? authorizationUrl;
  final String? tokenUrl;
  final String? refreshUrl;

  final Map<String, String> scopes = <String, String>{};

  OAuth2FlowSpecification addScope(String name, String label) {
    scopes[name] = label;
    return this;
  }
}
