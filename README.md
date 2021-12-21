# pennyworth

Code generator + OpenAPI support for Alfred.

# Usage

Pennyworth provides annotations to mark REST services and entities :

* `@RestEntity` + `@RestField` for data structures
* `@RestService` + `@RestOperation` for REST APIs

Annotations can be interpreted with package `pennyworth_builder` in order to generate code to:

* bind service methods with Alfred routes
* build OpenAPI specifications for Swagger UI

A minimal sample is available from https://github.com/d-markey/pennyworth_sample.

