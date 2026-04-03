<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# AUTOMATION_POLICY.md

## Objetivo
Definir cuándo `control` puede invocar `workbench` sin intervención humana y cuándo el flujo debe detenerse.

## Principio general
El flujo puede continuar automáticamente mientras:
- la siguiente tarea forme parte del plan esperado;
- no se reabra una fase previa de forma material;
- no falte información crítica;
- no aparezca una decisión reservada a validación humana;
- y no se supere el límite de saltos automáticos.

## Quién decide
- `control` gobierna el flujo.
- `workbench` ejecuta y devuelve estado.
- `control` decide si continúa automáticamente o si debe parar.

## Continuación automática permitida
`control` puede invocar `workbench` si:
- existe una `control/next_task.md` clara y vigente;
- la tarea es continuación natural del plan;
- `workbench` no ha marcado bloqueo;
- no hay necesidad de validación humana;
- el contador de saltos automáticos es menor que el límite.

## Parada humana obligatoria
El flujo debe detenerse si:
- aparece una tarea nueva no prevista materialmente;
- hay que redefinir una tarea anterior o fases previas;
- falta información crítica;
- aparece contradicción documental o metodológica;
- hay que decidir sobre:
  - definición de muestras;
  - exclusión de casos;
  - transformación del target continuo;
  - aceptación de variables sensibles o proxies;
  - aprobación final del modelo;
  - aprobación final del YAML.

## Límite de seguridad
- Límite recomendado de saltos automáticos consecutivos: **10**.
- Al llegar a ese límite, `control` debe parar y pedir revisión humana aunque no haya error.

## Representación documental
No es necesario añadir un estado nuevo si no hace falta.
La parada humana puede representarse con:
- `En revisión` en los estados;
- explicación explícita en `control/review_notes.md`;
- y notas de bloqueo o validación en `control/next_task.md` y `workbench/task_result.md`.

## Convenciones mínimas
### En `control/next_task.md`
Incluir una sección breve de dispatch:
- `automation_allowed`
- `stop_if_replan_needed`
- `stop_if_human_validation_needed`
- `max_auto_hops_remaining`

### En `workbench/task_result.md`
Incluir una sección breve de continuación:
- `blocking_issue_detected`
- `human_validation_required`
- `replan_required`
- `ready_for_control_auto_continue`
