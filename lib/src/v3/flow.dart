import '../serialization/serializable.dart';

class Flow extends Serializable {
  Flow({String? authorizationUrl, String? tokenUrl, String? refreshUrl}) {
    assert((authorizationUrl ?? tokenUrl ?? refreshUrl) != null);
    if (authorizationUrl != null) this.authorizationUrl = authorizationUrl;
    if (tokenUrl != null) this.tokenUrl = tokenUrl;
    if (refreshUrl != null) this.refreshUrl = refreshUrl;
  }

  Flow addScope(String name, String description) {
    addToMap('scopes', name, description);
    return this;
  }

  Flow mergeScopes(Map<String, String>? scopes) {
    if (scopes != null) {
      for (var entry in scopes.entries) {
        addScope(entry.key, entry.value);
      }
    }
    return this;
  }

  set authorizationUrl(String value) => setProp('authorizationUrl', value);
  set tokenUrl(String value) => setProp('tokenUrl', value);
  set refreshUrl(String value) => setProp('refreshUrl', value);
}
