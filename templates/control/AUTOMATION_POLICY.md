<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# AUTOMATION_POLICY.md

## Propósito

Este documento define la política estable de automatización del framework.

La automatización principal vive en el **chat de `control` en VS Code**.

`control`:
- gobierna;
- decide;
- invoca a `workbench` como subagente;
- revisa el resultado;
- y decide si continúa o se detiene.

`workbench`:
- ejecuta exactamente la tarea activa;
- actualiza sus artefactos;
- e informa si el flujo puede continuar o debe detenerse.

`app`:
- monitoriza;
- muestra progreso;
- ayuda a navegar el flujo;
- pero no es, por ahora, el motor principal de ejecución.

---

## Regla de continuación automática

`control` puede continuar automáticamente con una nueva iteración si se cumplen todas estas condiciones:

- la siguiente tarea forma parte del plan previsto;
- no hay replanificación;
- no hay reapertura de fases anteriores;
- no aparecen tareas nuevas no previstas;
- no hay bloqueo técnico;
- no hay validación humana obligatoria;
- y no se supera el límite de 10 iteraciones automáticas consecutivas.

---

## Límite de seguridad

- máximo de iteraciones automáticas consecutivas: **10**
- al alcanzar ese límite, `control` debe detenerse y solicitar intervención humana

---

## Condiciones de parada obligatoria

`control` debe detener la automatización si ocurre cualquiera de estas situaciones:

- falta información crítica;
- aparece una contradicción relevante;
- `workbench` reporta bloqueo técnico;
- hay que redefinir una tarea previa;
- aparece una tarea nueva no prevista;
- se reabre una fase anterior;
- se requiere validación humana obligatoria;
- o se alcanza el límite de 10 iteraciones automáticas consecutivas.

---

## Validación humana obligatoria

La automatización debe detenerse siempre si aparece una decisión sobre:

- exclusión de casos de la muestra;
- definición final de muestras;
- transformación del target continuo;
- aceptación de variables sensibles o proxy;
- aprobación final del modelo;
- aprobación final del YAML definitivo.

---

## Regla de trazabilidad

La automatización no debe cambiar la filosofía de la traza documental.

Se mantienen como artefactos vivos:

- `control/next_task.md`
- `control/review_notes.md`
- `control/WORKFLOW_STATE.md`
- `workbench/task_result.md`
- `workbench/WORKBENCH_STATE.md`

La automatización debe trabajar sobre ellos, no sustituirlos.

---

## Regla de limpieza documental

### `control/next_task.md`
Debe contener solo la tarea activa vigente.

### `workbench/task_result.md`
Debe contener solo el resultado de la tarea actual o de la última ejecución cerrada.

No deben usarse como logs acumulativos de todo el proyecto.

---

## Regla sobre Streamlit

La app Streamlit debe tratarse como:

- monitor;
- cockpit visual;
- ayuda de seguimiento;
- guía del estado del flujo;

pero **no** como motor principal de ejecución de iteraciones.
