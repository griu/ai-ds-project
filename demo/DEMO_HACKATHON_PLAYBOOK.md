<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# Demo guiada de VS Code + Claude para proyectos de Data Science

## Resumen
Este framework incorpora requisitos explícitos para:
- framing;
- conectividad;
- data quality;
- definición de muestras;
- EDA bivariante respecto al target;
- revisión de variables por causalidad, fairness y regulación;
- monotonicidades;
- validación humana de target continuo;
- modelado con XGBoost con y sin monotonicidades;
- métricas obligatorias;
- YAMLs de variables e hiperparámetros;
- Optuna;
- PDP y SHAP;
- validación humana del modelo final.

## Documentos clave
- `templates/control/DEMO_WORKFLOW_STANDARD.md`
- `templates/control/AUTOMATION_POLICY.md`
- `templates/control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `templates/control/WORKFLOW_STATE.md`
- `templates/workbench/WORKBENCH_STATE.md`
- `templates/app/README.md`
- `docs/PROJECT_CONTINUITY_MEMORY.md`

## Workspaces
Cada caso instanciado crea:
- `control.code-workspace`
- `workbench.code-workspace`
- `app.code-workspace`

Los tres abren la misma raíz del caso.

## Regla de simplificación
La lógica estable debe vivir sobre todo en:
- `control/CLAUDE.md`
- `workbench/CLAUDE.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/AUTOMATION_POLICY.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

Los prompts recurrentes deben ser lo más ligeros posible.

## Flujo principal
1. La persona arranca en `control`.
2. `control` define o limpia la tarea.
3. `control` invoca a `workbench` como subagente.
4. `control` revisa el resultado.
5. Si no hay stop, `control` vuelve a iterar.
6. Si hay una condición de parada, `control` pide ayuda humana.

## Papel de Streamlit
Streamlit:
- monitoriza;
- visualiza la traza;
- ayuda a entender qué está ocurriendo;
- pero no es el motor principal del bucle autónomo.

## Reapertura del flujo
El framework soporta reabrir un estado concreto del plan de trabajo:
- marcando ese estado como `En revisión`;
- marcando estados posteriores afectados también como `En revisión`, si corresponde;
- generando una nueva `control/next_task.md` correctiva;
- y retomando luego el flujo normal cuando proceda.
