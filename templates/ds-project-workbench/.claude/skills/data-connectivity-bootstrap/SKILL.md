---
name: data-connectivity-bootstrap
description: Define y prepara la conectividad inicial del proyecto según el origen de datos requerido
---

# Cuándo usar esta skill
Úsala al inicio del proyecto o cuando todavía no esté resuelta la conectividad de datos.

# Objetivo
Definir de forma gobernada qué combinación de fuentes y librerías debe usar el proyecto antes de empezar la extracción, limpieza o modelización.

# Escenarios soportados
- PostgreSQL + carpetas locales para ficheros
- Oracle + carpetas locales para ficheros
- Vertex BigQuery + Google Cloud Storage + carpetas locales para ficheros

# Recomendaciones de librerías
## PostgreSQL
- Driver preferente: `psycopg`
- Capa opcional de abstracción: `SQLAlchemy`
- Ficheros locales: `pathlib`, `pandas`, `pyarrow`

## Oracle
- Driver preferente: `python-oracledb`
- Capa opcional de abstracción: `SQLAlchemy`
- Ficheros locales: `pathlib`, `pandas`, `pyarrow`

## Vertex BigQuery + Google Cloud Storage
- Cliente BigQuery: `google-cloud-bigquery`
- Cliente GCS: `google-cloud-storage`
- Integración opcional con DataFrames: `pandas-gbq`
- Ficheros locales: `pathlib`, `pandas`, `pyarrow`

# Reglas
- No fijes una tecnología por defecto si la tarea no la justifica.
- Prioriza la opción que mejor encaje con los requisitos reales del proyecto.
- Documenta siempre origen, granularidad, claves, ventanas temporales y posibles riesgos de leakage.
- Si faltan credenciales, accesos o librerías, repórtalo como bloqueo y no lo ocultes.
- Si la tarea lo pide, deja listadas también las dependencias Python que habrá que instalar.
- Si la tarea incluye preparación de entorno, prioriza la creación de `pyproject.toml` y de un `.venv/` local en el repo.

# Procedimiento
1. Revisa `next_task.md` y los inputs del proyecto.
2. Identifica qué fuentes de datos se necesitan realmente.
3. Selecciona el escenario de conectividad más adecuado.
4. Define las librerías, SDK o drivers necesarios.
5. Describe la forma de autenticación y acceso esperada.
6. Si la tarea lo requiere, prepara `pyproject.toml` con las dependencias necesarias y deja indicada la creación de `.venv/` local.
7. Deja preparada la estructura mínima de código o documentación para esa conectividad.
8. Escribe en `docs/` un resumen con:
   - fuentes
   - tecnología seleccionada
   - librerías necesarias
   - dependencias Python recomendadas
   - ficheros locales implicados
   - bloqueos o dependencias pendientes

# Outputs recomendados
- `docs/data_connectivity_plan.md`
- `docs/data_connectivity_dependencies.md`
- `pyproject.toml` si la tarea incluye preparación de entorno
- referencia a `.venv/` local si aplica
- `src/connectivity/` con esqueletos iniciales si la tarea lo pide
- notas de instalación o dependencias si procede
