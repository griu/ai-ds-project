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
- `control/AUTOMATION_POLICY.md`

La actualización de `control/WORKFLOW_STATE.md` corresponde a `control`, no a `workbench`.

## Regla de limpieza
`workbench/task_result.md` debe reflejar solo el resultado de la tarea actual o de la última ejecución cerrada, sin acumular resultados antiguos.

## Reglas operativas importantes
- El caso debe usar un `.venv/` propio creado desde cero en la raíz del repo.
- Los notebooks ejecutados deben quedar guardados con outputs visibles.
- Los gráficos guardados como imágenes deben aparecer también dentro de los notebooks relevantes.
- En XGBoost no debe imputarse missing por defecto.
- Las variables categóricas deben entrar de forma nativa como categóricas cuando corresponda.
- Las variables prohibidas no deben entrar en el modelo.
