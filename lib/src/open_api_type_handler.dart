import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';

import 'extensions.dart';
import 'specifications/api_specification.dart';

FutureOr _handleOpenApi(
    HttpRequest req, HttpResponse res, ApiSpecification response) {
  final acceptHeaders = (req.getForcedHeader(HttpHeaders.acceptHeader) ??
          req.headers.value(HttpHeaders.acceptHeader) ??
          '')
      .split(',')
      .map((e) => _Accept.parse(e));
  final acceptJson =
      acceptHeaders.firstOrNull((ct) => ct.mimeType == 'application/json');
  final acceptYaml = acceptHeaders.firstOrNull((ct) =>
      ct.mimeType == 'application/x-yaml' || ct.mimeType == 'text/yaml');
  final acceptAnyApp =
      acceptHeaders.firstOrNull((ct) => ct.mimeType == 'application/*');
  final acceptAny = acceptHeaders.firstOrNull((ct) => ct.mimeType == '*/*');
  final accept =
      _Accept.best([acceptJson, acceptYaml, acceptAnyApp, acceptAny]);
  String result;
  if (acceptYaml != null && accept == acceptYaml) {
    res.headers.contentType =
        ContentType('application', 'x-yaml', charset: 'utf-8');
    result = response.toYaml();
  } else {
    res.headers.contentType = ContentType.json;
    result = response.toJson();
  }
  return res.send(result);
}

TypeHandler<ApiSpecification> get openApiTypeHandler =>
    TypeHandler<ApiSpecification>(_handleOpenApi);

class _Accept {
  _Accept._(this.mimeType, this.q);

  static _Accept parse(String encoding) {
    final parts =
        encoding.split(';').map((e) => e.trim().toLowerCase()).toList();
    final mimeType = parts[0];
    final quality = parts.firstOrNull((p) => p.startsWith('q='));
    final q = (quality == null)
        ? 1.0
        : (double.tryParse(quality.substring('q='.length)) ?? 0.0);
    return _Accept._(mimeType, q);
  }

  final String mimeType;
  final double q;

  static _Accept? best(List<_Accept?> candidates) {
    candidates.removeWhere((e) => e == null);
    candidates.sort((a, b) => b!.q.compareTo(a!.q));
    return candidates.firstOrNull();
  }

  @override
  String toString() => '$mimeType; q=$q';
}
