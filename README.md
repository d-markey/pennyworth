[![Dart Workflow](https://github.com/d-markey/pennyworth/actions/workflows/dart.yml/badge.svg)](https://github.com/d-markey/pennyworth/actions/workflows/dart.yml)
[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)
[![Dart Style](https://img.shields.io/badge/style-lints-40c4ff.svg)](https://pub.dev/packages/lints)
[![Last Commits](https://img.shields.io/github/last-commit/d-markey/pennyworth?logo=git&logoColor=white)](https://github.com/d-markey/pennyworth/commits)
[![Code Size](https://img.shields.io/github/languages/code-size/d-markey/pennyworth?logo=github&logoColor=white)](https://github.com/d-markey/pennyworth)
[![License](https://img.shields.io/github/license/d-markey/pennyworth?logo=open-source-initiative&logoColor=green)](https://github.com/d-markey/pennyworth/blob/master/LICENSE)
[![GitHub Repo Stars](https://img.shields.io/github/stars/d-markey/pennyworth)](https://github.com/d-markey/pennyworth/stargazers)

# Pennyworth

Code generator + OpenAPI support for Alfred-based REST APIs.

# Usage

Pennyworth completes Alfred with annotations to mark REST services and entities :

* `@RestEntity` + `@RestField` for data structures
* `@RestService` + `@RestOperation` for REST APIs

Annotations can be interpreted with package [pennyworth_builder](https://github.com/d-markey/pennyworth_builder) in order to generate code to:

* bind service methods with Alfred routes
* build OpenAPI specifications for Swagger UI

A minimal sample is available from https://github.com/d-markey/pennyworth_sample.

Pennyworth also implements OpenAPI standards v2 (Swagger) and v3 to document REST APIs directly from the code.