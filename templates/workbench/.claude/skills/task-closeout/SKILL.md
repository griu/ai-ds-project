---
name: task-closeout
description: Cierra una tarea de forma homogénea y redacta task_result.md, manteniendo el estado local de workbench
---

Actualiza `workbench/task_result.md` con:
- trabajo realizado
- artefactos
- validaciones
- incidencias
- pendientes
- evaluación final

Además:
- actualiza `workbench/WORKBENCH_STATE.md` reflejando el avance local;
- confirma si el flujo puede continuar automáticamente o si debe detenerse;
- si hubo notebooks ejecutados, confirma que quedaron guardados con outputs visibles;
- si hubo gráficos de EDA guardados como imágenes, confirma que también aparecen en los notebooks relevantes;
- guarda una copia histórica numerada en `workbench/history/`.
