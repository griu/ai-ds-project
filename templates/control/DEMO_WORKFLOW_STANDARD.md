<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# DEMO_WORKFLOW_STANDARD.md

## Objetivo
Este documento define la dinámica estándar de trabajo de la demo para cualquier caso instanciado del framework.

La demo funciona con un único repositorio de caso, con dos áreas de trabajo separadas:
- `control/`
- `workbench/`

La interacción correcta es:

**persona → control → workbench → control → workbench → ...**

## Documentos clave del framework en el caso
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

## Regla de sincronización entre control y workbench
- `control/WORKFLOW_STATE.md` es la fuente de verdad del estado global.
- `workbench/WORKBENCH_STATE.md` es la traza local de ejecución de `workbench`.
- `workbench` debe tomar como punto de partida el diagrama de estados definido en `control`.
- `control` debe revisar la coherencia entre ambos documentos cuando cierre una iteración.

## Regla operativa principal
Existen **5 prompts operativos**:
1. Prompt inicial de `control`
2. Prompt recurrente de `workbench`
3. Prompt recurrente de `control`
4. Prompt de `control` para revisión humana y posible corrección
5. Prompt de `control` para reabrir o retomar el flujo desde un estado concreto

## Regla ultracorta
- Si todavía no has empezado la demo → usa el prompt inicial de `control`
- Si lo último actualizado es `control/next_task.md` → usa el prompt recurrente de `workbench`
- Si lo último actualizado es `workbench/task_result.md` → usa el prompt recurrente de `control`
- Si quieres introducir observaciones humanas → usa el prompt de revisión humana de `control`
- Si quieres reabrir un estado concreto → usa el prompt de reapertura de `control`

## Regla de actualización de estados
### Estado global
`control` es responsable de mantener `control/WORKFLOW_STATE.md`.

### Estado local de workbench
`workbench` es responsable de mantener `workbench/WORKBENCH_STATE.md`.

## Filosofía de prompts
Los prompts recurrentes deben ser ligeros.
La mayor parte de las reglas estables vive en:
- `control/CLAUDE.md`
- `workbench/CLAUDE.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

## PROMPT 1 — control inicial
```text
Lee `control/CLAUDE.md`, `control/project_context.md`, `control/jury_and_demo_goals.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md` y `workbench/WORKBENCH_STATE.md`.

Actúa como control plane del caso.

Debes:
- entender el contexto;
- decidir la primera tarea;
- escribir `control/next_task.md`;
- poner al día `control/WORKFLOW_STATE.md` antes de pasar a `workbench`.
```

## PROMPT 2 — workbench recurrente
```text
Lee `workbench/CLAUDE.md`, `control/next_task.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md` y los artefactos relevantes del caso.

Ejecuta exactamente la tarea definida por `control`.

Debes:
- actualizar `workbench/task_result.md`;
- actualizar `workbench/WORKBENCH_STATE.md`;
- generar o actualizar los artefactos necesarios;
- guardar histórico en `workbench/history/`.
```

## PROMPT 3 — control recurrente
```text
Lee `control/CLAUDE.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md`, `control/next_task.md`, `control/review_notes.md` y `workbench/task_result.md`.

Debes:
- revisar el resultado;
- revisar la coherencia entre `control/WORKFLOW_STATE.md` y `workbench/WORKBENCH_STATE.md`;
- actualizar `control/review_notes.md`;
- decidir el siguiente paso;
- actualizar `control/next_task.md` si corresponde;
- actualizar `control/WORKFLOW_STATE.md` antes de pasar de nuevo a `workbench`;
- guardar histórico en `control/history/`.
```

## PROMPT 4 — control con revisión humana
```text
Lee `control/CLAUDE.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md`, `control/next_task.md`, `control/review_notes.md` y `workbench/task_result.md`.

Incorpora estas observaciones humanas de revisión:

[PEGA AQUÍ LAS OBSERVACIONES HUMANAS]

Debes:
- integrar la revisión humana en la gobernanza;
- decidir si la tarea queda cerrada, parcialmente cerrada o reabierta;
- actualizar `control/review_notes.md`;
- emitir una nueva `control/next_task.md` correctiva si hace falta;
- actualizar `control/WORKFLOW_STATE.md`;
- guardar histórico en `control/history/`.
```

## PROMPT 5 — reabrir o retomar desde un estado concreto
```text
Lee `control/CLAUDE.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md`, `control/review_notes.md`, `control/next_task.md` y, si aplica, `workbench/task_result.md`.

Quiero reabrir o retomar el flujo desde este estado del diagrama:

[INDICA AQUÍ EL ESTADO O IDENTIFICADOR]

Contexto o cambios a introducir:

[INDICA AQUÍ LOS CAMBIOS, MOTIVOS O NUEVAS CONDICIONES]

Tu trabajo es:
- analizar el impacto de reabrir ese estado;
- marcar el estado objetivo como `En revisión` en `control/WORKFLOW_STATE.md`;
- marcar también como `En revisión` los estados posteriores afectados, si corresponde;
- conservar trazabilidad de los estados previos ya cerrados;
- preparar una nueva `control/next_task.md` para `workbench` con las modificaciones necesarias;
- dejar el flujo listo para volver al ciclo normal de ejecución;
- guardar histórico en `control/history/`.
```
