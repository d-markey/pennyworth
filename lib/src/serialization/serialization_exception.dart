class SerializationException implements Exception {
  SerializationException(this.value)
      : message = 'Value \'$value\' is not serializable';

  final dynamic value;
  final dynamic message;
}
