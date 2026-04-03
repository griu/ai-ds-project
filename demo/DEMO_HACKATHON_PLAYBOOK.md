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
- `templates/control/AUTOMATION_POLICY.md`
- `templates/workbench/WORKBENCH_STATE.md`
- `templates/app/README.md`
- `docs/PROJECT_CONTINUITY_MEMORY.md`

## Workspaces
Cada caso instanciado crea:
- `control.code-workspace`
- `workbench.code-workspace`
- `app.code-workspace`

Todos abren la misma raíz del caso.

## Regla de simplificación
La lógica estable debe vivir sobre todo en:
- `control/CLAUDE.md`
- `workbench/CLAUDE.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `control/AUTOMATION_POLICY.md`
- `workbench/WORKBENCH_STATE.md`

## Flujo
1. `control` define.
2. `workbench` ejecuta.
3. `control` revisa, actualiza estados y decide.
4. La app ayuda a seguir y operar el flujo.
5. Si hace falta, la persona aporta observaciones vía `control`.
6. Repetir.
