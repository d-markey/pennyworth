import 'package:pennyworth/pennyworth.dart' as base;

import '../serialization/serializable.dart';
import '../extensions.dart';

import 'components.dart';
import 'external_docs.dart';
import 'info.dart';
import 'path.dart';
import 'server.dart';
import 'tag.dart';

/// OpenAPI v3 document.
class OpenApiDocument extends Serializable implements base.ApiSpecification {
  OpenApiDocument(Info info, {ExternalDocs? externalDocs}) {
    version = '3.0.0';
    this.info = info;
    if (externalDocs != null) this.externalDocs = externalDocs;
  }

  OpenApiDocument addPath(Path path) {
    addToMap('paths', path.path, path);
    return this;
  }

  Path? getPath(String path) {
    return getProp('paths')?[path];
  }

  OpenApiDocument addServer(Server server) {
    addToList('servers', server);
    return this;
  }

  Components get components {
    var components = getProp('components');
    if (components == null) {
      components = Components();
      setProp('components', components);
    }
    return components;
  }

  OpenApiDocument addTag(Tag tag) {
    addToList('tags', tag);
    return this;
  }

  Tag? getTag(String tag) {
    return (getProp('tags') as List<Tag>?)?.firstOrNull((t) => t.name == tag);
  }

  set version(String value) => setProp('openapi', value);
  set info(Info value) => setProp('info', value);
  set externalDocs(ExternalDocs value) => setProp('externalDocs', value);
}
