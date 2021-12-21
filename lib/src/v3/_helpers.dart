// ignore_for_file: prefer_collection_literals

final _supportedMethods = Set<String>.from(
    ['get', 'post', 'put', 'delete', 'patch', 'options', 'head']);
Iterable<String> get supportedMethods => _supportedMethods;
bool isValidMethod(String method) => _supportedMethods.contains(method);

final _supportedLocations = Set.from(['path', 'query', 'header', 'cookie']);
bool isValidLocation(String location) => _supportedLocations.contains(location);

final _supportedSecuritySchemeTypes =
    Set.from(['apiKey', 'http', 'oauth2', 'openIdConnect']);
bool isValidSecuritySchemeType(String type) =>
    _supportedSecuritySchemeTypes.contains(type);

final _baseTypes =
    Set.from(['string', 'integer', 'number', 'boolean', 'array', 'object']);
bool isBaseType(String type) => _baseTypes.contains(type);
