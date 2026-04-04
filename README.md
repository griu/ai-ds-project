<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# ai-ds-project

Repositorio maestro del framework de demo para proyectos de Data Science gobernados con VS Code + Claude.

## Qué contiene
- `templates/control/`: plantilla del área de gobierno del proyecto.
- `templates/workbench/`: plantilla del área de ejecución del proyecto.
- `templates/app/`: plantilla de la app Streamlit de monitorización y guía operativa.
- `demo/cases/<slug>/control/`: overlays del caso para `control/`.
- `demo/cases/<slug>/workbench/`: overlays del caso para `workbench/`.
- `demo/scripts/`: scripts para instanciar un proyecto nuevo y publicarlo.
- `docs/PROJECT_CONTINUITY_MEMORY.md`: memoria amplia de contexto, visión y criterios de evolución del proyecto.
- `docs/STREAMLIT_APP_INTEGRATION_NOTES.md`: notas de integración de la app Streamlit.

## Modelo operativo
Este repo **no es** el proyecto activo del caso.

Sirve como:
- plantilla viva del método;
- repositorio donde evolucionan prompts, skills, agentes y documentación base;
- fuente para crear nuevos proyectos instanciados;
- base de continuidad contextual para abrir nuevos hilos de trabajo sin perder visión.

## Qué se crea por cada caso
Cada caso se instancia como **un único repo nuevo fuera de este repo maestro**.

Dentro del caso instanciado quedan tres piezas:
- `control/`
- `workbench/`
- `app/`

Y además se generan tres workspaces en la raíz del caso:
- `control.code-workspace`
- `workbench.code-workspace`
- `app.code-workspace`

Los tres workspaces abren **la misma raíz del proyecto del caso**.

## Papel de cada pieza
### `control/`
Gobierna el proyecto desde VS Code.  
Define la tarea, revisa el resultado, actualiza estados y, cuando procede, vuelve a invocar a `workbench` como subagente dentro del mismo ciclo de conversación.

### `workbench/`
Ejecuta la tarea técnica definida por `control`.  
No redefine el plan por su cuenta. Produce artefactos, actualiza su estado local y devuelve el resultado de la tarea actual.

### `app/`
La app Streamlit actúa como **cockpit de monitorización y guía**:
- muestra el estado global y local;
- ayuda a leer la traza del proyecto;
- orienta sobre siguientes pasos y prompts;
- pero **no es el motor principal de ejecución** del bucle autónomo.

## Documentos estables de gobierno y seguimiento
En cada caso instanciado:
- `control/WORKFLOW_STATE.md` es la fuente de verdad del estado global;
- `workbench/WORKBENCH_STATE.md` refleja el estado local de ejecución alineado con control;
- `control/AUTOMATION_POLICY.md` define la política de avance autónomo desde `control`.

## Filosofía de prompts
Los prompts recurrentes deben ser:
- cortos;
- ligeros;
- mantenibles.

Las reglas estables deben vivir preferentemente en:
- `control/CLAUDE.md`
- `workbench/CLAUDE.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/AUTOMATION_POLICY.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

## Prompt de arranque para generar un nuevo caso en `demo/cases`
Usa este prompt cuando quieras que el asistente convierta documentación de entrada en una nueva estructura de caso bajo `demo/cases/<case_slug>/`.

### Preparación mínima recomendada
Prepara una carpeta de entrada con:
- la lista de documentos disponibles;
- el detalle explicativo de qué es cada documento y para qué sirve;
- requisitos adicionales del caso;
- y, si existe, una propuesta inicial de nombre o `slug` del caso.

### Prompt completo
```text
Quiero crear un nuevo caso dentro de `demo/cases` de `ai-ds-project`.

Tu misión es analizar la documentación de entrada, traducirla a especificaciones accionables y generar la base necesaria para un nuevo caso en:

`demo/cases/<case_slug>/`

