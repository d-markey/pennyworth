import '../serialization/serializable.dart';

class License extends Serializable {
  License(String name, {String? url}) {
    this.name = name;
    if (url != null) this.url = url;
  }

  set name(String value) => setProp('name', value);
  set url(String value) => setProp('url', value);
}
