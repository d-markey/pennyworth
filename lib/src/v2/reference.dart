import '../serialization/serializable.dart';

class Reference extends Serializable {
  Reference(String ref) {
    this.ref = ref;
  }

  String get ref => getProp(r'$ref');
  set ref(String value) => setProp(r'$ref', value);
}
