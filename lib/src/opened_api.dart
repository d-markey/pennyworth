import 'package:alfred/alfred.dart';

import 'open_api_route.dart';
import 'open_api_service.dart';

abstract class OpenedApi {
  List<OpenApiRoute> mount(OpenApiService openApiService);
}

abstract class NestedOpenedApi {
  List<OpenApiRoute> mount(
      NestedRoute parentRoute, OpenApiService openApiService);
}

abstract class OpenedApiMountPoint extends OpenedApi {
  OpenedApiMountPoint(this._apis);

  final List<NestedOpenedApi> _apis;

  NestedRoute get mountPoint;

  @override
  List<OpenApiRoute> mount(OpenApiService openApiService) {
    final routes = <OpenApiRoute>[];
    for (var api in _apis) {
      routes.addAll(api.mount(mountPoint, openApiService));
    }
    return routes;
  }
}
