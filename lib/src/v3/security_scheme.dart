import '../serialization/serializable.dart';

import '_helpers.dart';
import 'flows.dart';

class SecurityScheme extends Serializable {
  SecurityScheme._(this.name);

  static final SecurityScheme none = SecurityScheme._('');

  SecurityScheme.apiKey(this.name, String location,
      {required String keyName, String? description}) {
    assert(isValidLocation(location) && location != 'path');
    _type = 'apiKey';
    this.keyName = keyName;
    this.location = location;
    if (description != null) this.description = description;
  }

  SecurityScheme.http(this.name, String scheme,
      {String? description, String? bearerFormat}) {
    _type = 'http';
    this.scheme = scheme;
    if (bearerFormat != null) this.bearerFormat = bearerFormat;
    if (description != null) this.description = description;
  }

  SecurityScheme.oauth2(this.name, Flows flows, {String? description}) {
    _type = 'oauth2';
    this.flows = flows;
    if (description != null) this.description = description;
  }

  SecurityScheme.openIdConnect(this.name, String openIdConnectUrl,
      {String? description}) {
    _type = 'openIdConnect';
    this.openIdConnectUrl = openIdConnectUrl;
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

  set keyName(String value) => setProp('name', value);
  set scheme(String value) => setProp('scheme', value);
  set description(String value) => setProp('description', value);
  set bearerFormat(String value) => setProp('bearerFormat', value);
  set flows(Flows value) => setProp('flows', value);
  set openIdConnectUrl(String value) => setProp('openIdConnectUrl', value);

  Flows? getFlows() => getProp('flows') as Flows;
}
