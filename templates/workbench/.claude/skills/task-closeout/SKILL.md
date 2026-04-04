---
name: task-closeout
description: Cierra una tarea de forma homogénea y redacta task_result.md, manteniendo el estado local de workbench
---

Actualiza `workbench/task_result.md` con:
- objetivo de la tarea;
- trabajo realizado;
- artefactos generados;
- validaciones ejecutadas;
- incidencias;
- trabajo no completado;
- evaluación final;
- recomendación del siguiente paso.

Además:
- actualiza `workbench/WORKBENCH_STATE.md` reflejando el avance local;
- deja señales claras:
  - `blocking_issue_detected`
  - `human_validation_required`
  - `replan_required`
  - `ready_for_control_auto_continue`
- si hubo notebooks ejecutados, confirma que quedaron guardados con outputs visibles;
- si hubo gráficos de EDA guardados como imágenes, confirma que también aparecen en los notebooks relevantes;
- guarda una copia histórica numerada en `workbench/history/`.
