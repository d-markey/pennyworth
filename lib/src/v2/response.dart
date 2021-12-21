import '../serialization/serializable.dart';
import 'schema.dart';

/// Swagger response information.
class Response extends Serializable {
  Response({String? description, Schema? schema}) {
    if (description != null) this.description = description;
  }

  set description(String value) => setProp('description', value);
  set schema(Schema value) => setProp('schema', value);
}
