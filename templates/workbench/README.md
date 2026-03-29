<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# workbench

Área de ejecución del proyecto instanciado.

## Qué hace
- recibe una tarea desde `control/next_task.md`;
- crea documentación, código y análisis;
- devuelve un resumen estructurado en `workbench/task_result.md`.

## Artefactos base
- `workbench/inputs/`
- `workbench/docs/`
- `workbench/src/`
- `workbench/notebooks/`
- `workbench/tests/`
- `workbench/history/`
- `workbench/task_result.md`
- `workbench/WORKBENCH_STATE.md`

## Regla del framework
Debes respetar siempre:
- `control/next_task.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`

La actualización de `control/WORKFLOW_STATE.md` corresponde a `control`, no a `workbench`.
