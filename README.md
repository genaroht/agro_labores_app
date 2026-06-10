# Agro Labores App

App Flutter offline-first para registro de labores agrícolas, personas/operarios, catálogos, reportes y sincronización.

## Stack

- Flutter + Material 3
- Riverpod
- GoRouter
- Drift / SQLite local
- Dio
- SharedPreferences
- Sincronización local/remota

## Ejecutar en desarrollo

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
# Opcional: forzar la semilla aunque no estés en debug
flutter run --dart-define=ENABLE_DEV_SEED=true
```

Con backend real:

```bash
flutter run \
  --dart-define=ENABLE_DEV_SEED=false \
  --dart-define=API_BASE_URL=https://api.tu-dominio.com
```

Si `API_BASE_URL` está vacío, la app usa un servidor mock local para probar la cola offline-first.

## Verificaciones recomendadas

```bash
dart format lib test
flutter analyze
flutter test
```

## Notas de producción

- Reemplazar el PIN local por autenticación real con token seguro.
- Guardar contraseñas/PIN solo hasheados en backend.
- Mantener HTTPS obligatorio.
- Validar permisos en backend por rol y departamento.
- Revisar migraciones Drift antes de publicar una actualización a usuarios reales.

## Backend

Ver `docs/backend_contract.md` para el contrato mínimo recomendado de API REST y sincronización.
