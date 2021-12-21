import '../serialization/serializable.dart';

class Contact extends Serializable {
  Contact({String? name, String? email, String? url}) {
    assert((name ?? email ?? url) != null);
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (url != null) this.url = url;
  }

  set name(String value) => setProp('name', value);
  set email(String value) => setProp('name', value);
  set url(String value) => setProp('name', value);
}
