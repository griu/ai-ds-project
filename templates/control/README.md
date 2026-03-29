<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# control

Área de gobierno del proyecto instanciado.

## Qué hace
- define la siguiente tarea;
- revisa el resultado entregado por `workbench/task_result.md`;
- decide si se avanza, se corrige o se repite;
- canaliza la intervención humana cuando hace falta validación o revisión;
- mantiene visible el diagrama de estados en `control/WORKFLOW_STATE.md`.

## Artefactos principales
- `control/next_task.md`
- `control/review_notes.md`
- `control/WORKFLOW_STATE.md`
- `control/history/`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`

## Reglas importantes
Antes de abrir una nueva fase, verifica si el framework exige:
- definición explícita de muestras;
- revisión de variables por causalidad, fairness o regulación;
- EDA y monotonicidades;
- validación humana;
- o una comparación obligatoria entre modelos.

## Contexto de workspace
En la ventana `control.code-workspace`, el workspace abre la **raíz del repo del caso**.

Usa siempre rutas desde la raíz:
- `control/next_task.md`
- `control/review_notes.md`
- `control/WORKFLOW_STATE.md`
- `workbench/task_result.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
