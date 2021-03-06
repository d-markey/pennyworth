import '../serialization/serializable.dart';

/// Swagger contact information.
class Contact extends Serializable {
  Contact({String? name, String? email, String? url}) {
    assert((name ?? email ?? url) != null);
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (url != null) this.url = url;
  }

  set name(String value) => setProp('name', value);
  set email(String value) => setProp('email', value);
  set url(String value) => setProp('url', value);
}
