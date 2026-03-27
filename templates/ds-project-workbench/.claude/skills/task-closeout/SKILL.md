---
name: task-closeout
description: Cierra una tarea de forma homogénea y redacta task_result.md
---

# Cuándo usar esta skill
Úsala siempre al final de una tarea ejecutada.

# Salida obligatoria
Actualiza `task_result.md` con esta estructura:

## Objetivo de la tarea
## Trabajo realizado
## Artefactos generados
## Validaciones ejecutadas
## Incidencias encontradas
## Trabajo no completado
## Conectividad o dependencias afectadas
## Evaluación final
- finalizada
- parcialmente finalizada
- no finalizada

# Regla
No cierres una tarea como finalizada si faltan outputs obligatorios.
