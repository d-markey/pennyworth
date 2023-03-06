class SerializationException implements Exception {
  SerializationException(this.message, [this.cause]);

  SerializationException.unsupported(dynamic data, [dynamic cause])
      : this('Unsupported type ${data.runtimeType}', cause);

  final dynamic message;
  final dynamic cause;
}
