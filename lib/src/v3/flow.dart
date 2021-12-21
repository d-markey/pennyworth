import '../serialization/serializable.dart';

/// OpenAPI v3 security flow information.
class Flow extends Serializable {
  Flow({String? authorizationUrl, String? tokenUrl, String? refreshUrl}) {
    assert((authorizationUrl ?? tokenUrl ?? refreshUrl) != null);
    if (authorizationUrl != null) this.authorizationUrl = authorizationUrl;
    if (tokenUrl != null) this.tokenUrl = tokenUrl;
    if (refreshUrl != null) this.refreshUrl = refreshUrl;
  }

  /// Registers a scope with the flow.
  Flow addScope(String name, String description) {
    addToMap('scopes', name, description);
    return this;
  }

  /// Merges scope with the flow.
  Flow mergeScopes(Map<String, String>? scopes) {
    if (scopes != null) {
      for (var entry in scopes.entries) {
        addScope(entry.key, entry.value);
      }
    }
    return this;
  }

  /// Authorization URL.
  set authorizationUrl(String value) => setProp('authorizationUrl', value);

  /// Token URL.
  set tokenUrl(String value) => setProp('tokenUrl', value);

  /// Refresh token URL.
  set refreshUrl(String value) => setProp('refreshUrl', value);
}
