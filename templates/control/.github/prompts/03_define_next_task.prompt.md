<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->
---
description: Definir la siguiente tarea a ejecutar
agent: control-orchestrator
---

A partir de `control/review_notes.md`, `control/next_task.md`, `workbench/task_result.md` y `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, redacta una nueva versión de `control/next_task.md` únicamente si corresponde continuar.

Requisitos:
- una sola tarea;
- pequeña, verificable y gobernada;
- alineada con el estado real del proyecto;
- compatible con los requisitos del framework.

Reglas:
- no fuerces el salto a conectividad, entorno, EDA o modelización;
- si la tarea previa no está cerrada, redefine o completa esa misma fase;
- si existe un bloqueo crítico no resoluble, indícalo explícitamente;
- si corresponde validación humana, déjala explícita en el flujo;
- conserva histórico en `control/history/`.
