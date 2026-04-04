<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# DEMO_WORKFLOW_STANDARD.md

## Objetivo
Este documento define la dinámica estándar de trabajo de la demo para cualquier caso instanciado del framework.

La demo funciona con un único repositorio de caso, con tres piezas separadas:
- `control/`
- `workbench/`
- `app/`

La interacción principal correcta es:

**persona → chat de control en VS Code**

y, dentro de ese chat:

**control → subagente workbench → control → subagente workbench → ...**

La persona solo debe intervenir:
- al inicio;
- cuando `control` se detiene por una condición prevista;
- o cuando quiere introducir observaciones humanas explícitas.

---

## Documentos clave del framework en el caso
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/AUTOMATION_POLICY.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

Tanto `control` como `workbench` deben respetarlos.

---

## Papel de la app Streamlit
`app/` es un **cockpit de monitorización y guía**.

Sirve para:
- visualizar el estado global y local;
- inspeccionar la traza;
- orientar sobre prompts y siguientes pasos;
- ayudar a entender el flujo.

No es, por ahora, el motor principal de ejecución autónoma.

---

## Estructura esperada del caso
```text
<CASE_REPO>/
├─ .git
├─ README.md
├─ control.code-workspace
├─ workbench.code-workspace
├─ app.code-workspace
├─ control/
│  ├─ CLAUDE.md
│  ├─ DEMO_WORKFLOW_STANDARD.md
│  ├─ AUTOMATION_POLICY.md
│  ├─ PROJECT_TECHNICAL_REQUIREMENTS.md
│  ├─ WORKFLOW_STATE.md
│  ├─ next_task.md
│  ├─ review_notes.md
│  ├─ project_context.md
│  ├─ jury_and_demo_goals.md
│  ├─ history/
│  ├─ .claude/
│  └─ .github/prompts/
├─ workbench/
│  ├─ CLAUDE.md
│  ├─ WORKBENCH_STATE.md
│  ├─ task_result.md
│  ├─ inputs/
│  ├─ docs/
│  ├─ src/
│  ├─ notebooks/
│  ├─ tests/
│  ├─ history/
│  └─ .claude/
└─ app/
   ├─ app.py
   ├─ case_config.json
   ├─ README.md
   ├─ requirements.txt
   ├─ run_streamlit.sh
   └─ lib/
```

---

## Procedimiento de creación del caso

El script acepta cuatro argumentos:

```bash
bash create_case_instance.sh <master_repo> <case_slug> [target_parent_dir] [target_repo_name]
```

- `<case_slug>`: define el overlay de inputs a aplicar.
- `[target_repo_name]`: nombre de la carpeta destino. Si no se informa, es igual a `<case_slug>`.

### Variables de trabajo
```bash
AI_DS_PROJECT_ROOT="/ruta/a/ai-ds-project"
CASE_SLUG="home-credit"
CASES_PARENT_DIR="$(dirname "$AI_DS_PROJECT_ROOT")"
CASE_REPO_NAME="home-credit"
CASE_REPO="$CASES_PARENT_DIR/$CASE_REPO_NAME"
```

### Reinicio opcional
```bash
rm -rf "$CASE_REPO"
```

### Crear la instancia
```bash
bash "$AI_DS_PROJECT_ROOT/demo/scripts/create_case_instance.sh"   "$AI_DS_PROJECT_ROOT"   "$CASE_SLUG"   "$CASES_PARENT_DIR"   "$CASE_REPO_NAME"
```

### Abrir los workspaces
```bash
code -n "$CASE_REPO/control.code-workspace"
code -n "$CASE_REPO/workbench.code-workspace"
code -n "$CASE_REPO/app.code-workspace"
```

---

## Regla de sincronización entre control y workbench
- `control/WORKFLOW_STATE.md` es la fuente de verdad del estado global.
- `workbench/WORKBENCH_STATE.md` es la traza local de ejecución de `workbench`.
- `workbench` debe tomar como punto de partida el diagrama de estados definido en `control`.
- `control` debe revisar la coherencia entre ambos documentos al cierre de cada iteración.

---

## Prompt principal del sistema
El prompt principal de trabajo recurrente es el **prompt autónomo de `control`**.

Ese prompt debe:
1. leer estado y artefactos;
2. decidir si existe una tarea activa válida;
3. redactar o limpiar `control/next_task.md` si hace falta;
4. invocar a `workbench` como subagente;
5. revisar `workbench/task_result.md`;
6. actualizar `control/review_notes.md`;
7. actualizar `control/WORKFLOW_STATE.md`;
8. decidir si continúa o se detiene.

---

## Lista de prompts operativos
1. **Prompt inicial de `control`**
2. **Prompt autónomo de orquestación de `control`**
3. **Prompt manual de `workbench`** para ejecución puntual, depuración o fallback
4. **Prompt de `control` para revisión humana y posible corrección**
5. **Prompt de `control` para reabrir o retomar el flujo desde un estado concreto**

---

## Regla ultracorta para no confundirse
- Si todavía no has empezado la demo → usa el **Prompt inicial de `control`**
- Si quieres operar el flujo normal → usa el **Prompt autónomo de `control`**
- Si necesitas ejecutar `workbench` manualmente por excepción → usa el **Prompt manual de `workbench`**
- Si quieres introducir observaciones humanas → usa el **Prompt de revisión humana de `control`**
- Si quieres reabrir un estado ya cerrado → usa el **Prompt de reapertura de `control`**

