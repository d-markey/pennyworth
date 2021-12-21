import '../serialization/serializable.dart';

import '_helpers.dart';

class SecurityDefinition extends Serializable {
  SecurityDefinition._(this.name);

  static final SecurityDefinition none = SecurityDefinition._('');

  SecurityDefinition.apiKey(this.name, String location,
      {required String keyName, String? description}) {
    assert(isValidLocation(location) && location != 'path');
    _type = 'apiKey';
    this.keyName = keyName;
    this.location = location;
    if (description != null) this.description = description;
  }

  SecurityDefinition.basic(this.name, {String? description}) {
    _type = 'basic';
    if (description != null) this.description = description;
  }

  SecurityDefinition.oauth2(this.name, String flow, {String? description}) {
    _type = 'oauth2';
    this.flow = flow;
    if (description != null) this.description = description;
  }

  final String name;

  set _type(String value) {
    assert(isValidSecuritySchemeType(value));
    setProp('type', value);
  }

  set location(String value) {
    assert(isValidLocation(value) && value != 'path');
    setProp('in', value);
  }

  SecurityDefinition addScope(String name, String description) {
    addToMap('scopes', name, description);
    return this;
  }

  SecurityDefinition mergeScopes(Map<String, String>? scopes) {
    if (scopes != null) {
      for (var entry in scopes.entries) {
        addScope(entry.key, entry.value);
      }
    }
    return this;
  }

  set keyName(String value) => setProp('name', value);
  set description(String value) => setProp('description', value);

  set flow(String value) => setProp('flow', value);
  set authorizationUrl(String value) => setProp('authorizationUrl', value);
  set tokenUrl(String value) => setProp('tokenUrl', value);
}
