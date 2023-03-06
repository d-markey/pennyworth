import 'package:pennyworth/src/serialization/serializable.dart';

class Config extends Serializable {
  Config(String name, dynamic value) {
    setProp(name, value);
  }
}
