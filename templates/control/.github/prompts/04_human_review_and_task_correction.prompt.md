<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->
---
description: Incorporar observaciones humanas a la revisión y decidir si hace falta corrección
agent: control-orchestrator
---

Lee `control/CLAUDE.md`, `control/DEMO_WORKFLOW_STANDARD.md`, `control/AUTOMATION_POLICY.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md`, `control/next_task.md`, `control/review_notes.md` y `workbench/task_result.md`.

Integra observaciones humanas de revisión como criterio adicional de decisión.

Debes:
1. distinguir entre revisión autónoma y revisión humana;
2. decidir si la tarea queda finalizada, parcialmente finalizada o no finalizada;
3. actualizar `control/review_notes.md`;
4. emitir una nueva `control/next_task.md` correctiva solo si hace falta;
5. actualizar `control/WORKFLOW_STATE.md`;
6. detener la continuación automática si la revisión humana afecta al plan o a la calidad de cierre.
