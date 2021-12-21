import '../serialization/serializable.dart';

import 'external_docs.dart';
import 'response.dart';
import 'security_definition.dart';
import 'tag.dart';

class Operation extends Serializable {
  Operation(
      {String? summary,
      String? description,
      ExternalDocs? externalDocs,
      String? operationId,
      bool? deprecated}) {
    if (summary != null) this.summary = summary;
    if (description != null) this.description = description;
    if (externalDocs != null) this.externalDocs = externalDocs;
    if (operationId != null) this.operationId = operationId;
    if (deprecated != null) this.deprecated = deprecated;
  }

  Operation addTag(Tag tag) {
    addToList('tags', tag.name);
    return this;
  }

  Operation addResponse(String statusCode, Response response) {
    addToMap('responses', statusCode, response);
    return this;
  }

  Operation addSecurity(SecurityDefinition securityScheme,
      {Iterable<String> scopes = const []}) {
    if (securityScheme.name.isEmpty) {
      addToList('security', {});
    } else {
      addToList('security', {securityScheme.name: scopes});
    }
    return this;
  }

  set summary(String value) => setProp('summary', value);
  set description(String value) => setProp('description', value);
  set externalDocs(ExternalDocs value) => setProp('externalDocs', value);
  set operationId(String value) => setProp('operationId', value);
  set deprecated(bool value) => setProp('deprecated', value);
}
