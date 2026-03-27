# ds-project-workbench

Repo de ejecución del proyecto.

## Qué hace
- parte de una estructura genérica
- recibe una tarea desde `next_task.md`
- crea documentación, código y análisis
- devuelve un resumen estructurado en `task_result.md`

## Carpetas base
- `inputs/`
- `docs/`
- `src/`
- `notebooks/`
- `tests/`

## Skills didácticas incluidas
- `data-connectivity-bootstrap`
- `eda-with-ydata-profiling`
- `task-closeout`

## Enfoque de conectividad
El framework no queda ligado a una única tecnología. Una de las primeras tareas del proyecto debe ser decidir y preparar la conectividad necesaria según el caso.

Escenarios previstos:
- PostgreSQL + carpetas locales
- Oracle + carpetas locales
- Vertex BigQuery + Google Cloud Storage + carpetas locales

Recomendaciones de librerías por escenario:
- PostgreSQL: `psycopg` como driver preferente y `SQLAlchemy` como capa opcional.
- Oracle: `python-oracledb` como driver preferente y `SQLAlchemy` como capa opcional.
- BigQuery + GCS: `google-cloud-bigquery` y `google-cloud-storage`, con `pandas-gbq` como apoyo opcional para DataFrames.
- Ficheros locales: `pathlib`, `pandas`, `pyarrow` o equivalentes según formato.

## Modo recomendado de uso
1. Copia o referencia `next_task.md` desde el repo de control.
2. Ejecuta primero la tarea de definición/preparación de conectividad si aún no existe.
3. Usa la skill que corresponda.
4. Cierra con `task_result.md`.

## Nota sobre skills publicadas

Se incluye `PUBLISHED_SKILLS_NOTES.md` con una guía breve sobre repositorios y mecanismos públicos de distribución de skills.

## Preferencias de entorno
- Formato preferido de dependencias: `pyproject.toml`.
- Entorno virtual local del repo: `.venv/`.
- La preparación de `pyproject.toml` y `.venv/` forma parte de las tareas iniciales cuando el proyecto necesita entorno Python operativo.
