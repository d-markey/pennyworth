import '../serialization/serializable.dart';

import 'external_docs.dart';

/// Swagger tag.
class Tag extends Serializable {
  Tag(String name, {String? description, ExternalDocs? externalDocs}) {
    this.name = name;
    if (description != null) this.description = description;
    if (externalDocs != null) this.externalDocs = externalDocs;
  }

  String get name => getProp('name');

  set name(String value) => setProp('name', value);
  set description(String value) => setProp('description', value);
  set externalDocs(ExternalDocs value) => setProp('externalDocs', value);
}
