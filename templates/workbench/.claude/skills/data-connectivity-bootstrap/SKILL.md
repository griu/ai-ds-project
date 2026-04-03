---
name: data-connectivity-bootstrap
description: Define el escenario de conectividad y prepara la base técnica mínima del proyecto
---

Decide el escenario de conectividad, las librerías necesarias, la autenticación y la estructura mínima de código.

Si la tarea lo pide, prepara:
- `pyproject.toml` en la raíz del repo del caso
- `.venv/` en la raíz del repo del caso

Reglas adicionales:
- crea el `.venv/` del caso desde cero;
- no reutilices entornos Python preexistentes del sistema como entorno operativo del caso.

Escenarios:
- PostgreSQL + local files
- Oracle + local files
- BigQuery + GCS + local files

Documenta la decisión en `workbench/docs/`.
