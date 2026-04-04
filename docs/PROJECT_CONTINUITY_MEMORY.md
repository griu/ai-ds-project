<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# PROJECT_CONTINUITY_MEMORY.md

## Finalidad de este documento
Este documento actúa como **memoria de continuidad** del proyecto `ai-ds-project`.

Su objetivo es permitir que, en una conversación futura o en otro hilo distinto, pueda recuperarse con rapidez:
- la finalidad del proyecto;
- la visión metodológica;
- los criterios de diseño;
- las decisiones arquitectónicas ya tomadas;
- los requisitos funcionales y no funcionales consolidados;
- y el sentido general de evolución del sistema.

Este documento vive **fuera de `control/` y de `workbench/`** porque no pertenece al flujo operativo interno de un caso concreto, sino a la lógica general y persistente del repositorio maestro `ai-ds-project`.

## Resumen ejecutivo
`ai-ds-project` es un framework maestro para diseñar, instanciar y ejecutar proyectos de Data Science gobernados con asistentes de código en VS Code. La arquitectura separa explícitamente gobierno (`control`) y ejecución (`workbench`), pero ambos trabajan sobre la misma raíz del repo del caso mediante workspaces separados. La orquestación principal debe vivir en el **chat de `control` en VS Code**, que puede invocar a `workbench` como subagente y cerrar ciclos de forma autónoma mientras no aparezca una condición de parada humana. Streamlit queda como monitor, cockpit de seguimiento y ayuda visual, no como motor principal de ejecución.

## Qué es realmente `ai-ds-project`
`ai-ds-project` es un **repositorio maestro de framework** para demostrar, enseñar y operacionalizar una forma gobernada de construir proyectos de Data Science con ayuda de asistentes de código en VS Code, usando principalmente Claude Sonnet 4.6 y, cuando haga falta, Claude Opus 4.6.

No es el repositorio del proyecto activo de negocio.  
No es el caso de uso final.  
No es un repo donde se modela directamente un dataset concreto.

Es, sobre todo, un **marco reusable** que permite:
- definir cómo se organizan los proyectos;
- separar gobierno y ejecución;
- convertir documentación de negocio y técnica en especificaciones accionables;
- construir proyectos de forma trazable;
- y demostrar una forma rigurosa, didáctica y escalable de trabajar con asistentes de código.

## Idea base del sistema: control, workbench y app
La arquitectura gira alrededor de tres piezas:
- `control/`
- `workbench/`
- `app/`

### `control/`
Representa la capa de:
- gobierno;
- definición de tareas;
- revisión de resultados;
- priorización;
- y decisión del siguiente paso.

Su salida principal es la definición de la siguiente tarea y la revisión del estado del proyecto.  
Además, en el diseño actual, `control` puede **invocar a `workbench` como subagente** y cerrar iteraciones de forma autónoma desde VS Code.

### `workbench/`
Representa la capa de:
- ejecución;
- análisis;
- código;
- notebooks;
- documentación técnica operativa;
- y devolución estructurada del resultado.

No debe redefinir el objetivo de la tarea por su cuenta.  
Debe ejecutar lo que el control plane define y devolver un resumen claro del trabajo realizado.

### `app/`
Es la capa de:
- monitorización;
- cockpit visual;
- lectura de la traza;
- orientación sobre prompts y artefactos.

No debe, por ahora, ser el motor principal del bucle autónomo.

## Cambio clave de diseño: un único repo por caso
Cada caso instanciado es **un único repo**.  
Dentro del repo existen tres carpetas:
- `control/`
- `workbench/`
- `app/`

y tres workspaces en la raíz:
- `control.code-workspace`
- `workbench.code-workspace`
- `app.code-workspace`

Los workspaces abren la **misma raíz del caso**.

## Repo maestro y casos hermanos
`ai-ds-project` es el repo maestro.  
Los casos instanciados se crean fuera, normalmente como repos hermanos.

## Visión metodológica
El patrón buscado es:
1. entender el caso;
2. definir una tarea pequeña y verificable;
3. ejecutarla;
4. revisar el resultado;
5. decidir si se cierra o se reabre;
6. avanzar al siguiente estado.

La evolución más reciente añade un matiz importante:

- la persona ya no tiene por qué hacer de puente manual entre `control` y `workbench` en cada paso;
- el chat de `control` en VS Code puede orquestar iteraciones autónomas con `workbench`;
- la persona solo interviene cuando aparece una condición de parada prevista.

## Público objetivo
La demo está pensada para una audiencia de **Data Scientists expertos** o habituados a proyectos reales de modelización.

