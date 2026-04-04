<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# control

Área de gobierno del proyecto instanciado.

## Qué hace
- define la siguiente tarea;
- revisa el resultado entregado por `workbench/task_result.md`;
- decide si se avanza, se corrige o se repite;
- puede invocar a `workbench` como subagente dentro del chat de VS Code;
- canaliza la intervención humana cuando hace falta validación o revisión;
- mantiene visible el diagrama de estados en `control/WORKFLOW_STATE.md`.

## Artefactos principales
- `control/next_task.md`
- `control/review_notes.md`
- `control/AUTOMATION_POLICY.md`
- `control/WORKFLOW_STATE.md`
- `control/history/`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`

## Regla de limpieza
`control/next_task.md` debe mantenerse limpio.  
Debe contener solo la tarea activa actual y no una acumulación histórica de tareas antiguas.

## Papel en la automatización
La automatización principal vive en el chat de `control` en VS Code.  
Streamlit solo monitoriza y guía.
