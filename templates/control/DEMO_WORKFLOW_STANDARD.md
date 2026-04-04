<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# DEMO_WORKFLOW_STANDARD.md

## Objetivo

Este documento define la dinámica estándar de trabajo de la demo para cualquier caso instanciado del framework.

La demo funciona con un único repositorio de caso, con tres áreas de trabajo diferenciadas:

- `control/`
- `workbench/`
- `app/`

La orquestación principal vive en el **chat de `control` en VS Code**.

La interacción correcta es:

**persona → control (orquesta) → workbench (subagente) → control → ...**

La persona no debe actuar como puente manual entre `control` y `workbench` en cada ciclo.  
Solo debe intervenir cuando `control` detecte una condición de parada humana.

---

## Papel de cada componente

### `control`
Es la capa de gobierno y orquestación.

Debe:
- decidir la tarea activa;
- invocar a `workbench` como subagente;
- revisar el resultado;
- actualizar el estado del proyecto;
- decidir si puede continuar automáticamente;
- y detenerse solo cuando aparezca una condición de parada.

### `workbench`
Es la capa de ejecución.

Debe:
- ejecutar exactamente la tarea activa definida por `control`;
- actualizar su resultado y su estado local;
- y devolver señales claras sobre si el flujo puede continuar o debe detenerse.

### `app`
Es una capa de monitorización y guía.

Debe:
- mostrar el estado global y local;
- facilitar la lectura del flujo;
- ayudar a navegar artefactos y decisiones;
- pero **no** actúa, por ahora, como motor principal de ejecución.

---

## Documentos clave del framework en el caso

- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/AUTOMATION_POLICY.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

Tanto `control` como `workbench` deben respetarlos.

---

## Regla de automatización principal

`control` puede continuar iterando automáticamente con `workbench` mientras:

- la siguiente tarea forme parte del plan previsto;
- no haya replanificación;
- no haya reapertura de fases anteriores;
- no aparezcan tareas nuevas no previstas;
- no haya bloqueo técnico;
- no haya validación humana obligatoria;
- y no se supere el límite de 10 iteraciones automáticas consecutivas.

---

## Condiciones de parada obligatoria

`control` debe detener la iteración automática y pedir intervención humana si ocurre cualquiera de estas situaciones:

- falta información crítica;
- aparece una contradicción relevante;
- `workbench` reporta bloqueo técnico;
- hay que redefinir una tarea previa;
- aparece una tarea no prevista en el plan;
- se reabre una fase anterior;
- se requiere validación humana obligatoria;
- o se alcanza el límite de 10 iteraciones automáticas consecutivas.

### Casos típicos de validación humana obligatoria
- exclusión de casos de la muestra;
- definición final de muestras;
- transformación del target continuo;
- aceptación de variables sensibles o proxy;
- aprobación final del modelo;
- aprobación final del YAML definitivo.

---

## Regla de sincronización entre control y workbench

- `control/WORKFLOW_STATE.md` es la fuente de verdad del estado global.
- `workbench/WORKBENCH_STATE.md` es la traza local de ejecución de `workbench`.
- `workbench` debe tomar como punto de partida el diagrama de estados definido en `control`.
- `control` debe revisar la coherencia entre ambos documentos al cierre de cada iteración.

---

## Regla de limpieza documental

### `control/next_task.md`
Debe contener solo la tarea activa vigente.

No deben acumularse:
- tareas cerradas;
- tareas antiguas;
- ni versiones superseded.

### `workbench/task_result.md`
Debe contener solo el resultado de la tarea actual o de la última ejecución cerrada.

No deben acumularse:
- resultados históricos;
- resultados de tareas antiguas;
- ni bloques heredados desordenados.

La trazabilidad histórica debe vivir en:
- Git;
- `history/`;
- o documentos específicos;
pero no como acumulación dentro de esos dos ficheros vivos.

---

## Regla de estados

### Estado global
`control` mantiene `control/WORKFLOW_STATE.md`.

Estados admitidos:
- `Pendiente`
- `En curso`
- `Finalizado`
- `En revisión`

