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

---

# 1. Qué es realmente `ai-ds-project`

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

La motivación de fondo es enseñar que un proyecto de Data Science no debe arrancar solo con notebooks o scripts, sino con una estructura clara de:
- framing;
- criterios de negocio;
- definición de muestras;
- gobierno de tareas;
- evolución iterativa;
- y control explícito del paso de una fase a otra.

---

# 2. Idea base del sistema: control y workbench

La arquitectura gira alrededor de dos áreas de trabajo diferenciadas:

- `control/`
- `workbench/`

## `control/`
Representa la capa de:
- gobierno;
- definición de tareas;
- revisión de resultados;
- priorización;
- y decisión del siguiente paso.

No es la capa donde se ejecuta el trabajo técnico profundo.  
Su salida principal es la definición de la siguiente tarea y la revisión del estado del proyecto.

## `workbench/`
Representa la capa de:
- ejecución;
- análisis;
- código;
- notebooks;
- documentación técnica operativa;
- y devolución estructurada del resultado.

No debe redefinir el objetivo de la tarea por su cuenta.  
Debe ejecutar lo que el control plane define y devolver un resumen claro del trabajo realizado.

---

# 3. Cambio clave de diseño: un único repo por caso

Inicialmente se contempló la posibilidad de que control y workbench fueran repos separados.  
Esa opción se descartó para la demo porque generaba fricción innecesaria.

La decisión final fue:

- cada caso instanciado es **un único repo**;
- dentro del repo existen dos carpetas:
  - `control/`
  - `workbench/`

y además dos workspaces en la raíz:
- `control.code-workspace`
- `workbench.code-workspace`

Los dos workspaces abren la **misma raíz del caso**.  
La diferencia no está en la raíz abierta, sino en el rol del chat y en la carpeta de referencia.

Esta decisión se tomó para:
- evitar confusiones con rutas tipo `../control` o `../workbench`;
- evitar trabajar con repos anidados extraños;
- simplificar la demo en VS Code;
- y dejar claro que control y workbench son dos funciones del mismo proyecto, no dos proyectos distintos.

---

# 4. `ai-ds-project` como repo maestro y los casos como repos hermanos

Otra decisión importante fue separar:

## Repo maestro
`ai-ds-project`

Aquí evolucionan:
- las plantillas;
- los prompts;
- los skills;
- los agentes;
- los markdowns de comportamiento;
- los scripts de instanciación;
- y la documentación general del framework.

## Repos instanciados por caso
Cada caso nuevo se crea como repo nuevo fuera del repo maestro, normalmente como **hermano** de `ai-ds-project`.

Ejemplo conceptual:

```text
<parent>/
├─ ai-ds-project/
├─ home-credit/
└─ pkdd99/
```

Esto evita:
- meter repos Git dentro de otro repo Git;
- contaminar el repo maestro con estado operativo del caso;
- y mezclar la evolución del framework con el trabajo real de una instancia concreta.

---

# 5. Visión metodológica: proyecto gobernado e iterativo

La idea de fondo no es solo crear carpetas.  
Es imponer una **lógica de trabajo gobernada**.

El patrón buscado es:

1. entender el caso;
2. definir una tarea pequeña y verificable;
3. ejecutarla;
4. revisar el resultado;
5. decidir si se cierra o se reabre;
6. avanzar al siguiente estado.

Este enfoque evita:
- saltar directamente a modelización;
- improvisar la secuencia de trabajo;
- mezclar varias fases en una sola tarea;
- y perder trazabilidad sobre por qué se hizo cada cosa.

La intención es que el sistema se comporte como una combinación de:
- control de proyecto,
- método de Data Science,
- y scaffolding reusable para asistentes de código.

---

# 6. Público objetivo y tono esperado

La demo no está pensada para un público principiante.  
Está pensada para una audiencia de **Data Scientists expertos** o, al menos, acostumbrados a proyectos reales de modelización.

Eso implica que el nivel de exigencia del framework debe ser alto en aspectos como:
- data quality;
- EDA potente;
- selección y transformación de variables;
- modelización avanzada;
- comparación entre modelos;
- interpretabilidad;
- validación por segmentos;
- y preparación razonable para productivización.

No basta con que “funcione”.  
Debe ser defendible ante personas que esperan profundidad y criterio técnico.

---

# 7. Decisión importante: los prompts deben ser ligeros

Durante la evolución del diseño apareció un problema claro:
los prompts recurrentes crecían demasiado y mezclaban:
- reglas estables;
- lógica del sistema;
- instrucciones de flujo;
- y detalles de contexto repetidos.

