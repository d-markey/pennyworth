import 'package:test/test.dart';

import 'serialization_test_suite.dart' as serialization_tests;

void main() {
  group('Swagger (Open Api v2) tests', () {});

  group('Open Api v3 tests', () {});

  group('Serializers', () {
    serialization_tests.run();
  });
}
