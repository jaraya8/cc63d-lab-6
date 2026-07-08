# Changelog

Registro de cambios del fork para el **Lab 7 — CC63D**. Documenta de forma
transparente cada cambio al repositorio y cada prueba de despliegue sobre la
infraestructura en Google Cloud (Cloud Run, Cloud Build, Terraform).

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/);
versionado semántico.

## [0.4.0] - 2026-07-07

### Infraestructura / pruebas
- Otorgado el rol `logging.logWriter` a la service account del build
  (`313803569462-compute@developer.gserviceaccount.com`). Como el `cloudbuild.yaml`
  usa `options: logging: CLOUD_LOGGING_ONLY`, este rol es necesario para que los
  logs de la pipeline se escriban en Cloud Logging y queden visibles en la consola.
- Este push valida la pipeline completa con los logs ya disponibles.

## [0.3.0] - 2026-07-07

### Añadido
- Este `CHANGELOG.md`, para transparentar los cambios y las pruebas de despliegue.

### Infraestructura / pruebas
- **Prueba de despliegue automático (CI/CD).** Este cambio dispara la pipeline de
  Cloud Build para validarla de extremo a extremo (build → test → push → deploy),
  luego de otorgar a la service account del build
  (`313803569462-compute@developer.gserviceaccount.com`) los roles
  `artifactregistry.writer`, `run.admin` e `iam.serviceAccountUser`.
- Nota: el primer intento (commit `fa2333a`) falló en el paso `push` por falta de
  `artifactregistry.writer`. Se corrigió otorgando solo lo necesario (menor
  privilegio); `logging.logWriter` no se otorgó porque los logs ya funcionaban.

## [0.2.0] - 2026-07-07

### Añadido
- `cloudbuild.yaml`: pipeline de CI/CD (build → test con `pytest` → push a
  Artifact Registry → deploy a Cloud Run). La imagen se etiqueta con `$COMMIT_SHA`
  para que cada despliegue sea trazable hasta el commit que lo originó.
- Sección "Despliegue continuo" en el `README`.

## [0.1.0] - 2026-07-07

### Cambiado
- `Dockerfile`: el contenedor ahora escucha en `$PORT` (con default `8000`) para
  ser compatible con Cloud Run, que inyecta esa variable en tiempo de ejecución
  (Parte 1).
