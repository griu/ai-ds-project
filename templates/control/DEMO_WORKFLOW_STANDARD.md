<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# DEMO_WORKFLOW_STANDARD.md

## Objetivo

Este documento define la dinámica estándar de trabajo de la demo para cualquier caso instanciado del framework.

La demo funciona con un único repositorio de caso, con dos áreas de trabajo separadas:

- `control/`
- `workbench/`

La interacción correcta es:

**persona → control → workbench → control → workbench → ...**

La persona no dirige directamente a `workbench`, salvo que `control` pida intervención humana por un bloqueo real o salvo que la persona quiera introducir observaciones humanas para que `control` las incorpore formalmente a la revisión.

---

## Documentos clave del framework en el caso

- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

El primero define la dinámica operativa.  
El segundo define los requisitos técnicos obligatorios del asistente.  
El tercero mantiene visible el estado global del flujo.  
El cuarto mantiene visible el estado local de ejecución de `workbench`, alineado con control.

Tanto `control` como `workbench` deben respetarlos.

---

## Estructura esperada del caso

```text
<CASE_REPO>/
├─ .git
├─ README.md
├─ control.code-workspace
├─ workbench.code-workspace
├─ control/
│  ├─ CLAUDE.md
│  ├─ DEMO_WORKFLOW_STANDARD.md
│  ├─ PROJECT_TECHNICAL_REQUIREMENTS.md
│  ├─ WORKFLOW_STATE.md
│  ├─ next_task.md
│  ├─ review_notes.md
│  ├─ project_context.md
│  ├─ jury_and_demo_goals.md
│  ├─ history/
│  ├─ .claude/
│  └─ .github/prompts/
└─ workbench/
   ├─ CLAUDE.md
   ├─ WORKBENCH_STATE.md
   ├─ task_result.md
   ├─ inputs/
   ├─ docs/
   ├─ src/
   ├─ notebooks/
   ├─ tests/
   ├─ history/
   └─ .claude/
```

---

## Regla de sincronización entre control y workbench

- `control/WORKFLOW_STATE.md` es la fuente de verdad del estado global.
- `workbench/WORKBENCH_STATE.md` es la traza local de ejecución de `workbench`.
- `workbench` debe tomar como punto de partida el diagrama de estados definido en `control`.
- `workbench` debe reflejar:
  - qué estados le han sido asignados o heredados;
  - cuáles ya ejecutó;
  - cuáles están pendientes, en curso o en revisión.
- `control` debe revisar la coherencia entre ambos documentos cuando cierre una iteración.
- Si se reabre un estado:
  - `control` lo marca en `control/WORKFLOW_STATE.md`;
  - `workbench` refleja esa reapertura en `workbench/WORKBENCH_STATE.md`.

---

## Regla operativa principal

Existen **5 prompts operativos**:

1. **Prompt inicial de `control`**
2. **Prompt recurrente de `workbench`**
3. **Prompt recurrente de `control`**
4. **Prompt de `control` para revisión humana y posible corrección**
5. **Prompt de `control` para reabrir o retomar el flujo desde un estado concreto**

---

## Regla ultracorta para no confundirse

- Si todavía no has empezado la demo → usa **Prompt inicial de `control`**
- Si el último archivo actualizado es `control/next_task.md` → usa **Prompt recurrente de `workbench`**
- Si el último archivo actualizado es `workbench/task_result.md` → usa **Prompt recurrente de `control`**
- Si quieres introducir observaciones humanas sobre un resultado ya producido por `workbench` → usa **Prompt de `control` para revisión humana y posible corrección**
- Si quieres retomar el flujo desde un estado concreto ya existente → usa **Prompt de `control` para reabrir o retomar el flujo**

---

## Procedimiento de creación del caso

El script acepta cuatro argumentos:

```
bash create_case_instance.sh <master_repo> <case_slug> [target_parent_dir] [target_repo_name]
```

- `<case_slug>`: define el overlay de inputs a aplicar (carpeta `demo/cases/<case_slug>/`).
- `[target_repo_name]`: nombre de la carpeta destino. Si no se informa, es igual a `<case_slug>`.

Esto permite instanciar el mismo caso con un nombre de carpeta diferente.

### Caso A — Nombre de destino igual al caso (comportamiento por defecto)

#### 1. Variables de trabajo

```bash
AI_DS_PROJECT_ROOT="/ruta/a/ai-ds-project"
CASE_SLUG="home-credit"
CASES_PARENT_DIR="$(dirname "$AI_DS_PROJECT_ROOT")"
CASE_REPO="$CASES_PARENT_DIR/$CASE_SLUG"
```

#### 2. Reinicio opcional

```bash
rm -rf "$CASE_REPO"
```

#### 3. Crear la instancia

Como hermano de `ai-ds-project`:

```bash
bash "$AI_DS_PROJECT_ROOT/demo/scripts/create_case_instance.sh"   "$AI_DS_PROJECT_ROOT"   "$CASE_SLUG"
```

O con ruta padre explícita:

```bash
bash "$AI_DS_PROJECT_ROOT/demo/scripts/create_case_instance.sh"   "$AI_DS_PROJECT_ROOT"   "$CASE_SLUG"   "$CASES_PARENT_DIR"
```

#### 4. Abrir los dos workspaces

```bash
code -n "$CASE_REPO/control.code-workspace"
code -n "$CASE_REPO/workbench.code-workspace"
```

