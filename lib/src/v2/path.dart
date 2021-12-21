import '../serialization/serializable.dart';

import '_helpers.dart';
import 'operation.dart';
import 'parameter.dart';

class Path extends Serializable {
  Path(this.path, {String? summary, String? description}) {
    assert(path.startsWith('/'));
    if (summary != null) this.summary = summary;
    if (description != null) this.description = description;
  }

  final String path;

  Path addOperation(String method, Operation operation) {
    assert(isValidMethod(method));
    setProp(method, operation);
    return this;
  }

  Path addParameter(Parameter parameter) {
    addToList<dynamic>('parameters', parameter);
    return this;
  }

  set summary(String value) => setProp('summary', value);
  set description(String value) => setProp('description', value);
}
