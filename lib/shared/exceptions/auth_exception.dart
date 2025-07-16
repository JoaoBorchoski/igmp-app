class AuthException implements Exception {
  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return key;
  }
}
