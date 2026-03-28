---
description: Definir la siguiente tarea a ejecutar
agent: control-orchestrator
---

A partir de `review_notes.md`, `next_task.md` y `../workbench/task_result.md`, redacta una nueva versión de `next_task.md` únicamente si corresponde continuar.

Requisitos:
- una sola tarea
- pequeña, verificable y gobernada
- alineada con el estado real del proyecto
- sin asumir por adelantado la siguiente fase

La nueva tarea debe incluir:
- objetivo
- contexto
- inputs a revisar
- trabajo a realizar
- outputs esperados
- criterios de finalización
- límites

Reglas:
- no fuerces el salto a conectividad, entorno, EDA o modelización
- si la tarea previa no está cerrada, redefine o completa esa misma fase
- si existe un bloqueo crítico no resoluble, indícalo explícitamente