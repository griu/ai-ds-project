<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->
---
description: Revisar el resultado de una tarea ya ejecutada
agent: control-orchestrator
---

Lee `control/CLAUDE.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `control/AUTOMATION_POLICY.md`, `workbench/WORKBENCH_STATE.md`, `control/next_task.md`, `control/review_notes.md` y `workbench/task_result.md`.

Debes:
1. revisar si la tarea anterior está cerrada o no;
2. actualizar `control/review_notes.md`;
3. decidir si el flujo puede continuar automáticamente o debe pararse;
4. reescribir `control/next_task.md` completo solo si corresponde avanzar o redefinir la tarea;
5. actualizar `control/WORKFLOW_STATE.md`.

Reglas adicionales:
- `control/next_task.md` debe quedar limpio y contener solo la tarea activa vigente;
- no dejes acumuladas tareas antiguas dentro del archivo.
