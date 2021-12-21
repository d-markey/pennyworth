import '../serialization/serializable.dart';

import 'schema.dart';

/// OpenAPI v3 media-type information.
class MediaType extends Serializable {
  MediaType(this.type, Schema schema, {String? example}) {
    this.schema = schema;
    if (example != null) this.example = example;
  }

  final String type;

  set schema(Schema value) => setProp('schema', value);
  set example(String value) => setProp('example', value);
}
