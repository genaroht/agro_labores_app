class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

String userSafeErrorMessage(
  Object error, {
  String fallback = 'Ocurrió un error. Inténtalo nuevamente.',
}) {
  if (error is AppException) {
    return error.message;
  }

  final raw = error.toString().replaceFirst('Exception: ', '').trim();

  if (raw.isEmpty) {
    return fallback;
  }

  final looksTechnical =
      raw.contains('DioException') ||
      raw.contains('Sqlite') ||
      raw.contains('SocketException') ||
      raw.contains('StackTrace') ||
      raw.contains('package:') ||
      raw.contains('Null check operator');

  return looksTechnical ? fallback : raw;
}