La decisión tomada fue mover la mayor cantidad posible de reglas estables a markdowns de comportamiento, para dejar los prompts operativos más ligeros.

Por eso el sistema se apoya mucho en:
- `control/CLAUDE.md`
- `workbench/CLAUDE.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

La filosofía es:
- **reglas permanentes en markdowns estables**;
- **prompts operativos breves**.

---

# 8. Dinámica de trabajo definitiva

La dinámica correcta es:

**persona → control → workbench → control → workbench → ...**

No:
- persona → workbench directamente;
- ni persona → asistente externo → control/workbench.

La persona:
- arranca;
- lanza el prompt al actor correcto;
- y solo interviene otra vez si el control plane lo pide o si quiere introducir una revisión humana formalizada vía control.

Esto se definió así porque era importante que la demo mostrara:
- gobierno autónomo;
- ejecución autónoma;
- y escalado a intervención humana solo cuando realmente corresponde.

---

# 9. Estados del flujo y trazabilidad

Otra decisión importante fue que no bastaba con `next_task.md` y `task_result.md`.  
Había que hacer visible el **estado del plan**.

Por eso se introdujo:
- `control/WORKFLOW_STATE.md` como estado global del proyecto;
- `workbench/WORKBENCH_STATE.md` como estado local de ejecución de workbench.

## Estado global
`control/WORKFLOW_STATE.md` es la fuente de verdad del plan.

Debe mostrar:
- estados pendientes;
- en curso;
- finalizados;
- en revisión;

y, cuando un estado se cierra:
- fecha en formato `DD-MM-YYYY`;
- resumen compacto del cierre.

## Estado local de workbench
`workbench/WORKBENCH_STATE.md` no sustituye al estado global.  
Su función es mostrar:
- qué estados heredó de control;
- cuáles ejecutó;
- cuáles siguen pendientes;
- cuáles están en curso;
- y cuáles han vuelto a revisión.

Esta doble capa se introdujo para que:
- control mantenga la verdad del proyecto;
- workbench mantenga su trazabilidad local;
- y ambos niveles puedan sincronizarse sin perder contexto.

---

# 10. Reapertura del flujo

Se decidió explícitamente que el sistema debe permitir:
- reabrir un estado ya cerrado;
- iterar de nuevo desde un punto concreto;
- y mantener trazabilidad de lo que ya se había cerrado previamente.

Por eso existe la idea de un prompt específico para:
- reabrir o retomar el flujo desde un estado concreto del diagrama.

Cuando esto ocurre:
- el estado reabierto pasa a `En revisión`;
- los posteriores afectados también pueden pasar a `En revisión`;
- y el sistema vuelve a entrar en el flujo normal.

Esto es importante porque en proyectos reales:
- no todo avanza linealmente;
- a veces hay que volver atrás;
- y la demo debe soportarlo de forma ordenada.

---

# 11. Requisitos técnicos ya consolidados

A lo largo de esta conversación se fue ampliando el conjunto de requisitos del framework.  
No todos nacieron de golpe; se fueron acumulando en bloques.

Lo relevante es que hoy el sistema debe soportar y reflejar:

## EDA
- EDA univariante;
- EDA bivariante respecto al target;
- variables continuas, binarias y categóricas;
- target binario, continuo o categórico;
- volumen por tramo o categoría;
- propensión/media/métrica equivalente;
- kernel density o quantiles;
- LOESS o equivalente rápido;
- uso preferente de `ydata-profiling`.

## Monotonicidades
- diagnóstico respecto al target;
- tratamiento de binarias numéricas como continuas;
- propuesta de monotonicidades para XGBoost;
- validación posterior comparando modelo con y sin monotonicidades.

## Target continuo
- evaluación de transformación del target;
- pero con parada obligatoria para validación humana antes de continuar.

## XGBoost
- benchmark con y sin monotonicidades;
- comparación train / validation / test;
- logloss para binario;
- curvas de logloss;
- early stopping con paciencia mínima;
- y explicación del criterio de parada.

## GPU
- uso preferente si existe hardware compatible.

## Métricas
- clasificación binaria: AUC y Gini;
- regresión: RMSE, R², MAE, MAPE;
- y reporte en escala transformada y original si aplica.

## YAML y Optuna
- hiperparámetros editables por YAML;
- variables y monotonicidades editables por YAML;
- inventario completo de variables candidatas en YAML o CSV;
- Optuna para modelos relevantes;
- control de rangos, activación y desactivación de parámetros;
- control específico sobre learning rate e iteraciones;
- y rechazo de postcalibraciones indeseadas.

## Explicabilidad
- PDP;
- SHAP;
- comparación con los bivariantes del EDA;
- y atención a tiempos de ejecución.

---

# 12. Requisitos añadidos sobre aceptación de variables

Posteriormente se reforzó algo muy importante:
**no basta con que una variable tenga señal estadística**.

El sistema debe revisar variables desde:
- lógica causal o explicativa;
- interpretabilidad de negocio;
- fairness;
- regulación;
- proxies;
- coherencia de signo;
- coherencia de monotonicidad;
- y comportamiento de missing.

Esto surgió para evitar modelos que:
- “funcionan” estadísticamente,
- pero son poco defendibles,
- poco causales,
- sesgados,
- o problemáticos desde regulación.

Ejemplos discutidos:
- código postal como proxy débil;
- gasto bruto frente a ratio gasto / ingresos;
- señales empíricas incoherentes por sesgo muestral;
- variables especialmente protegidas o proxies de estas.

La conclusión fue:
el framework debe levantar alertas, no solo rankings de importancia.

---

# 13. Requisitos añadidos sobre definición de muestras

Otro bloque importante fue la **separación explícita de la fase de definición de muestras**.

Se decidió que entre:
- data quality,
- EDA,
- y modelado

debe existir una fase específica de:
- definición de unidad de análisis;
- definición de ventana de observación;
- definición del target;
- filtros de selección;
- exclusiones;
- trazabilidad de población inicial y final;
- y validación humana de decisiones relevantes.

Esto se introdujo porque, en la práctica, una gran parte de la calidad real del modelo depende de:
- cómo se define la fila;
- cuándo se observa;
- qué se excluye;
- y qué target se construye.

Se consideró esencial distinguir:
- problemas de originación;
- problemas comportamentales;
- repetición de observaciones por individuo;
- y posibles ventanas múltiples de target.

---

# 14. Requisitos añadidos sobre sincronización entre control y workbench

Después se identificó otra necesidad:
no bastaba con el estado global en `control`.  
`workbench` también debía poder saber en qué punto del flujo estaba y qué había ejecutado ya.

Por eso se añadió:
- `workbench/WORKBENCH_STATE.md`

y la regla de sincronización:
- `control/WORKFLOW_STATE.md` manda;
- `workbench/WORKBENCH_STATE.md` refleja el avance local alineado.

La intención es que:
- `workbench` no trabaje “ciego”;
- se vea qué estados heredó;
- qué ejecutó;
- y qué sigue pendiente o en revisión.

---

# 15. Requisitos añadidos sobre simplificación y coherencia global

Otra línea de trabajo importante fue limpiar incoherencias:
- rutas tipo `../control`;
- referencias demasiado ligadas a `~/git`;
- prompts excesivamente largos;
- ambigüedad entre pasos 11 y 12 del workflow;
- y mezcla entre reglas operativas y reglas estables.

La dirección tomada fue:
- workspaces sobre la misma raíz;
- rutas siempre relativas a la raíz del caso;
- markdowns estables para la lógica;
- y prompts operativos mínimos.

Esto es importante porque el proyecto no busca solo ser potente, sino también:
- fácil de mantener;
- consistente;
- y reutilizable por otros usuarios.

---

# 16. Requisitos añadidos sobre generación de nuevos casos

También se pidió un mecanismo claro para:
- partir de documentación listada en una carpeta;
- requisitos adicionales;
- y explicaciones de los documentos;

y a partir de ello generar las especificaciones necesarias para un nuevo caso en `demo/cases/<slug>/`.

La intención es que el repo no solo sirva para ejecutar casos ya definidos, sino también para **crear nuevos casos de forma alineada con la arquitectura y la metodología**.

Por eso se decidió añadir al `README.md` raíz:
- un prompt de arranque completo para generar nuevos casos a partir de documentación externa.

Ese prompt debe:
- alimentarse del contexto ya existente del repo;
- reutilizar plantillas, convenciones y patrones;
- preguntar cuando falten piezas relevantes;
- y no construir la estructura final si el caso está mal definido.

---

# 17. Decisiones sobre licencia y trazabilidad del scaffold

Se añadió también una preocupación sobre licencia y reutilización del scaffold.

Se decidió:
- usar encabezados SPDX en archivos clave;
- copiar `COPYING` y `COPYING.LESSER` al repo instanciado si existen;
- y dejar claro que los ficheros derivados del scaffold deben conservar trazabilidad de licencia.

Esto no era el foco principal del proyecto, pero sí un criterio de higiene y redistribución razonable.

---

# 18. Modelo de uso de Claude

Otra decisión importante:
el sistema debe trabajar principalmente con:

- **Claude Sonnet 4.6** como opción por defecto;
- **Claude Opus 4.6** solo cuando realmente haga falta:
  - ambigüedad alta,
  - contradicciones,
  - rediseño complejo,
  - o razonamiento especialmente exigente.

No se quiere un sistema que escale a Opus por defecto, sino uno que:
- priorice eficiencia;
- pero permita profundidad cuando sea necesaria.

---

# 19. Principios de diseño que deben preservarse

Estos principios resumen la visión del proyecto:

## 1. Separación clara de roles
Control gobierna.  
Workbench ejecuta.

## 2. Un caso = un repo
No fragmentar el caso en múltiples repos.

## 3. Una raíz única por caso
Evitar rutas confusas y workspaces desalineados.

## 4. Trazabilidad visible
Estado global, estado local, histórico y resumen de cierres.

## 5. Prompts ligeros
La inteligencia estable vive en markdowns de comportamiento.

## 6. Validación humana donde corresponde
No automatizar decisiones que deben ser explícitamente aceptadas.

## 7. Coherencia metodológica
No saltar fases críticas por rapidez aparente.

## 8. Defensa técnica ante audiencia experta
El framework debe sostenerse frente a scrutiny real.

## 9. Reutilización
Siempre que se pueda, preferir skills, plantillas y componentes reutilizables.

## 10. Evolución gradual
El sistema se está construyendo iterativamente, no como un diseño cerrado de una sola vez.

---

# 20. Qué no debe olvidarse en futuros hilos

Si este proyecto se retoma en otra conversación, no deberían perderse estas ideas:

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
- y el sistema debe seguir evolucionando con coherencia, no con acumulación caótica de piezas.

---

# 21. Uso recomendado de esta memoria

Este documento debe utilizarse:
- como contexto de continuidad al abrir nuevos hilos;
- como recordatorio de decisiones de diseño no siempre visibles en un solo archivo operativo;
- y como complemento a la documentación formal del repositorio.

No sustituye a:
- `README.md`
- `DEMO_WORKFLOW_STANDARD.md`
- `PROJECT_TECHNICAL_REQUIREMENTS.md`

pero sí recoge:
- motivaciones;
- decisiones de diseño;
- sentido general;
- y contexto implícito que podría perderse si solo se leyera la estructura de carpetas.

---

# 22. Criterio de evolución futura

A futuro, cualquier cambio relevante debería intentar conservar este equilibrio:

- más capacidad,
- más requisitos,
- más trazabilidad,

sin caer en:
- prompts inasumibles,
- duplicación excesiva,
- o pérdida de claridad operativa.

La pregunta guía para futuros cambios debería ser:

**“¿Esto mejora la capacidad real del sistema sin romper su simplicidad, coherencia y trazabilidad?”**

Si la respuesta es no, el cambio debería revisarse.

---

# 23. Cierre

Esta memoria existe para que el proyecto pueda retomarse con un nivel alto de comprensión incluso si:
- se abre un nuevo hilo;
- no está presente toda la historia de decisiones;
- o algunas partes del repositorio aún no reflejan de manera totalmente explícita todo el razonamiento que llevó al diseño actual.

Su función es preservar:
- la visión;
- la intención;
- la metodología;
- y el sentido del sistema.


---

# 24. Capa Streamlit / app

La capa `app/` se introdujo como **cockpit visual** del sistema.

No sustituye a `control` ni a `workbench`.
Su papel es:
- visualizar el estado global y local;
- explorar artefactos;
- facilitar la operación manual o supervisada;
- y hacer la demo más comprensible y potente.

La fuente de verdad sigue estando en los markdowns y artefactos del caso.

# 25. Automatización control -> workbench

La evolución natural del framework es permitir que `control` invoque realmente a `workbench` mientras no aparezcan condiciones de parada humana.

El principio fijado es:
- el flujo puede continuar automáticamente mientras avance dentro del plan previsto;
- si hay replanificación, reapertura fuerte, contradicción o validación humana obligatoria, el flujo se detiene.

Esto no cambia la traza documental, solo añade capacidad de orquestación semi-autónoma.
