<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->
---
description: Orquestar iteraciones autónomas entre control y el subagente workbench
agent: control-orchestrator
---

Lee y usa como contexto estable:
- `control/CLAUDE.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/AUTOMATION_POLICY.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`
- `control/review_notes.md`
- `control/next_task.md` si existe
- `workbench/task_result.md` si existe

Actúa como orquestador del proyecto desde `control`.

Debes:
1. asegurar que existe una tarea activa válida;
2. limpiar o reescribir `control/next_task.md` si hace falta;
3. invocar a `workbench` como subagente para ejecutar la tarea activa;
4. revisar `workbench/task_result.md`;
5. actualizar `control/review_notes.md`;
6. actualizar `control/WORKFLOW_STATE.md`;
7. continuar iterando mientras no aparezca una condición de parada humana;
8. detenerte y pedir ayuda humana si se cumple alguna condición de stop definida en `control/AUTOMATION_POLICY.md`.

Reglas:
- `control/next_task.md` debe quedar limpio;
- `workbench/task_result.md` debe corresponder a la tarea actual o última cerrada;
- no lances una nueva iteración si hay replanificación, reapertura o validación humana obligatoria.
