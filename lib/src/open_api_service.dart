import 'dart:async';
import 'dart:io';

import 'specifications/type_specification.dart';
import 'specifications/api_specification.dart';
import 'opened_api.dart';

typedef AlfredMiddleware = FutureOr Function(HttpRequest req, HttpResponse res);

abstract class OpenApiService {
  ApiSpecification get documentation;

  void mount(OpenedApi api);
  void addServer(HttpServer server);
  TypeSpecification registerTypeSpecification<T>(TypeSpecification spec);
}