Debes trabajar apoyándote explícitamente en los contextos ya existentes del repositorio, en especial:
- `README.md`
- `docs/PROJECT_CONTINUITY_MEMORY.md`
- `templates/control/DEMO_WORKFLOW_STANDARD.md`
- `templates/control/AUTOMATION_POLICY.md`
- `templates/control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `templates/control/WORKFLOW_STATE.md`
- `templates/control/CLAUDE.md`
- `templates/workbench/CLAUDE.md`
- `templates/app/README.md`
- `templates/control/README.md`
- `templates/workbench/README.md`
- `demo/DEMO_HACKATHON_PLAYBOOK.md`
- la estructura actual de `templates/control`
- la estructura actual de `templates/workbench`
- la estructura actual de `templates/app`
- y los casos ya existentes en `demo/cases`, si sirven como referencia reusable.

### Inputs del encargo
La carpeta que contiene la documentación de entrada es:

[INDICA AQUÍ LA RUTA DE LA CARPETA]

Además, estos son los requisitos adicionales del nuevo caso:

[PEGA AQUÍ LOS REQUISITOS ADICIONALES]

Y este es el detalle explicativo de cada documento o grupo de documentos, si no está ya suficientemente claro en la carpeta:

[PEGA AQUÍ LA EXPLICACIÓN DE CADA DOCUMENTO]

### Objetivo
A partir de estos materiales, debes:
1. interpretar la documentación de entrada;
2. identificar el tipo de problema de negocio y de modelización;
3. traducirlo a especificaciones coherentes con la arquitectura de `ai-ds-project`;
4. proponer y preparar la estructura del nuevo caso en `demo/cases/<case_slug>/control` y `demo/cases/<case_slug>/workbench`;
5. reutilizar patrones, convenciones, prompts, skills y comportamientos ya definidos en el repositorio;
6. adaptar el caso al esquema general de trabajo de forma consistente;
7. minimizar duplicidades y mantener la coherencia con la metodología existente.

### Lo que debes producir
Debes generar, como mínimo:

#### En `demo/cases/<case_slug>/control/`
- `project_context.md`
- `jury_and_demo_goals.md`
- y cualquier overlay adicional de control estrictamente necesario para el caso

#### En `demo/cases/<case_slug>/workbench/`
- materiales de entrada estructurados en:
  - `inputs/business_docs/`
  - `inputs/technical_docs/`
  - `inputs/dictionaries/`
  - `inputs/data_samples/`
- y cualquier overlay adicional de workbench estrictamente necesario para arrancar el flujo

### Reglas de comportamiento
- No inventes información específica del caso si no está sustentada por la documentación.
- Si faltan piezas relevantes para definir correctamente el caso, debes detectarlo.
- Si encuentras ambigüedades, contradicciones o vacíos respecto al esquema actual de modelización, debes parar antes de generar la estructura final.
- En ese caso, formula preguntas explícitas y concretas al usuario sobre los puntos faltantes.
- No generes la estructura definitiva hasta que esos puntos críticos estén aclarados o el usuario te indique que avances con supuestos explícitos.

### Formato de salida esperado
Tu respuesta debe venir en este orden:
1. `Resumen del caso`
2. `Supuestos o puntos confirmados`
3. `Lagunas, ambigüedades o contradicciones detectadas`
4. `Preguntas necesarias antes de generar el caso` (si aplican)
5. `Propuesta de estructura del nuevo caso`
6. `Artefactos concretos a crear o actualizar`
7. `Observaciones de coherencia con el framework`
```

## Cuándo usar este prompt
Úsalo cuando:
- llegue nueva documentación de un caso;
- quieras convertir un briefing disperso en un nuevo `demo/cases/<slug>/`;
- quieras crear un caso reusable y bien alineado con la arquitectura del repositorio.

## Recomendación operativa
Antes de ejecutar este prompt, conviene revisar también:
- `docs/PROJECT_CONTINUITY_MEMORY.md`
- `templates/control/AUTOMATION_POLICY.md`

para asegurar que el nuevo caso quede alineado no solo con la estructura técnica actual, sino también con la visión, los criterios y el sentido general del proyecto.

## Licencia
ai-ds-project se distribuye bajo **LGPL-3.0-or-later**.
