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
- `templates/control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `templates/control/WORKFLOW_STATE.md`

El primero define la dinámica operativa.  
El segundo define los requisitos técnicos obligatorios.  
El tercero mantiene visible el estado del plan de trabajo.

## Workspaces
Cada caso instanciado crea:
- `control.code-workspace`
- `workbench.code-workspace`

Ambos abren la misma raíz del caso.

## Regla de simplificación
La lógica estable debe vivir sobre todo en:
- `control/CLAUDE.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/CLAUDE.md`

Los prompts recurrentes deben ser lo más ligeros posible.

## Flujo
1. `control` define.
2. `workbench` ejecuta.
3. `control` revisa, actualiza `WORKFLOW_STATE.md` y decide.
4. Si hace falta, la persona aporta observaciones vía `control`.
5. Repetir.

## Reapertura del flujo
El framework soporta reabrir un estado concreto del plan de trabajo:
- marcando ese estado como `En revisión`;
- marcando estados posteriores afectados también como `En revisión`, si corresponde;
- generando una nueva `control/next_task.md` correctiva;
- y retomando luego el flujo normal.
