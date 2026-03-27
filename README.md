# Bundle de demo: control plane + project workbench

Este paquete contiene una demo didáctica con dos repositorios:
- `ds-control-plane`: define, revisa y decide el siguiente paso
- `ds-project-workbench`: ejecuta la tarea, valida y reporta

## Cambios incluidos en esta versión
- EDA estandarizada con `ydata-profiling`
- Conectividad adaptable como tarea inicial
- `pyproject.toml` como estándar preferido para dependencias
- `.venv/` local dentro de cada repositorio
- Recomendaciones concretas de librerías por escenario:
  - PostgreSQL: `psycopg` y opcionalmente `SQLAlchemy`
  - Oracle: `python-oracledb` y opcionalmente `SQLAlchemy`
  - BigQuery + GCS: `google-cloud-bigquery`, `google-cloud-storage` y opcionalmente `pandas-gbq`
  - Ficheros locales: `pathlib`, `pandas`, `pyarrow`

## Uso recomendado
1. Abre `ds-control-plane` en una ventana de VS Code.
2. Abre `ds-project-workbench` en otra ventana de VS Code.
3. Desde control, redacta `next_task.md`.
4. Desde ejecución, trabaja sobre la tarea y devuelve `task_result.md`.
5. Repite el ciclo.

## Preferencias de entorno
- Cada repositorio debe gestionar su propio entorno virtual local en `.venv/`.
- Cuando una tarea requiera preparar dependencias, la salida preferida debe ser `pyproject.toml`, no `requirements.txt`, salvo que la tarea indique explícitamente otra cosa.
- Se incluyen `.gitignore` básicos para ignorar `.venv/` y caches de Python.
