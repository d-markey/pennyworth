[![Dart Workflow](https://github.com/d-markey/pennyworth/actions/workflows/dart.yml/badge.svg)](https://github.com/d-markey/pennyworth/actions/workflows/dart.yml)
[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)
[![Dart Style](https://img.shields.io/badge/style-lints-40c4ff.svg)](https://pub.dev/packages/lints)
[![Last Commits](https://img.shields.io/github/last-commit/d-markey/pennyworth?logo=git&logoColor=white)](https://github.com/d-markey/pennyworth/commits)
[![Code Size](https://img.shields.io/github/languages/code-size/d-markey/pennyworth?logo=github&logoColor=white)](https://github.com/d-markey/pennyworth)
[![License](https://img.shields.io/github/license/d-markey/pennyworth?logo=open-source-initiative&logoColor=green)](https://github.com/d-markey/pennyworth/blob/master/LICENSE)
[![GitHub Repo Stars](https://img.shields.io/github/stars/d-markey/pennyworth)](https://github.com/d-markey/pennyworth/stargazers)

# Pennyworth

REST Service composition and OpenAPI support for Alfred-based REST APIs.

# Table of Contents

* [Introduction](#intro)
* [Manual Usage](#manual)
  1. [JSON Messages](#manual-entities)
  2. [Services](#manual-services)
  3. [Versionning](#manual-version)
  4. [Start-up](#manual-startup)
* [Usage with Pennyworth Builder](#builder)
  * [REST Entities & Fields](#entities)
  * [REST Services & Operations](#services)
  * [Result](#result)
    1. [JSON Messages](#codegen-entities)
    2. [Services](#codegen-services)
    3. [Versionning](#codegen-version)
    4. [Start-up](#codegen-startup)
* [Middleware & Security](#security)

# <a name="intro"></a>Introduction

Pennyworth is built on top of [Alfred](https://github.com/rknell/alfred) and provides wrappers around Alfred's `NestedRoute` class to help organize and scaffold the REST APIs of your application.

It also implements live OpenAPI documentation based on the actual code of your application, eliminating the need to manually update the OpenAPI specifications. Pennyworth provides a set of classes used to document the routes and JSON messages implemented by your application. The documentation data held by these classes can be transformed into OAS v2 (Swagger) or OAS v3 specification format (in JSON or Yaml).

Pennyworth also implements a REST service to generate the OpenAPI specification file automatically, and even serve Swagger UI files as part of the application (please note that this feature should generally be disabled in production environments). Swagger UI can be used to test your REST APIs; the OpenAPI specification file can be used by client/partners to help generate or implement clients for your APIs.

While Pennyworth can be used manually, it is best used together with [Pennyworth Builder](https://github.com/d-markey/pennyworth_builder). In this scenario, OpenAPI documentation is provided via simple annotations:

* `@RestEntity` + `@RestField` for JSON data structures
* `@RestService` + `@RestOperation` for REST APIs

[Pennyworth Builder](https://github.com/d-markey/pennyworth_builder) will generate the code to document your APIs, serialize/deserialize JSON messages, and integrate your service methods with [Alfred](https://github.com/rknell/alfred). Your code will also be easier to read as documentation information will be held as metadata, separate from actual business code.

A minimal sample is available from https://github.com/d-markey/pennyworth_sample.

# <a name="manual"></a>Manual Usage

Pennyworth must be installed as a runtime dependency of your projet.

To demonstrate how to use Pennyworth, we consider implementing the back-end of a 'To-Do Management' app with the following requirements:
* the back-end will operate on two kinds of business entities: users and to-do items
* APIs operating on these business entities will be grouped in two services: a `User` service and a `ToDo` service
* APIs will be versionned at URL level

The application can be implemented as follow:

1. <a name="manual-entities"></a>JSON mesages, including the code necessary to serialize the data.

```dart
// A to-do item
class ToDoItem {
  ToDoItem({this.title, this.summary, this.done = false});

  final String title;
  final String? summary;
  final bool done;

  // Map transformation to prepare serialization with Alfred
  Map toJson() => {
    'title': title,
    if (summary) 'summary': summary,
    if (done) 'done': true
  };
}

// A user
class User {
  // ...
  // you get the idea
  // ...
}
```

2. <a name="manual-services"></a>The REST Service deriving from Pennyworth's `NestedOpenedApi` and implementing the service methods. The `mount()` method must be overriden in order to bind the service methods with Alfred routes (documenting APIs at the same time), and to document the JSON message structures. This method will be called from the main program upon startup.

```dart
// a service operating on to-do items
class ToDoService extends NestedOpenedApi {

  // in-memory repository for this demo
  final Map<String, ToDoItem> _repo = <String, ToDoItem>{};

  // creates a to-do item
  Future<ToDoItem> createToDoItem(HttpRequest req, HttpResponse res) async {
      // deserialize incoming message, it is expected to have the structure of a ToDoItem
      final json = await req.bodyAsJsonMap;
      final title = (json['title'] ?? '').trim();
      // user input verifications
      if (title.isEmpty) {
        // title is mandatory and cannot be empty
        throw AlfredException(HttpStatus.badRequest, 'Missing title');
      }
      if (_repo.containsKey(title)) {
        // business rule: to-do items are identified by their title
        throw AlfredException(HttpStatus.badRequest, 'To-do item already exists');
      }
      // create to do item
      final todoItem = ToDoItem(title: title, summary: json['summary'], done: json['done'] ?? false);
      _repo[title] = todoItem;
      // send result
      return todoItem;
  }

  // updates a to-do item
  Future<ToDoItem> updateToDoItem(HttpRequest req, HttpResponse res) async {
      // deserialize incoming message, it is expected to have the structure of a ToDoItem
      final json = await req.bodyAsJsonMap;
      final title = (json['title'] ?? '').trim();
      // user input verifications
      if (title.isEmpty) {
        // title is mandatory and cannot be empty
        throw AlfredException(HttpStatus.badRequest, 'Missing title');
      }
      if (!_repo.containsKey(title)) {
        // business rule: to-do items are identified by their title
        throw AlfredException(HttpStatus.notFound, 'To-do item not found');
      }
      // update todo item
      final todoItem = ToDoItem(title: title, summary: json['summary'], done: json['done'] ?? false);
      _repo[title] = todoItem;
      // send result
      return todoItem;
  }

  // ...
  // more services, eg. deletion, list of items, queries...
  // ...

  // this method is called when the server starts up to mount the REST APIs
  // and populate the OpenAPI documentation
  @override
  List<OpenApiRoute> mount(NestedRoute parentRoute, OpenApiService openApiService) {
    // document types used by the REST APIs
    openApiService.registerTypeSpecification<ToDoItem>(
        TypeSpecification.object(title: 'To do item')
            .addProperty(PropertySpecification.string('title', nullable: false))
            .addProperty(PropertySpecification.string('summary', nullable: true, required: false))
            .addProperty(PropertySpecification.boolean('done', nullable: false, required: false)));
    // ...
    // other JSON messages...
    // ...

    // mount REST APIs on segment "/todo"
    final mountPoint = parentRoute.route('/todo');
    return <OpenApiRoute>[
      OpenApiRoute(
          mountPoint.put('/', createToDoItem), // incoming request: PUT /todo => create a to-do item
          summary: 'Create a to-do item',
          operationId: 'todo.create',
          input: ToDoItem,
          output: ToDoItem,
          tags: ['TODO']),
      OpenApiRoute(
          mountPoint.patch('/', updateToDoItem), // incoming request: PATCH /todo => update the to-do item
          summary: 'Update a to-do item',
          operationId: 'tdo.update',
          input: ToDoItem,
          output: ToDoItem,
          tags: ['TODO']),
      // ...
      // other APIs...
      // ...
    ];
  }
}

// a service operating on users
class UserService extends NestedOpenedApi {
  // ...
  // you get the idea
  // ...
}    
```

3. <a name="manual-version"></a>The service container deriving from Pennyworth's `OpenedApiMountPoint`, used for versionning.

```dart
class Version1 extends OpenedApiMountPoint {
  Version1(NestedRoute parent)
      : mountPoint = parent.route('/v1'),   // services will be exposed on the "/v1" segment
        super([
          UserService(),                    // expose User service
          ToDoService()                     // expose ToDo service
        ]);

  @override
  final NestedRoute mountPoint;
}
```

4. <a name="manual-startup"></a>The main program to fire up Alfred, bind REST services and create OpenAPI documentation.

```dart
import 'package:alfred/alfred.dart';
import 'package:pennyworth/open_api_v3.dart' as v3; // OpenAPI Standard v3

void main() {
  // summon Alfred
  final app = Alfred();

  // create a Pennyworth OpenApiService instance
  final openApiService = v3.OpenApiService('ToDo Management', 'v1', null);

  // services hosted in Version1 will be exposed on /api/v1
  final v1 = Version1(app.route('/api'));
  v1.mount(openApiService);

  // install Swagger API (no Swagger UI)
  final swaggerApi = SwaggerApi(app.route('/dev/open-api'), openApiService);
  swaggerApi.mount(openApiService);

  // NOTE:
  // =====
  // a directory containing Swagger UI may be provided to the SwaggerApi service to enable Swagger UI directly from Alfred
  //
  // final swaggerApi = SwaggerApi(app.route('/dev/open-api'), openApiService, Directory('assets/swagger-ui-4.1.2/'));
  //
  // this should be avoided in production unless your API is public or not sensitive

  // handle incoming requests
  final server = await app.listen(8080);

  // register server instance with Pennyworth's OpenAPI service
  openApiService.addServer(server);

  // point your browser to http://localhost:8080/dev/open-api/definition to get your API's OpenAPI specification file 
}
```

While it is possible to use Pennyworth manually, keeping the OpenAPI information up-do-date as your application grows can soon become a challenge. To ease implementation, Pennyworth provides annotations to retain OpenAPI documentation with your service methods and DTO classes. The annotations will be used by [Pennyworth Builder](https://github.com/d-markey/pennyworth_builder) to generate all the technical plumbing code so you can focus on implementing the business part.

# <a name="builder"></a>Usage with Pennyworth Builder

[Pennyworth Builder](https://github.com/d-markey/pennyworth_builder) must be installed as a development dependency and the projet must define a `build.yaml` file to leverage Pennyworth builders. The build configuration is typically:

```yaml
targets:
  $default:
    builders: 
      pennyworth_builder:rest_builder: 
        generate_for: 
         - bin/**
        enabled: true 

builders:
  # name of the builder
  pennyworth_builder:rest_builder:
    # library URI containing the builder
    import: 'package:pennyworth_builder/pennyworth_builder.dart'
    # Name of the function in the above library to call.
    builder_factories: [ 'restServiceBuilder', 'restEntityBuilder' ]
    # The mapping from the source extension to the generated file extension
    build_extensions: { '.dart': [ '.svc.g.dart', '.dto.g.dart' ] }
    # Will automatically run on any package that depends on it
    auto_apply: dependents
    # Generate to a hidden cache dir
    build_to: cache
    # Combine the parts from each builder into one part file.
    applies_builders: ["source_gen|combining_builder"]
```

Before runnng the application, it must be built with :

```shell
dart run build_runner build
```

## <a name="entities"></a>REST Entities & Fields

REST Entities represent the JSON messages exchanged back and forth between clients (typically, a Web or Mobile app) and the API server. Typically, they would be implemented as plain Dart classes and transported as JSON text in request/response bodies.

Pennyworth provides the `@RestEntity` annotation to identify and document these data-structures directly in the source-code. Information passed to the annotation will be used to generate OpenAPI schema specifications which in turn can be used to test APIs in Swagger UI or to generate code for the data-structures in client technology (eg. Java, C#, TypeScript...). Information that can be specified via `@RestEntity`:
* `title`: description of the JSON message
* `tags`: list of tags associated with the JSON message

By default, Pennyworth Builder will take all public fields into account, including fields inherited from parent classes. Fields can be documented with the `@RestField` annotation to provide additional information such as:
* `nullable`: whether the JSON attribute may be null
* `required`: whether the JSON attribute must always be present in the message
* `title`: description of the JSON attribute
* `tags`: list of tags associated with the JSON attribute
* `format`: information on how the JSON attribute's value is formatted
* `mimeType`: MIME type of the value (used with file attributes such as images or documents)

Pennyworth also provides the `@RestField.ignore` constant to exclude a field from the JSON message.

`@RestField` annotations are optional; Pennyworth Builder will infer nullability from the field's type, assuming `nullable: true` if the Dart nullability suffix `?` is present. Similarly, if the `required` property is not specified, its value will be inferred from the `nullable` value by default: `required = !nullable`.

In addition to generating the code to build the OpenAPI documentation of the JSON message, Pennyworth Builder will also generate code to automatically serialize or deserialize JSON messages from /to the Dart class. Using Pennyworth de/serialization code is not mandatory. Serialization may be implemented manually or automatically eg. with the package [JSON ANnotation](https://pub.dev/packages/json_annotation). Future versions of Pennyworth Builder will eventually support configuration options to allow disabling code generation for serialization.

## <a name="services"></a>REST Services & Operations

REST Services represent a set of operations that may be applied to REST Entities. With Pennyworth, REST Services map to classes that implement methods operating on REST Entities. These methods make up the individual REST APIs exposed by the system.

Pennyworth provides the `@RestService` annotation to identify REST Service classes and `@RestOperation` to document methods exposed as REST APIs.

Information that can be specified via `@RestService`:
* `uri`: the base URI for the REST Operations implemented by the service
* `title`: description of the REST Service
* `tags`: list of tags associated with the REST Service
* `middleware`: list of middleware that are common to all REST Operations implemented by the service

Information that can be specified via `@RestOperation`:
* `method`: the HTTP method to use when calling the REST API
* `uri`: the URI for the REST API
* `operationId`: a unique identifier for the REST API
* `title`: description of the REST API
* `summary`: detailed description of the REST API
* `tags`: list of tags associated with the REST API
* `input`: Dart type of the incoming REST Entity (request body)
* `output`: Dart type of the outgoing REST Entity (response body)
* `middleware`: list of middleware specific to the REST API

## <a name="result"></a>Result

1. <a name="codegen-entities"></a>Code to serialize JSON mesages is generated by Pennyworth. Also, documenting fields is not mandatory: Pennyworth Builder will consider all public fields (including those inherited from parent classes), and will infer some properties directly from the code (such as the data type and nullability...). Serialization and deserialization can also be automatically handled via extension methods (you still have to bind with the generated code).

```dart
// A to-do item
@RestEntity('A to-do item')
class ToDoItem {
  ToDoItem({this.title, this.summary, this.done = false});

  final String title;
  final String? summary;
  final bool done;

  // autoSerialize() extension method is generated by Pennyworth Builder
  Map toJson() => autoSerialize();
}

// A user
@RestEntity('A user')
class User {
  // ...
  // you get the idea
  // ...
}
```

2. <a name="codegen-services"></a>Code to mount REST services is generated by Pennyworth Builder and must be bound to the service's `mount()` method. Additionally, Pennyworth Builder can infer input/output types from the service method signatures and provide deserialized messages to your methods if required. The same service method can also be mapped onto multiple HTTP verbs.

```dart
// a service operating on to-do items
@RestService('/todo')
class ToDoService extends NestedOpenedApi {

  // in-memory repository for this demo
  final Map<String, ToDoItem> _repo = <String, ToDoItem>{};

  // creates a to-do item
  @RestOperation.put
  @RestOperation.post
  @RestOperation(uri: '/' title: 'Create a to-do item')
  ToDoItem createToDoItem(ToDoItem input) {
      // user input verifications
      if (input.title.isEmpty) throw AlfredException(HttpStatus.badRequest, 'Missing title');
      if (_repo.containsKey(input.title)) throw AlfredException(HttpStatus.badRequest, 'To-do item already exists');
      // create to do item
      _repo[input.title] = input;
      // send result
      return input;
  }

  // updates a to-do item
  @RestOperation.patch
  @RestOperation(uri: '/', title: 'Update a to-do item')
  ToDoItem updateToDoItem(ToDoItem input) {
      // user input verifications
      if (input.title.isEmpty) throw AlfredException(HttpStatus.badRequest, 'Missing title');
      if (_repo.containsKey(input.title)) throw AlfredException(HttpStatus.notFound, 'To-do item not found');
      // update todo item
      _repo[input.title] = input;
      // send result
      return input;
  }

  // ...
  // more services, eg. deletion, list of items, queries...
  // ...

  @override
  List<OpenApiRoute> mount(
          NestedRoute parentRoute, OpenApiService openApiService) =>
      // mount_ToDoService() extension method is generated by Pennyworth Builder
      parentRoute.mount_ToDoService(this, openApiService);
}

// a service operating on users
@RestService('/user')
class UserService extends NestedOpenedApi {
  // ...
  // you get the idea
  // ...
}    
```

3. <a name="codegen-version"></a>The service container does not change.

```dart
class Version1 extends OpenedApiMountPoint {
  Version1(NestedRoute parent)
      : mountPoint = parent.route('/v1'),   // services will be exposed on the "/v1" segment
        super([
          UserService(),                    // expose User service
          ToDoService()                     // expose ToDo service
        ]);

  @override
  final NestedRoute mountPoint;
}
```

4. <a name="codegen-startup"></a>The main program also remains the same.

```dart
import 'package:alfred/alfred.dart';
import 'package:pennyworth/open_api_v3.dart' as v3; // OpenAPI Standard v3

void main() {
  // summon Alfred
  final app = Alfred();

  // create a Pennyworth OpenApiService instance
  final openApiService = v3.OpenApiService('ToDo Management', 'v1', null);

  // services hosted in Version1 will be exposed on /api/v1
  final v1 = Version1(app.route('/api'));
  v1.mount(openApiService);

  // install Swagger API (no Swagger UI)
  final swaggerApi = SwaggerApi(app.route('/dev/open-api'), openApiService);
  swaggerApi.mount(openApiService);

  // NOTE:
  // =====
  // a directory containing Swagger UI may be provided to the SwaggerApi service to enable Swagger UI directly from Alfred
  //
  // final swaggerApi = SwaggerApi(app.route('/dev/open-api'), openApiService, Directory('assets/swagger-ui-4.1.2/'));
  //
  // this should be avoided in production unless your API is public or not sensitive

  // handle incoming requests
  final server = await app.listen(8080);

  // register server instance with Pennyworth's OpenAPI service
  openApiService.addServer(server);

  // point your browser to http://localhost:8080/dev/open-api/definition to get your API's OpenAPI specification file 
}
```

# <a name="security"></a>Middleware & Security

When a route is triggered in [Alfred](https://www.github.com/rknell/alfred), the execution pipeline will first go through all middleware functions associated with the route (and parent routes) before executing the code of the request handler. This general-purpose design is a typical use-case for security. To document and enforce security schemes in place with your APIs, Pennyworth provides the `middleware` attributes for `@RestService` and `@RestOperation` annotations.

Because Dart functions cannot be used in Dart annotations, applying middleware with Pennyworth requires a class containing the middleware function, and the implementation must follow some guidelines:

* For parameter-less middleware, the class must implement a static `instance` getter returning the middleware function. For instance, the following middleware checks the validity of an API Key passed through the "X-API-Key" header:

```dart
class ApiKeyMiddleware {
  ApiKeyMiddleware._();

  static final _instance = ApiKeyMiddleware._();

  static AlfredMiddleware get instance => _instance._check;

  FutureOr _check(HttpRequest req, HttpResponse res) async {
    final headerValue = req.headers.value('X-API-Key') ?? '';
    final valid = await ApiKeyService.checkApiKey(headerValue);
    if (!valid) {
      req.alfred.logWriter(
          () => 'API key check failed for request ${req.method} ${req.uri}',
          LogType.warn);
      throw AlfredException(HttpStatus.forbidden, 'Invalid API key');
    }
  }
}
```

* For parameterized middleware, the class must implement a static `get` function returning the middleware instance matching the parameter values. For instance, the following middleware checks that a user (validated by a previous middleware function, eg. via OAuth2, and attached to the current request) has a specific role:

```dart
class RoleMiddleware {
  RoleMiddleware._(this.role);

  static final Map<String, RoleMiddleware> _instances = <String, RoleMiddleware>{};

  static AlfredMiddleware get(String role) =>
    _instances.putIfAbsent(role, () => RoleMiddleware._(role))._hasRole;

  final String role;

  FutureOr _hasRole(HttpRequest req, HttpResponse res) async {
    final hasRole = req.user.roles.contains(role);
    if (!hasRole) {
      req.alfred.logWriter(
          () => '$role role check failed for request ${req.method} ${req.uri}',
          LogType.warn);
      throw AlfredException(HttpStatus.forbidden, '$role role required');
    }
  }
}
```

Enforcing the middleware via Pennyworth annotations comes down to passing the type of the middleware class + the parameter value if required.

* Example 1: applying the `ApiKeyMiddleware` at REST Service level:

```dart
@RestService('/todo')
@RestService.middleware([ [ ApiKeyMiddleware ] ]) // will be enforced for all APIs exposed by this service
class ToDoService extends NestedOpenedApi {
  // ...
}
```

* Example 2: applying the `ApiKeyMiddleware` at REST Service level and checking for ADMIN role with the `RoleMiddleware` for the `/lock` operation only:

```dart
@RestService('/user')
@RestService.middleware([ [ ApiKeyMiddleware ] ]) // will be enforced for all APIs exposed by this service
class UserService extends NestedOpenedApi {
  // ...

  @RestOperation.patch
  @RestOperation(uri: '/lock/:userid', title: 'Locks the specified user')
  @RestOperation.middleware([ [ RoleMiddleware, 'ADMIN' ] ]) // will be enforced for this API only
  FutureOr lockUser(String userid) {
    // effectively lock user
  }
}
```

The associated OpenAPI documentation for security schemes must be implemented manually via a resolver function passed when constructing the `OpenApiService`, for instance:

```dart
  final middlewareResolver = MiddlewareResolver();
  final openApiService = v3.OpenApiService('ToDo Management', 'v1', middlewareResolver.resolve);
```

The resolver will be called with the actual middleware function and must provide the OpenAPI security specification if the middleware function was resolved. One possible implementation relies on a static `find()` method provided by middleware classes to identify the owner of the middleware function. If a middleware instance is found, the middleware resolver can then build the OpenAPI specification as in the following example:

```dart
class ApiKeyMiddleware {
  // (middleware implementation skipped)

  // if the middleware function matches, return the instance
  static ApiKeyMiddleware? find(AlfredMiddleware middleware)
    => _instance.check == middleware ? _instance : null;
}

class RoleMiddleware {
  // (middleware implementation skipped)

  // if the middleware function matches, return the instance
  static RoleMiddleware? find(AlfredMiddleware middleware) => _instances.values
      .cast<RoleMiddleware?>().singleWhere((m) => m._hasRole == middleware, orElse: () => null);
}

class MiddlewareResolver {
  SecuritySpecification? resolve(ApiSpecification doc, AlfredMiddleware middleware) {
    final apiKeyMiddleware = ApiKeyMiddleware.find(middleware);
    if (apiKeyMiddleware != null) {
      return ApiKeySpecification('APIKey', 'Api Key security', 'header', 'X-API-Key');
    }
    final roleMiddleware = RoleMiddleware.find(middleware);
    if (roleMiddleware != null) {
      final oauth2 = OAuth2Specification('OAuth2', 'Role-based authorization');
      oauth2.implicit = OAuth2FlowSpecification(authorizationUrl: authorizationUrl);
      oauth2.implicit.addScope(roleMiddleware.role, 'Check for ${roleMiddleware.role} role');
      return oauth2;
    }
    return null;
  }
}
```

A better design would be to implement a `security` property in the middleware class taking responsibility for building the security specification, eg.:

```dart
class ApiKeyMiddleware {
  // (middleware implementation skipped)

  // OpenAPI security specification
  final security = ApiKeySpecification('APIKey', 'Api Key security', 'header', 'X-API-Key');
}

class RoleMiddleware {
  // (middleware implementation skipped)

  // OpenAPI security specification
  final SecuritySpecification get security {
    final oauth2 = OAuth2Specification('OAuth2', 'Role-based authorization');
    oauth2.implicit = OAuth2FlowSpecification(authorizationUrl: authorizationUrl);
    oauth2.implicit.addScope(role, 'Check for ${role} role');
    return oauth2;
  }
}

class MiddlewareResolver {
  // now simply resolve and return the value of the security property
  SecuritySpecification? resolve(ApiSpecification doc, AlfredMiddleware middleware) {
    final apiKeyMiddleware = ApiKeyMiddleware.find(middleware)
    if (apiKeyMiddleware != null) return apiKeyMiddleware.security;
    final roleMiddleware = RoleMiddleware.find(middleware);
    if (roleMiddleware != null) return roleMiddleware.security;
    return null;
  }
}
```

Future versions of Pennyworth might provide a base class for middleware to help support this design, but does not currently enforce a specific design to resolve a middleware function. The only constraint is to have a static `instance` getter for Singleton middleware or a static `get()` method for parameterized middleware.