---

## PROMPT 1 — Prompt inicial de `control`
```text
Lee `control/CLAUDE.md`, `control/DEMO_WORKFLOW_STANDARD.md`, `control/AUTOMATION_POLICY.md`, `control/project_context.md`, `control/jury_and_demo_goals.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md` y `workbench/WORKBENCH_STATE.md`.

Actúa como control plane del caso.

Debes:
- entender el contexto;
- decidir la primera tarea;
- escribir `control/next_task.md`;
- actualizar `control/WORKFLOW_STATE.md`;
- y dejar el caso listo para que el prompt autónomo de `control` continúe el flujo.
```

---

## PROMPT 2 — Prompt autónomo de orquestación de `control`
```text
Lee y usa como contexto estable:

- `control/CLAUDE.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/AUTOMATION_POLICY.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`
- `control/review_notes.md`
- `control/next_task.md` si existe
- `workbench/task_result.md` si existe

Actúa como orquestador del proyecto desde `control`.

Tu función no es solo revisar, sino gobernar iteraciones autónomas entre `control` y el subagente `workbench`.

## Objetivo
Avanzar el proyecto de forma autónoma mientras:
- no haya replanificación,
- no haya reapertura de fases previas,
- no aparezcan tareas nuevas no previstas,
- no se requiera validación humana obligatoria,
- no haya bloqueo técnico,
- y no se supere el límite de 10 iteraciones automáticas consecutivas.

## Instrucciones
1. Revisa el estado actual del proyecto.
2. Determina si existe una tarea activa válida en `control/next_task.md`.
3. Si no existe o no es válida, redacta una nueva `control/next_task.md` limpia y accionable.
4. Invoca al subagente `workbench` para ejecutar exactamente la tarea activa.
5. Revisa:
   - `workbench/task_result.md`
   - `workbench/WORKBENCH_STATE.md`
6. Actualiza:
   - `control/review_notes.md`
   - `control/WORKFLOW_STATE.md`
7. Evalúa si el flujo puede continuar automáticamente.

## Regla de limpieza documental
- `control/next_task.md` debe contener solo la tarea activa vigente.
- `workbench/task_result.md` debe contener solo el resultado de la tarea actual o de la última ejecución cerrada.

## Modo de salida
Mientras puedas continuar, sigue ejecutando iteraciones de forma autónoma con `workbench`.
Cuando debas detenerte, responde con:
1. motivo exacto de parada,
2. estado alcanzado,
3. qué decisión o input necesitas de la persona,
4. y deja todos los artefactos actualizados antes de parar.
```

---

## PROMPT 3 — Prompt manual de `workbench`
```text
Lee `workbench/CLAUDE.md`, `control/next_task.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md` y los artefactos relevantes del caso.

Actúa como workbench del caso.

Debes:
- ejecutar exactamente la tarea definida por `control`;
- actualizar `workbench/task_result.md`;
- actualizar `workbench/WORKBENCH_STATE.md`;
- dejar señales claras de continuación o parada;
- y no modificar `control/WORKFLOW_STATE.md`.
```

---

## PROMPT 4 — Prompt de `control` para revisión humana y posible corrección
```text
Lee `control/CLAUDE.md`, `control/DEMO_WORKFLOW_STANDARD.md`, `control/AUTOMATION_POLICY.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md`, `control/next_task.md`, `control/review_notes.md` y `workbench/task_result.md`.

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

---

## PROMPT 5 — Prompt de `control` para reabrir o retomar el flujo desde un estado concreto
```text
Lee `control/CLAUDE.md`, `control/DEMO_WORKFLOW_STANDARD.md`, `control/AUTOMATION_POLICY.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md`, `control/review_notes.md`, `control/next_task.md` y, si aplica, `workbench/task_result.md`.

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
- detener la continuación automática;
- y dejar el flujo listo para reanudarse cuando corresponda.
```

---

## Bucle estándar de trabajo
### Inicio
1. La persona abre `control.code-workspace`
2. Lanza **PROMPT 1**
3. `control` deja lista la primera tarea

### Flujo normal
4. La persona permanece en el chat de `control`
5. Lanza **PROMPT 2**
6. `control` orquesta iteraciones autónomas con `workbench`
7. El flujo continúa hasta que se cumple una condición de parada

### Revisión humana
Si la persona quiere introducir observaciones:
- usa **PROMPT 4**

### Reapertura
Si se quiere volver atrás:
- usa **PROMPT 5**

---

## Histórico de trabajo
Mantener:
- versiones vivas:
  - `control/next_task.md`
  - `control/review_notes.md`
  - `control/WORKFLOW_STATE.md`
  - `workbench/task_result.md`
  - `workbench/WORKBENCH_STATE.md`
- versiones históricas:
  - `control/history/...`
  - `workbench/history/...`

---

## Qué no hacer
- No usar Streamlit como motor principal de ejecución.
- No saltar fases por intuición humana.
- No ignorar `control/AUTOMATION_POLICY.md`.
- No ignorar `control/PROJECT_TECHNICAL_REQUIREMENTS.md`.
- No ignorar `control/WORKFLOW_STATE.md`.
- No ignorar `workbench/WORKBENCH_STATE.md`.
- No pasar a modelización si falta validación humana obligatoria.
- No acumular tareas antiguas en `control/next_task.md`.
- No acumular resultados antiguos en `workbench/task_result.md`.
