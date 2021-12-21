import '../serialization/serializable.dart';

class Reference<T> extends Serializable {
  Reference(String ref, this.component) {
    this.ref = ref;
  }

  final T component;

  String get ref => getProp(r'$ref');
  set ref(String value) => setProp(r'$ref', value);
}
