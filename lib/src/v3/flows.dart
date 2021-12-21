import '../serialization/serializable.dart';

import 'flow.dart';

class Flows extends Serializable {
  Flows(
      {Flow? implicit,
      Flow? password,
      Flow? clientCredentials,
      Flow? authorizationCode}) {
    assert((implicit ?? password ?? clientCredentials ?? authorizationCode) !=
        null);
    if (implicit != null) this.implicit = implicit;
    if (password != null) this.password = password;
    if (clientCredentials != null) this.clientCredentials = clientCredentials;
    if (authorizationCode != null) this.authorizationCode = authorizationCode;
  }

  set implicit(Flow value) => setProp('implicit', value);
  set password(Flow value) => setProp('password', value);
  set clientCredentials(Flow value) => setProp('clientCredentials', value);
  set authorizationCode(Flow value) => setProp('authorizationCode', value);

  Flow? getImplicit() => getProp('implicit') as Flow?;
  Flow? getPassword() => getProp('password') as Flow?;
  Flow? getClientCredentials() => getProp('clientCredentials') as Flow?;
  Flow? getAuthorizationCode() => getProp('authorizationCode') as Flow?;
}
