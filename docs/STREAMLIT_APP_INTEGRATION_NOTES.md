<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# STREAMLIT_APP_INTEGRATION_NOTES.md

## Propósito de la app Streamlit

La app Streamlit forma parte del framework como capa de:

- monitorización;
- visualización de estados;
- navegación de artefactos;
- ayuda para entender el flujo;
- y soporte operativo de seguimiento.

## Papel correcto de la app

La app debe actuar como:

- monitor del estado global (`control/WORKFLOW_STATE.md`);
- monitor del estado local (`workbench/WORKBENCH_STATE.md`);
- cockpit visual del proyecto;
- ayuda para identificar el siguiente paso;
- visor de resultados, notas y documentos;

pero **no** como motor principal de ejecución del bucle entre `control` y `workbench`.

## Orquestación principal

La orquestación principal vive en el **chat de `control` en VS Code**.

Eso significa que:

- `control` gobierna el flujo;
- `control` invoca a `workbench` como subagente;
- `control` revisa el resultado;
- y `control` continúa o se detiene según las condiciones definidas en:
  - `control/DEMO_WORKFLOW_STANDARD.md`
  - `control/AUTOMATION_POLICY.md`

## Qué puede hacer la app

Sí puede:
- mostrar progreso;
- mostrar estados;
- mostrar artefactos;
- servir de cuadro de mando;
- orientar sobre qué parte del flujo está activa;
- apoyar la comprensión del proyecto.

## Qué no debe asumir por defecto

No debe asumir por defecto:
- que ejecuta automáticamente a `control`;
- que ejecuta automáticamente a `workbench`;
- ni que sustituye la conversación principal de orquestación en VS Code.

## Posible evolución futura

En el futuro, la app podría incorporar capacidades de dispatch o soporte a automatización.

Pero ese no es el diseño principal actual del framework.

El diseño principal actual es:

**persona → control (VS Code) → workbench subagente → control → ...**
