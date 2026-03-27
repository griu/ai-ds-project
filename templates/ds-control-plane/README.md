# ds-control-plane

Repo de gobierno del proyecto.

## Qué hace
- define la siguiente tarea
- revisa el resultado entregado por el repo de ejecución
- decide si se avanza, se corrige o se repite

## Artefactos principales
- `next_task.md`
- `review_notes.md`

## Componentes didácticos
- `CLAUDE.md`
- `.github/prompts/`
- `.claude/skills/`
- `.claude/agents/`

## Regla importante del framework
Si la conectividad del proyecto no está resuelta, el control plane debe introducir una tarea inicial o temprana para definirla.

Escenarios previstos:
- PostgreSQL + carpetas locales
- Oracle + carpetas locales
- Vertex BigQuery + Google Cloud Storage + carpetas locales

## Modo recomendado de uso
1. Lee el estado disponible.
2. Revisa `task_result.md` si existe.
3. Usa el prompt de revisión o de siguiente paso.
4. Actualiza `next_task.md`.

## Preferencias de entorno
- Si este repo llega a necesitar dependencias Python, el formato preferido es `pyproject.toml`.
- El entorno virtual debe ser local al repo: `.venv/`.
