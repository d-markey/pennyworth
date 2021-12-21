import '../serialization/serializable.dart';
import 'media_type.dart';

/// OpenAPI v3 response information.
class Response extends Serializable {
  Response({String? description}) {
    if (description != null) this.description = description;
  }

  Response addContent(MediaType content) {
    addToMap('content', content.type, content);
    return this;
  }

  set description(String value) => setProp('description', value);
}
