<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->
---
description: Incorporar observaciones humanas a la revisión y decidir si hace falta corrección
agent: control-orchestrator
---

Lee `workbench/task_result.md`, `control/next_task.md`, `control/review_notes.md`, `control/CLAUDE.md` y `control/PROJECT_TECHNICAL_REQUIREMENTS.md`.

Integra observaciones humanas de revisión como criterio adicional de decisión.

Debes:
1. distinguir entre revisión autónoma y revisión humana;
2. decidir si la tarea queda finalizada, parcialmente finalizada o no finalizada;
3. actualizar `control/review_notes.md`;
4. emitir una nueva `control/next_task.md` correctiva solo si hace falta;
5. conservar histórico en `control/history/`.