## Filosofía de prompts
Se tomó la decisión de mover la mayor cantidad posible de reglas estables a markdowns de comportamiento, para dejar los prompts operativos más ligeros.

El sistema se apoya en:
- `control/CLAUDE.md`
- `workbench/CLAUDE.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/AUTOMATION_POLICY.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

## Dinámica de trabajo definitiva
La dinámica principal correcta es:

**persona → chat de control en VS Code**

y, dentro de ese chat:

**control → subagente workbench → control → subagente workbench → ...**

La persona solo:
- arranca;
- observa;
- y vuelve a intervenir si `control` se detiene.

## Estados del flujo y trazabilidad
### Estado global
`control/WORKFLOW_STATE.md` es la fuente de verdad del plan.

### Estado local de workbench
`workbench/WORKBENCH_STATE.md` refleja:
- qué estados heredó de control;
- cuáles ejecutó;
- cuáles siguen pendientes;
- cuáles están en curso;
- y cuáles han vuelto a revisión.

## Reapertura del flujo
El sistema debe permitir:
- reabrir un estado ya cerrado;
- iterar de nuevo desde un punto concreto;
- y mantener trazabilidad de lo que ya se había cerrado previamente.

## Requisitos técnicos ya consolidados
El sistema debe soportar y reflejar:
- EDA univariante y bivariante respecto al target;
- uso preferente de `ydata-profiling`;
- diagnóstico de monotonicidades;
- validación humana de transformación del target continuo;
- benchmark XGBoost con y sin monotonicidades;
- métricas mínimas obligatorias;
- soporte preferente de GPU;
- configuración por YAML y CSV;
- Optuna;
- explicabilidad con PDP y SHAP.

## Requisitos sobre aceptación de variables
No basta con señal estadística.  
La aceptación de variables debe revisar:
- causalidad o explicación razonable;
- interpretabilidad de negocio;
- fairness y regulación;
- proxies;
- coherencia de signo;
- coherencia de monotonicidad;
- comportamiento de missing.

## Requisitos sobre definición de muestras
Debe existir una fase separada de:
- definición de unidad de análisis;
- ventana de observación;
- target;
- filtros de selección;
- exclusiones;
- trazabilidad de población inicial y final;
- y validación humana de decisiones relevantes.

## Sincronización control y workbench
- `control/WORKFLOW_STATE.md` manda.
- `workbench/WORKBENCH_STATE.md` refleja el avance local alineado.
- `workbench` no debe trabajar “ciego”.
- `control` debe revisar la coherencia entre ambos estados.

## Streamlit como monitor
La app Streamlit:
- muestra estado;
- ayuda a navegar artefactos;
- sugiere prompts;
- pero no debe convertirse, por ahora, en el motor principal del bucle.

## Generación de nuevos casos
El repo no solo sirve para ejecutar casos ya definidos, sino también para **crear nuevos casos alineados con la arquitectura y la metodología**.

## Licencia y trazabilidad del scaffold
Se decidió:
- usar encabezados SPDX en archivos clave;
- copiar `COPYING` y `COPYING.LESSER` al repo instanciado si existen;
- y dejar claro que los ficheros derivados del scaffold deben conservar trazabilidad de licencia.

## Modelo de uso de Claude
Usar principalmente:
- **Claude Sonnet 4.6** por defecto;
- **Claude Opus 4.6** solo cuando realmente haga falta.

## Principios de diseño
1. Separación clara de roles.
2. Un caso = un repo.
3. Una raíz única por caso.
4. Trazabilidad visible.
5. Prompts ligeros.
6. Validación humana donde corresponde.
7. Coherencia metodológica.
8. Defensa técnica ante audiencia experta.
9. Reutilización.
10. Evolución gradual.

## Qué no debe olvidarse en futuros hilos
- `ai-ds-project` es el **framework**, no el caso;
- los casos son repos hermanos instanciados;
- control y workbench comparten raíz del caso;
- la dinámica principal es `control` orquestando desde VS Code;
- hay estado global y estado local;
- la definición de muestras es una fase obligatoria;
- la aceptación de variables debe mirar causalidad, negocio, fairness y regulación;
- hay validaciones humanas obligatorias;
- los prompts deben mantenerse ligeros;
- Streamlit es monitor y guía, no el motor principal;
- el framework está pensado para una audiencia DS experta;
- y el sistema debe seguir evolucionando con coherencia.

## Criterio de evolución futura
La pregunta guía para futuros cambios debería ser:

**“¿Esto mejora la capacidad real del sistema sin romper su simplicidad, coherencia y trazabilidad?”**
