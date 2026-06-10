import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_environment.dart';
import 'data/local/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (details) {
    FlutterError.presentError(details);

    return Material(
      color: const Color(0xFFF8FBF4),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.error_outline, size: 48, color: Color(0xFFB3261E)),
                SizedBox(height: 12),
                Text(
                  'Se presentó un problema en esta pantalla.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Vuelva atrás o sincronice/actualice. El detalle técnico queda en consola para corregirlo.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };

  if (AppEnvironment.enableDevelopmentSeed) {
    await _prepareDevelopmentData();
  }

  runApp(const ProviderScope(child: AgroLaboresApp()));
}

Future<void> _prepareDevelopmentData() async {
  final database = AppDatabase();

  try {
    await database.seedDevelopmentData();
  } catch (error, stackTrace) {
    debugPrint('No se pudo preparar la data de desarrollo: $error');
    debugPrintStack(stackTrace: stackTrace);
  } finally {
    await database.close();
  }
}
