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

`ai-ds-project` es un framework maestro para diseñar, instanciar y ejecutar proyectos de Data Science gobernados con asistentes de código en VS Code. La arquitectura separa explícitamente gobierno (`control`) y ejecución (`workbench`), pero ambos trabajan sobre la misma raíz del repo del caso mediante dos workspaces separados. El sistema está pensado para una audiencia DS experta y exige trazabilidad, definición explícita de muestras, EDA bivariante respecto al target, revisión de variables por causalidad y fairness, modelado gobernado, validación humana donde corresponda y documentación suficientemente robusta para retomar el proyecto en futuros hilos.

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

## Idea base del sistema: control y workbench

La arquitectura gira alrededor de dos áreas de trabajo diferenciadas:
- `control/`
- `workbench/`

### `control/`
Representa la capa de:
- gobierno;
- definición de tareas;
- revisión de resultados;
- priorización;
- y decisión del siguiente paso.

### `workbench/`
Representa la capa de:
- ejecución;
- análisis;
- código;
- notebooks;
- documentación técnica operativa;
- y devolución estructurada del resultado.

## Cambio clave de diseño: un único repo por caso

Cada caso instanciado es **un único repo**.  
Dentro del repo existen dos carpetas:
- `control/`
- `workbench/`

y dos workspaces en la raíz:
- `control.code-workspace`
- `workbench.code-workspace`

Los dos workspaces abren la **misma raíz del caso**.  
La diferencia no está en la raíz abierta, sino en el rol del chat y en la carpeta de referencia.

Esta decisión se tomó para:
- evitar rutas confusas;
- evitar repos Git anidados;
- simplificar la demo;
- y dejar claro que control y workbench son dos funciones del mismo proyecto.

## Repo maestro y casos hermanos

`ai-ds-project` es el repo maestro.  
Los casos instanciados se crean fuera, normalmente como repos hermanos.

Ejemplo conceptual:

```text
<parent>/
├─ ai-ds-project/
├─ home-credit/
└─ pkdd99/
```

## Visión metodológica

El patrón buscado es:
1. entender el caso;
2. definir una tarea pequeña y verificable;
3. ejecutarla;
4. revisar el resultado;
5. decidir si se cierra o se reabre;
6. avanzar al siguiente estado.

La finalidad es evitar:
- saltar directamente a modelización;
- improvisar la secuencia;
- mezclar fases;
- perder trazabilidad.

## Público objetivo

La demo está pensada para una audiencia de **Data Scientists expertos** o habituados a proyectos reales de modelización.

Esto exige profundidad en:
- data quality;
- definición de muestras;
- EDA;
- transformación y selección de variables;
- modelización avanzada;
- comparación entre modelos;
- interpretabilidad;
- validación por segmentos;
- y preparación para productivización.

## Filosofía de prompts

Se tomó la decisión de mover la mayor cantidad posible de reglas estables a markdowns de comportamiento, para dejar los prompts operativos más ligeros.

El sistema se apoya en:
- `control/CLAUDE.md`
- `workbench/CLAUDE.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

La filosofía es:
- **reglas permanentes en markdowns estables**;
- **prompts operativos breves**.

## Dinámica de trabajo definitiva

La dinámica correcta es:

**persona → control → workbench → control → workbench → ...**

La persona:
- arranca;
- lanza el prompt al actor correcto;
- y solo interviene otra vez si el control plane lo pide o si quiere introducir una revisión humana formalizada vía control.

## Estados del flujo y trazabilidad

### Estado global
`control/WORKFLOW_STATE.md` es la fuente de verdad del plan.

Debe mostrar:
- estados pendientes;
- en curso;
- finalizados;
- en revisión;

y, cuando un estado se cierra:
- fecha en formato `DD-MM-YYYY`;
- resumen compacto del cierre.

### Estado local de workbench
`workbench/WORKBENCH_STATE.md` no sustituye al estado global.  
Su función es mostrar:
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

Por eso existe la idea de un prompt específico para:
- reabrir o retomar el flujo desde un estado concreto del diagrama.

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

El sistema debe revisar variables desde:
- lógica causal o explicativa;
- interpretabilidad de negocio;
- fairness;
- regulación;
- proxies;
- coherencia de signo;
- coherencia de monotonicidad;
- y comportamiento de missing.

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

## Generación de nuevos casos

El repo no solo sirve para ejecutar casos ya definidos, sino también para **crear nuevos casos alineados con la arquitectura y la metodología**.

Por eso el `README.md` raíz incluye un prompt de arranque para:
- analizar documentación de entrada;
- identificar lagunas y contradicciones;
- y generar overlays para `demo/cases/<slug>/`.

## Licencia y trazabilidad del scaffold

Se decidió:
- usar encabezados SPDX en archivos clave;
- copiar `COPYING` y `COPYING.LESSER` al repo instanciado si existen;
- y dejar claro que los ficheros derivados del scaffold deben conservar trazabilidad de licencia.

## Modelo de uso de Claude

Usar principalmente:
- **Claude Sonnet 4.6** por defecto;
- **Claude Opus 4.6** solo cuando realmente haga falta:
  - ambigüedad alta,
  - contradicciones,
  - rediseño complejo,
  - o razonamiento especialmente exigente.

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
- la dinámica es persona → control → workbench → control;
- hay estado global y estado local;
- la definición de muestras es una fase obligatoria;
- la aceptación de variables debe mirar causalidad, negocio, fairness y regulación;
- hay validaciones humanas obligatorias;
- los prompts deben mantenerse ligeros;
- las reglas estables deben vivir en markdowns persistentes;
- el framework está pensado para una audiencia DS experta;
- y el sistema debe seguir evolucionando con coherencia.

## Criterio de evolución futura

La pregunta guía para futuros cambios debería ser:

**“¿Esto mejora la capacidad real del sistema sin romper su simplicidad, coherencia y trazabilidad?”**
