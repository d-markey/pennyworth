// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hello_service.dart';

// **************************************************************************
// RestEntityGenerator
// **************************************************************************

// REST Entity: UserDto

extension UserDtoRegistrationExt on OpenApiService {
  void registerUserDto() {
    registerTypeSpecification<UserDto>(TypeSpecification.object(
            title: 'User Information')
        .addProperty(
            PropertySpecification.string('name', title: 'Name', required: true))
        .addProperty(PropertySpecification.dateTime('birthDate',
            title: 'Date of birth', nullable: true)));
    registerTypeSpecification<List<UserDto>>(TypeSpecification.array(
        items: TypeSpecification.object(type: UserDto),
        title: 'User Information (array)'));
  }
}

extension UserDtoSerializationExt on UserDto {
  Map<String, dynamic> autoSerialize() => <String, dynamic>{
        'name': name,
        if (birthDate != null) 'birthDate': birthDate?.toIso8601String(),
      };
}

extension UserDtoDeserializationExt on Map<String, dynamic> {
  UserDto autoDeserializeUserDto() {
    return UserDto(this['name'],
        (this['birthDate'] == null) ? null : DateTime.parse(this['birthDate']));
  }
}

extension UserDtoRequestExt on HttpRequest {
  Future<UserDto> getUserDto() async {
    final body = await bodyAsJsonMap;
    return UserDto.fromJson(body);
  }

  Future<List<UserDto>> getListOfUserDto() async {
    final body = await bodyAsJsonList;
    return body
        .map((item) => UserDto.fromJson((item as Map<String, dynamic>)))
        .toList();
  }
}

// **************************************************************************
// RestServiceGenerator
// **************************************************************************

// REST Service HelloService

// ignore: camel_case_extensions
extension HelloService_MounterExt on NestedRoute {
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
  List<OpenApiRoute> mount_HelloService(
      HelloService api, OpenApiService openApiService) {
    // mount operations on the service's base URI
    final mountPoint = route('/', middleware: const <AlfredMiddleware>[]);
    final tags = ['HELLO'];
    return <OpenApiRoute>[
      OpenApiRoute(
          mountPoint.post(
            '/',
            (req, res) => _process(req, res, (req, res) async {
              final input = await req.getUserDto();
              return await api.hello(input);
            }),
          ),
          summary: 'Says hello',
          operationId: 'HelloService.hello',
          input: UserDto,
          output: String,
          tags: tags),
      OpenApiRoute(
          mountPoint.post(
            '/fr',
            (req, res) => _process(req, res, (req, res) async {
              final input = await req.getUserDto();
              return await api.bonjour(input);
            }),
          ),
          summary: 'Says hello in French',
          operationId: 'HelloService.bonjour',
          input: UserDto,
          output: String,
          tags: tags)
    ];
  }
}
