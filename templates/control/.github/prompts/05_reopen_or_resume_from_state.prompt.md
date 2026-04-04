<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->
---
description: Reabrir o retomar el flujo desde un estado concreto
agent: control-orchestrator
---

Lee `control/CLAUDE.md`, `control/DEMO_WORKFLOW_STANDARD.md`, `control/AUTOMATION_POLICY.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md`, `control/review_notes.md`, `control/next_task.md` y, si aplica, `workbench/task_result.md`.

Reabre o retoma el flujo desde el estado indicado por el usuario.

Debes:
- analizar el impacto;
- marcar el estado objetivo como `En revisión` en `control/WORKFLOW_STATE.md`;
- marcar también como `En revisión` los estados posteriores afectados si corresponde;
- preparar una nueva `control/next_task.md` para `workbench`;
- y detener la continuación automática hasta nueva orden o nueva iteración de `control`.
