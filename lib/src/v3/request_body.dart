import '../serialization/serializable.dart';

import 'media_type.dart';

class RequestBody extends Serializable {
  RequestBody({String? description, bool? required}) {
    if (description != null) this.description = description;
    if (required != null) this.required = required;
  }

  RequestBody addContent(MediaType content) {
    addToMap('content', content.type, content);
    return this;
  }

  set description(String value) => setProp('description', value);
  set required(bool value) => setProp('required', value);
}