---

### Caso B — Nombre de destino diferente al caso

Útil cuando quieres instanciar el mismo caso varias veces con nombres distintos.

#### 1. Variables de trabajo

```bash
AI_DS_PROJECT_ROOT="/ruta/a/ai-ds-project"
CASE_SLUG="home-credit"
TARGET_REPO_NAME="home-credit2"
CASES_PARENT_DIR="$(dirname "$AI_DS_PROJECT_ROOT")"
CASE_REPO="$CASES_PARENT_DIR/$TARGET_REPO_NAME"
```

#### 2. Reinicio opcional

```bash
rm -rf "$CASE_REPO"
```

#### 3. Crear la instancia

```bash
bash "$AI_DS_PROJECT_ROOT/demo/scripts/create_case_instance.sh" \
  "$AI_DS_PROJECT_ROOT" \
  "$CASE_SLUG" \
  "$CASES_PARENT_DIR" \
  "$TARGET_REPO_NAME"
```

El overlay aplicado será el de `home-credit`, pero la carpeta destino será `home-credit2`.

#### 4. Abrir los dos workspaces

```bash
code -n "$CASE_REPO/control.code-workspace"
code -n "$CASE_REPO/workbench.code-workspace"
```

---

## Regla de actualización de estados

### Estado global
`control` es responsable de mantener `control/WORKFLOW_STATE.md`.

Debe actualizarse:
- al finalizar cada revisión;
- antes de avanzar al siguiente ciclo de `workbench`;
- si se reabre un estado ya cerrado;
- y cuando cambie el orden lógico del plan.

### Estado local de workbench
`workbench` es responsable de mantener `workbench/WORKBENCH_STATE.md`.

Debe actualizarse:
- al iniciar una tarea;
- al cerrar una tarea;
- si se recibe una reapertura de estado;
- y cuando cambie el estado local de ejecución.

---

## Filosofía de prompts

Los prompts recurrentes deben ser ligeros.

La mayor parte de las reglas estables vive en:
- `control/CLAUDE.md`
- `workbench/CLAUDE.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`

Los prompts operativos deben limitarse a:
- activar el rol correcto;
- recordar qué artefactos revisar;
- y pedir la salida correspondiente.

---

## PROMPT 1 — Prompt inicial de `control`

```text
Lee `control/CLAUDE.md`, `control/project_context.md`, `control/jury_and_demo_goals.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md` y `workbench/WORKBENCH_STATE.md`.

Actúa como control plane del caso.

Debes:
- entender el contexto;
- decidir la primera tarea;
- escribir `control/next_task.md`;
- poner al día `control/WORKFLOW_STATE.md` antes de pasar a `workbench`.
```

---

## PROMPT 2 — Prompt recurrente de `workbench`

```text
Lee `workbench/CLAUDE.md`, `control/next_task.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md`, `workbench/WORKBENCH_STATE.md` y los artefactos relevantes del caso.

Ejecuta exactamente la tarea definida por `control`.

Debes:
- actualizar `workbench/task_result.md`;
- actualizar `workbench/WORKBENCH_STATE.md`;
- generar o actualizar los artefactos necesarios;
- guardar histórico en `workbench/history/`.
```

---

## PROMPT 3 — Prompt recurrente de `control`

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

---

## PROMPT 4 — Prompt de `control` para revisión humana y posible corrección

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

---

## PROMPT 5 — Prompt de `control` para reabrir o retomar el flujo desde un estado concreto

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

---

## Bucle estándar de trabajo

### Inicio
1. La persona abre `control.code-workspace`
2. Lanza **PROMPT 1**
3. `control` escribe `control/next_task.md`
4. `control` actualiza `control/WORKFLOW_STATE.md`

### Iteración normal
5. La persona pasa a `workbench.code-workspace`
6. Lanza **PROMPT 2**
7. `workbench` escribe `workbench/task_result.md`
8. `workbench` actualiza `workbench/WORKBENCH_STATE.md`

9. La persona vuelve a `control.code-workspace`
10. Lanza **PROMPT 3**
11. `control` revisa, comprueba coherencia de estados y actualiza `control/WORKFLOW_STATE.md`

### Variante con revisión humana
Si la persona quiere introducir observaciones humanas:
- vuelve a `control.code-workspace`
- lanza **PROMPT 4**
- `control` decide si corrige, reabre o cierra
- actualiza `control/WORKFLOW_STATE.md`

### Variante de reapertura desde un estado anterior
Si quieres retomar el flujo desde un estado ya cerrado o en revisión:
- vuelve a `control.code-workspace`
- lanza **PROMPT 5**
- `control` marca el estado correspondiente como `En revisión`
- genera nueva `control/next_task.md`
- se retoma el flujo normal:
  - `workbench`
  - luego `control`
  - etc.

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

Antes de sobrescribir, guardar copia numerada.

---

## Qué no hacer

- No hablar directamente con `workbench` para decidir el siguiente paso.
- No saltar fases por intuición humana.
- No ignorar `control/PROJECT_TECHNICAL_REQUIREMENTS.md`.
- No ignorar `control/WORKFLOW_STATE.md`.
- No ignorar `workbench/WORKBENCH_STATE.md`.
- No pasar a modelización si falta validación humana obligatoria.
- No aplicar observaciones humanas directamente sobre `workbench`.