### Estado local de workbench
`workbench` mantiene `workbench/WORKBENCH_STATE.md`.

Estados admitidos:
- `Pendiente`
- `En curso`
- `En revisión`
- `Finalizado`

---

## Filosofía de prompts

Los prompts recurrentes deben ser ligeros.

La lógica estable vive en:
- `control/CLAUDE.md`
- `workbench/CLAUDE.md`
- `control/AUTOMATION_POLICY.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

Los prompts operativos deben limitarse a:
- activar el rol correcto;
- recordar qué artefactos revisar;
- y definir la salida esperada.

---

## Prompt 1 — Bootstrap inicial de control

Este prompt se usa una sola vez al arrancar el caso.

Objetivo:
- entender el contexto;
- producir la primera `control/next_task.md`;
- y dejar el estado inicial correctamente preparado.

---

## Prompt 2 — Prompt maestro de orquestación autónoma de control

Este es el prompt principal del sistema.

Debe:
- revisar el estado del proyecto;
- decidir si existe una tarea activa válida;
- redactar o actualizar `control/next_task.md`;
- invocar a `workbench` como subagente;
- revisar `workbench/task_result.md`;
- actualizar:
  - `control/review_notes.md`
  - `control/WORKFLOW_STATE.md`
- decidir si puede continuar automáticamente;
- y repetir en este mismo turno mientras no exista condición de parada.

Este prompt es el mecanismo central de la automatización.

---

## Prompt 3 — Revisión humana correctiva de control

Se usa cuando la persona quiere introducir observaciones humanas sobre un resultado o una decisión ya tomada por el sistema.

Objetivo:
- incorporar observaciones humanas;
- corregir revisión;
- redefinir tarea si hace falta;
- o reabrir una fase.

---

## Prompt 4 — Reapertura desde un estado anterior

Se usa cuando se quiere volver explícitamente a un estado o fase anterior del plan.

Objetivo:
- marcar estados afectados como `En revisión`;
- regenerar la siguiente tarea;
- y reintroducir el flujo en el ciclo normal.

---

## Prompt 5 — Ejecución manual de fallback para workbench

Este prompt solo se usa como respaldo.

Debe utilizarse:
- si el entorno no permite invocar `workbench` como subagente desde `control`;
- o si `control` ha pedido explícitamente un fallback manual.

No es el flujo principal del framework.

---

## Bucle estándar real del sistema

### Inicio
1. La persona abre `control.code-workspace`
2. Lanza el prompt bootstrap inicial de `control`
3. `control` crea la primera `control/next_task.md`
4. `control` actualiza `control/WORKFLOW_STATE.md`

### Bucle normal
5. La persona lanza el prompt maestro de orquestación autónoma de `control`
6. `control` invoca a `workbench` como subagente
7. `workbench` ejecuta y actualiza:
   - `workbench/task_result.md`
   - `workbench/WORKBENCH_STATE.md`
8. `control` revisa y actualiza:
   - `control/review_notes.md`
   - `control/WORKFLOW_STATE.md`
9. Si no hay condición de parada, `control` continúa automáticamente en este mismo turno
10. Si hay condición de parada, `control` se detiene y pide ayuda humana

---

## Papel de Streamlit

La app Streamlit debe actuar como:

- monitor del estado global;
- monitor del estado local;
- visor de artefactos;
- cockpit de seguimiento;
- ayuda para navegar el flujo;
- guía sobre el siguiente paso;

pero **no** como motor principal de ejecución de iteraciones.

---

## Qué no hacer

- No usar a la persona como puente manual entre `control` y `workbench` en cada ciclo.
- No usar Streamlit como motor principal de ejecución.
- No ignorar `PROJECT_TECHNICAL_REQUIREMENTS.md`.
- No ignorar `WORKFLOW_STATE.md`.
- No ignorar `WORKBENCH_STATE.md`.
- No pasar a modelización si falta validación humana obligatoria.
- No acumular tareas o resultados antiguos en los ficheros vivos.
