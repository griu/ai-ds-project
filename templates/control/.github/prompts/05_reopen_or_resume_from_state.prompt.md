<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->
---
description: Reabrir o retomar el flujo desde un estado concreto
agent: control-orchestrator
---

Lee `control/CLAUDE.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `control/AUTOMATION_POLICY.md`, `workbench/WORKBENCH_STATE.md`, `control/review_notes.md`, `control/next_task.md` y `workbench/task_result.md` si existe.

Reabre o retoma el flujo desde el estado indicado por el usuario, actualiza `control/WORKFLOW_STATE.md` y deja lista una nueva `control/next_task.md`.

Regla adicional:
- si la reapertura implica replanificación material, el flujo automático debe detenerse.
