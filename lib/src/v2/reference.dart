import '../serialization/serializable.dart';

/// Swagger reference information.
class Reference extends Serializable {
  Reference(String ref) {
    this.ref = ref;
  }

  String get ref => getProp(r'$ref');
  set ref(String value) => setProp(r'$ref', value);
}
