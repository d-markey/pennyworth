// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'math_service.dart';

// **************************************************************************
// RestServiceGenerator
// **************************************************************************

// REST Service MathService

// ignore: camel_case_extensions
extension MathService_MounterExt on NestedRoute {
  static Future _process(HttpRequest req, HttpResponse res,
      FutureOr Function(HttpRequest req, HttpResponse res) body) async {
    try {
      var ret = body(req, res);
      if (ret is Future) {
        ret = await ret;
      }
      return ret;
    } on AlfredException {
      rethrow;
    } catch (ex) {
      throw AlfredException(
          HttpStatus.internalServerError, 'Internal Server Error');
    }
  }

  // ignore: non_constant_identifier_names
  List<OpenApiRoute> mount_MathService(
      MathService api, OpenApiService openApiService) {
    // mount operations on the service's base URI
    final mountPoint = route('/', middleware: const <AlfredMiddleware>[]);
    final tags = ['MATH'];
    return <OpenApiRoute>[
      OpenApiRoute(
          mountPoint.get(
            '/add/:a:int/:b:int',
            (req, res) => _process(req, res, (req, res) async {
              final a = req.params['a'];
              final b = req.params['b'];
              return await api.add(a, b);
            }),
          ),
          summary: 'Returns a + b',
          operationId: 'MathService.add',
          output: int,
          tags: tags),
      OpenApiRoute(
          mountPoint.get(
            '/sub/:a:int/:b:int',
            (req, res) => _process(req, res, (req, res) async {
              final a = req.params['a'];
              final b = req.params['b'];
              return await api.sub(a, b);
            }),
          ),
          summary: 'Returns a - b',
          operationId: 'MathService.sub',
          output: int,
          tags: tags),
      OpenApiRoute(
          mountPoint.get(
            '/mul/:a:int/:b:int',
            (req, res) => _process(req, res, (req, res) async {
              final a = req.params['a'];
              final b = req.params['b'];
              return await api.mul(a, b);
            }),
          ),
          summary: 'Returns a * b',
          operationId: 'MathService.mul',
          output: int,
          tags: tags),
      OpenApiRoute(
          mountPoint.get(
            '/div/:a:int/:b:int',
            (req, res) => _process(req, res, (req, res) async {
              final a = req.params['a'];
              final b = req.params['b'];
              return await api.div(a, b);
            }),
          ),
          summary: 'Returns a / b',
          operationId: 'MathService.div',
          output: double,
          tags: tags),
      OpenApiRoute(
          mountPoint.get(
            '/sqrt/:x:double',
            (req, res) => _process(req, res, (req, res) async {
              final x = req.params['x'];
              return await api.sqrt(x);
            }),
          ),
          summary: 'Returns sqrt(x)',
          operationId: 'MathService.sqrt',
          output: double,
          tags: tags)
    ];
  }
}
