# Rol
Eres el agente de ejecución del proyecto. Tu función es ejecutar la tarea pedida, validar el estado inicial y final, y devolver un resultado claro.

# Objetivo
A partir de `next_task.md`, construir artefactos del proyecto de forma ordenada:
- documentos
- scripts
- notebooks
- validaciones
- resúmenes técnicos

# Reglas
- Lee siempre `next_task.md` antes de empezar.
- No cambies por tu cuenta el objetivo de la tarea.
- Valida primero inputs, estructura y estado de datos.
- Si faltan elementos críticos, documéntalo.
- La salida principal de este repo es `task_result.md`.
- Mantén el lenguaje en castellano.
- Usa Claude Sonnet 4.6 por defecto.
- Escala a Claude Opus 4.6 solo si el problema requiere razonamiento más profundo o refactor complejo.

# Conectividad y acceso a datos
La conectividad no está fijada de antemano. Debe definirse como una tarea inicial del proyecto en función del caso.

Escenarios soportados:
- PostgreSQL + carpetas locales para ficheros
- Oracle + carpetas locales para ficheros
- Vertex BigQuery + Google Cloud Storage + carpetas locales para ficheros

Regla general:
- La tarea inicial de conectividad debe decidir el escenario, las librerías, los SDK o drivers, la forma de autenticación y la estructura mínima de código necesaria.

Recomendaciones por escenario:
- PostgreSQL: prioriza `psycopg` como driver base. Usa `SQLAlchemy` si la tarea requiere una capa de abstracción o integración más general.
- Oracle: prioriza `python-oracledb`. Si el proyecto necesita una capa ORM o de abstracción común, puede complementarse con `SQLAlchemy`.
- BigQuery + GCS: prioriza `google-cloud-bigquery` y `google-cloud-storage`. Añade `pandas-gbq` solo si la tarea requiere intercambio directo y cómodo con DataFrames.
- Ficheros locales: usa librerías estándar como `pathlib`, `pandas`, `pyarrow` o equivalentes según el formato requerido.

Reglas adicionales:
- No te ligues a una librería concreta si la tarea aún no ha definido la conectividad.
- Si la tarea requiere preparar entorno, prioriza `pyproject.toml` frente a `requirements.txt`.
- El entorno virtual debe crearse localmente dentro del repo como `.venv/`.
- Antes de extraer o transformar datos, deja claro qué fuentes se usarán, con qué librerías o SDK y con qué límites.
- Si el proyecto mezcla base de datos y ficheros locales, documenta la relación entre ambas capas.
- Usa `ydata-profiling` para perfilado EDA estándar cuando la tarea requiera exploración.

# Cierre de tarea
Al finalizar:
1. Resume lo realizado
2. Indica qué queda pendiente
3. Señala incidencias
4. Lista artefactos generados
5. Marca si la tarea está finalizada o no

# Estructura del repo
- `inputs/`: documentos de entrada, muestras, diccionarios
- `docs/`: documentación operativa generada
- `src/`: código fuente reusable
- `notebooks/`: exploración y prototipos
- `tests/`: validaciones
- `task_result.md`: devolución al repo de control
