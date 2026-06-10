import 'package:flutter/foundation.dart';

class AppEnvironment {
  const AppEnvironment._();

  /// Activa datos y controles de desarrollo.
  ///
  /// En modo debug queda activo por defecto para que `flutter run` cargue
  /// el usuario local de prueba 999999 / 123456. En release queda desactivado,
  /// salvo que se indique explícitamente con:
  /// --dart-define=ENABLE_DEV_SEED=true
  static const bool enableDevelopmentSeed = bool.fromEnvironment(
    'ENABLE_DEV_SEED',
    defaultValue: kDebugMode,
  );

  /// URL base del backend real. Si está vacía, la app usa el servidor mock
  /// local para mantener el modo offline-first durante desarrollo.
  ///
  /// Ejemplo:
  /// --dart-define=API_BASE_URL=https://api.miempresa.com
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static bool get useRemoteSyncApi => apiBaseUrl.trim().isNotEmpty;
}
