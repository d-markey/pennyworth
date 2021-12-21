import '../serialization/serializable.dart';

/// OpenAPI v3 external documentation information.
class ExternalDocs extends Serializable {
  ExternalDocs(String url, {String? description}) {
    this.url = url;
    if (description != null) this.description = description;
  }

  /// External URL.
  set url(String value) => setProp('url', value);

  /// Description.
  set description(String value) => setProp('description', value);
}
