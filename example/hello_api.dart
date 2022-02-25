import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart';

import 'hello_service.dart';

class HelloApi extends OpenApiMountPoint {
  HelloApi(NestedRoute parent)
      : mountPoint = parent,
        super([HelloService()]);

  @override
  final NestedRoute mountPoint;
}
