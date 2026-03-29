<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# WORKBENCH_STATE.md

## Propósito
Este documento refleja el estado local de ejecución de `workbench`, alineado con `control/WORKFLOW_STATE.md`.

## Regla de uso
`workbench` debe actualizar este documento:
- al iniciar una tarea;
- al cerrar una tarea;
- si recibe una reapertura de estado;
- y cuando un estado heredado de control cambie de situación local.

## Relación con control
- La fuente de verdad global es `control/WORKFLOW_STATE.md`.
- Este documento no sustituye a `control/WORKFLOW_STATE.md`.
- Su función es mostrar:
  - qué estados han sido asignados o heredados por `workbench`;
  - cuáles ya fueron ejecutados;
  - cuáles siguen pendientes;
  - cuáles están en curso;
  - y cuáles han vuelto a `En revisión`.

## Estados locales admitidos
- **Pendiente**
- **En curso**
- **Ejecutado**
- **En revisión**

## Plantilla de seguimiento local
### 01. Framing del caso
- Estado global heredado: Pendiente
- Estado local en workbench: Pendiente
- Última ejecución: —
- Notas:
  - —
