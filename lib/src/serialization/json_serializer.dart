import 'dart:convert';

class JsonSerializer {
  JsonSerializer({String? indent}) : _encoder = JsonEncoder.withIndent(indent);

  final JsonEncoder _encoder;

  String serialize(Map<String, dynamic> map) => _encoder.convert(map);
}
