/// Base class for OpenAPI specifications (version agnostic).
abstract class ApiSpecification {
  String toJson();
  String toYaml();
}
