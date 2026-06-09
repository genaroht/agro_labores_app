# Contrato recomendado para backend real

La app ya puede trabajar con servidor mock local o con API REST real usando:

```bash
flutter run --dart-define=API_BASE_URL=https://api.tu-dominio.com
```

Si `API_BASE_URL` está vacío, se usa `MockRemoteSyncApiClient` para mantener desarrollo offline-first.

## Endpoints base

| Módulo | Endpoint recomendado | Uso |
| --- | --- | --- |
| Auth | `POST /auth/login` | Login real, token JWT o sesión segura |
| Roles | `/roles` | Catálogo de roles |
| Users | `/users` | Usuarios, PIN/password con hash en servidor |
| Departments | `/departments` | Departamentos y cultivo asociado |
| Operators | `/operators` | Personas/operarios y cargos |
| Crops | `/crops` | Cultivos |
| Tasks | `/tasks` | Labores |
| Locations | `/locations` | Lote, red, sector, hectáreas |
| Dining rooms | `/dining-rooms` | Comedores por cultivo/lote/red |
| Records | `/records` | Registros agrícolas |
| Reports | `/reports` | Reportes agregados/exportación server-side |
| Sync upload | `POST /sync/upload` | Recibe un item de cola local |
| Sync pull | `GET /sync/pull?since=<iso8601>` | Devuelve cambios remotos desde una fecha |

## `POST /sync/upload`

Request:

```json
{
  "queueId": "queue_record_123",
  "entityType": "record",
  "entityId": "record_123",
  "operation": "create",
  "payload": "{...json serializado...}"
}
```

Response mínimo:

```json
{
  "serverId": "srv_record_123"
}
```

## `GET /sync/pull`

Response recomendado:

```json
{
  "roles": [],
  "users": [],
  "departments": [],
  "userDepartments": [],
  "positions": [],
  "operators": [],
  "crops": [],
  "tasks": [],
  "locations": [],
  "diningRooms": [],
  "records": [],
  "recordLocations": [],
  "formFields": [],
  "tableColumns": [],
  "lockConfigs": []
}
```

## Reglas importantes

- El servidor debe devolver fechas `updatedAt`, `createdAt` y `deletedAt` en ISO 8601.
- El cliente no sobrescribe cambios locales con estado `pendiente`, `sincronizando` o `error`.
- El backend debe validar permisos por rol y departamento, incluso si la app ya protege rutas.
- No guardar PIN/password en texto plano en backend. Usar hash fuerte con salt.
- Usar HTTPS, JWT/refresh token o sesión segura, rate limiting y auditoría de sincronización.
