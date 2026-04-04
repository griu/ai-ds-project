<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->
---
description: Ejecutar manualmente workbench en casos de depuración o fallback
agent: execution-worker
---

Lee `workbench/CLAUDE.md`, `control/next_task.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md` y los artefactos relevantes del caso.

Actúa como workbench del caso.

Debes:
- ejecutar exactamente la tarea definida por `control`;
- actualizar `workbench/task_result.md`;
- actualizar `workbench/WORKBENCH_STATE.md`;
- dejar señales claras de continuación o parada;
- y no modificar `control/WORKFLOW_STATE.md`.
