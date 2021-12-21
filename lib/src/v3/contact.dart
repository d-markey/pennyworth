import '../serialization/serializable.dart';

/// OpenAPI v3 contact information.
class Contact extends Serializable {
  Contact({String? name, String? email, String? url}) {
    assert((name ?? email ?? url) != null);
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (url != null) this.url = url;
  }

  /// Contact name.
  set name(String value) => setProp('name', value);

  /// Contact email.
  set email(String value) => setProp('email', value);

  /// Contact URL.
  set url(String value) => setProp('url', value);
}
