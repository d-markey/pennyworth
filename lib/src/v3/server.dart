import '../serialization/serializable.dart';
import 'variable.dart';

class Server extends Serializable {
  Server(String url, {String? description}) {
    this.url = url;
    if (description != null) this.description = description;
  }

  Server addVariable(Variable variable) {
    addToMap('variables', variable.name, variable);
    return this;
  }

  set url(String value) => setProp('url', value);
  set description(String value) => setProp('description', value);
}
