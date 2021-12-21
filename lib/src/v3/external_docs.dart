import '../serialization/serializable.dart';

class ExternalDocs extends Serializable {
  ExternalDocs(String url, {String? description}) {
    this.url = url;
    if (description != null) this.description = description;
  }

  set url(String value) => setProp('name', value);
  set description(String value) => setProp('description', value);
}
