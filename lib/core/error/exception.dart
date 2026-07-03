class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}

class SerializationException implements Exception {
  final String message;
  SerializationException({required this.message});
}

class UnknownException implements Exception {
  final String message;
  UnknownException({required this.message});
}
