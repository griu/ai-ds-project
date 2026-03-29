# Notas de librerías de conectividad recomendadas

## PostgreSQL
- `psycopg` como driver principal
- `SQLAlchemy` como capa opcional de abstracción

## Oracle
- `python-oracledb` como driver principal
- `SQLAlchemy` como capa opcional de abstracción

## BigQuery + Google Cloud Storage
- `google-cloud-bigquery` para BigQuery
- `google-cloud-storage` para GCS
- `pandas-gbq` como apoyo opcional si se necesita trabajar cómodamente con DataFrames

## Ficheros locales
- `pathlib` para gestión de rutas
- `pandas` y `pyarrow` para CSV, Parquet y formatos tabulares comunes

## Criterio de uso
Estas recomendaciones deben tratarse como preferentes, no obligatorias, y siempre deben confirmarse en la tarea inicial de conectividad del proyecto.

## Preferencia de empaquetado del proyecto
- Formato preferido: `pyproject.toml`
- Entorno virtual local del proyecto: `.venv/` en la raíz del repo del caso
