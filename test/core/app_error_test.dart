import 'package:agro_labores_app/core/errors/app_error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('userSafeErrorMessage', () {
    test('muestra mensajes de negocio controlados', () {
      final message = userSafeErrorMessage(
        const AppException('Usuario o contraseña incorrectos.'),
      );

      expect(message, 'Usuario o contraseña incorrectos.');
    });

    test('oculta errores técnicos al usuario final', () {
      final message = userSafeErrorMessage(
        Exception('DioException: connection timeout'),
        fallback: 'No se pudo conectar.',
      );

      expect(message, 'No se pudo conectar.');
    });
  });
}
