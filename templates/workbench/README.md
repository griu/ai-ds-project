<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# workbench

Área de ejecución del proyecto instanciado.

## Qué hace
- parte de una estructura genérica;
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

## Reglas del framework
Debes respetar siempre:
- `control/next_task.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`

La actualización de `control/WORKFLOW_STATE.md` corresponde a `control`, no a `workbench`.

## Skills relevantes
- `data-connectivity-bootstrap`
- `sample-definition-and-traceability`
- `eda-with-ydata-profiling`
- `variable-acceptance-and-fairness-review`
- `monotonicity-diagnostics`
- `xgboost-benchmark-with-monotonicity`
- `model-config-yaml-and-optuna`
- `explainability-pdp-shap`
- `task-closeout`

## Contexto de workspace
En la ventana `workbench.code-workspace`, el workspace abre la **raíz del repo del caso**.

Usa siempre rutas desde la raíz:
- `control/next_task.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `workbench/task_result.md`
- `workbench/docs/...`
