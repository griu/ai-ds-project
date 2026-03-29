# DEMO_WORKFLOW_STANDARD.md

## Objetivo

Este documento define la dinámica estándar de trabajo de la demo para cualquier caso instanciado del framework.

La demo funciona con un único repositorio de caso, con dos áreas de trabajo separadas:

- `control/`
- `workbench/`

La interacción correcta es:

**persona → control → workbench → control → workbench → ...**

La persona no dirige directamente a `workbench`, salvo que `control` pida intervención humana por un bloqueo real.

---

## Estructura esperada del caso

```text
/home/.../<case_slug>/
├─ .git
├─ README.md
├─ <case_slug>.code-workspace
├─ control/
│  ├─ CLAUDE.md
│  ├─ next_task.md
│  ├─ review_notes.md
│  ├─ project_context.md
│  ├─ jury_and_demo_goals.md
│  ├─ history/
│  ├─ .claude/
│  └─ .github/prompts/
└─ workbench/
   ├─ CLAUDE.md
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

## Regla operativa principal

Solo existen **3 prompts operativos**:

1. **Prompt inicial de `control`**
   - se usa una sola vez al arrancar la demo

2. **Prompt recurrente de `control`**
   - se usa cada vez que `workbench` ha terminado una tarea y ha actualizado `task_result.md`

3. **Prompt recurrente de `workbench`**
   - se usa cada vez que `control` ha actualizado `next_task.md`

---

## Regla ultracorta para no confundirse

- Si todavía no has empezado la demo → usa **Prompt inicial de `control`**
- Si el último archivo actualizado es `control/next_task.md` → usa **Prompt recurrente de `workbench`**
- Si el último archivo actualizado es `workbench/task_result.md` → usa **Prompt recurrente de `control`**

---

## Cuándo interviene la persona

La persona solo debe intervenir en estos casos:

- para arrancar la demo
- para lanzar el siguiente prompt al actor correcto
- si `control` pide aclaración de negocio o detecta un bloqueo real no resoluble
- si se decide reiniciar o cambiar de caso

En condiciones normales:

- `control` decide el siguiente paso
- `workbench` ejecuta
- la persona no redefine manualmente la tarea

---

## Procedimiento de creación del caso Home Credit

### 1. Crear la instancia del caso

Desde terminal:

```bash
bash ~/git/ai-ds-project/demo/scripts/create_case_instance.sh   ~/git/ai-ds-project   home-credit   ~/git
```

Resultado esperado:

```text
/home/griu/git/home-credit/
├─ .git
├─ README.md
├─ home-credit.code-workspace
├─ control/
└─ workbench/
```

### 2. Confirmar que el repo del caso es independiente

Opcionalmente:

```bash
git -C ~/git/home-credit remote -v
```

Si no aparece ningún remoto, el caso no está ligado a ningún repo remoto todavía.

### 3. Abrir las dos ventanas de VS Code

```bash
code -n ~/git/home-credit/control
code -n ~/git/home-credit/workbench
```

Si VS Code pregunta si quieres abrir el repositorio Git padre, responde **Yes**.

### 4. Cuándo sincronizar con remoto

La sincronización con remoto se hace **después** de crear la instancia y cuando quieras empezar a guardar progreso en GitHub o GitLab.

Si el remoto ya existe:

```bash
cd ~/git/home-credit
git remote add origin <URL_DEL_REPO>
git push -u origin main
```

Si usas GitHub CLI y quieres crear el repo remoto en ese momento:

```bash
cd ~/git/home-credit
gh repo create home-credit --private --source . --push
```

---

## PROMPT 1 — Prompt inicial de `control`

Usar **solo al comienzo de la demo**.

```text
Lee `project_context.md`, `jury_and_demo_goals.md`, `CLAUDE.md` y el prompt file `./.github/prompts/01_bootstrap_project.prompt.md`.

Tu función es actuar como control plane del caso.

Objetivo:
- revisar el contexto del caso,
- entender el nivel esperado de la demo,
- decidir la primera tarea que debe ejecutar `workbench`,
- redactar la primera versión operativa de `next_task.md`.

Reglas:
- la tarea debe ser pequeña, verificable y gobernada,
- no presupongas fases posteriores si el estado actual no lo justifica,
- no fuerces conectividad, pyproject.toml, .venv, EDA o modelización si la base del caso aún no está cerrada,
- decide el siguiente paso únicamente a partir de los artefactos actuales.

Escribe `next_task.md` en castellano con esta estructura:
- Título de tarea
- Objetivo
- Contexto
- Inputs a revisar
- Trabajo a realizar
- Outputs esperados
- Criterios de finalización
- Límites
```

---

## PROMPT 2 — Prompt recurrente de `control`

Usar **siempre que `workbench` haya terminado una tarea** y haya actualizado `../workbench/task_result.md`.

```text
Lee `../workbench/task_result.md`, `next_task.md`, `review_notes.md`, `CLAUDE.md` y el prompt file `./.github/prompts/02_review_task_result.prompt.md`.

Tu trabajo es:
1. revisar si la tarea anterior está cerrada o no,
2. actualizar `review_notes.md`,
3. decidir autónomamente cuál debe ser el siguiente paso,
4. redactar una nueva versión de `next_task.md` solo si corresponde avanzar o redefinir la tarea.

Reglas:
- no asumas por adelantado cuál debe ser la siguiente fase,
- decide el siguiente paso únicamente a partir del estado real del proyecto,
- no fuerces conectividad, entorno, EDA o modelización si la tarea previa no está realmente cerrada,
- solo pide intervención humana si detectas un bloqueo por falta de información crítica que no pueda resolverse con los artefactos actuales.

Además:
- antes de dejar cerrada la revisión, guarda una copia histórica numerada de `review_notes.md` en `history/`
- antes de dejar cerrada la revisión, guarda una copia histórica numerada de `next_task.md` en `history/`
- usa numeración correlativa de tres dígitos: `001`, `002`, `003`, ...
- deja como versión viva en la raíz de `control/` únicamente:
  - `next_task.md`
  - `review_notes.md`

Nombres esperados de histórico:
- `history/001_review_notes.md`
- `history/001_next_task.md`
- `history/002_review_notes.md`
- `history/002_next_task.md`
- etc.

La salida debe dejar claro:
- estado de la tarea anterior: finalizada / parcialmente finalizada / no finalizada
- justificación de ese estado
- decisión sobre el siguiente paso
- nueva `next_task.md`, si aplica
```

---

## PROMPT 3 — Prompt recurrente de `workbench`

Usar **siempre que `control` haya actualizado `../control/next_task.md`**.

```text
Lee `../control/next_task.md`, `task_result.md`, `CLAUDE.md` y revisa todos los artefactos relevantes del área `workbench/`.

Tu objetivo es ejecutar exactamente la tarea definida por el control plane.

Antes de empezar:
- valida qué inputs y artefactos existen realmente,
- identifica si falta información crítica,
- no cambies por tu cuenta el alcance de la tarea.

Debes:
- ejecutar la tarea pedida,
- generar o actualizar los artefactos necesarios,
- documentar de forma explícita lo realizado,
- actualizar `task_result.md`.

Al finalizar, `task_result.md` debe dejar claro:
- objetivo de la tarea
- trabajo realizado
- artefactos generados
- validaciones ejecutadas
- incidencias encontradas
- trabajo no completado
- evaluación final: finalizada / parcialmente finalizada / no finalizada
- recomendación para el siguiente paso

Reglas:
- no avances por tu cuenta a una fase posterior,
- no redefinas el objetivo de la tarea,
- si falta información crítica, repórtalo explícitamente,
- si la tarea incluye documentación, no inventes datos no respaldados por los inputs.

Además:
- antes de dejar cerrada la tarea, guarda una copia histórica numerada de `task_result.md` en `history/`
- usa numeración correlativa de tres dígitos: `001`, `002`, `003`, ...
- deja como versión viva en la raíz de `workbench/` únicamente `task_result.md`

Nombres esperados de histórico:
- `history/001_task_result.md`
- `history/002_task_result.md`
- `history/003_task_result.md`
- etc.
```

---

## Bucle estándar de trabajo

### Inicio
1. La persona abre `control/`
2. Lanza **PROMPT 1 — Prompt inicial de `control`**
3. `control` escribe `next_task.md`

### Ejecución
4. La persona pasa a `workbench/`
5. Lanza **PROMPT 3 — Prompt recurrente de `workbench`**
6. `workbench` escribe `task_result.md`

### Revisión
7. La persona vuelve a `control/`
8. Lanza **PROMPT 2 — Prompt recurrente de `control`**
9. `control` revisa y decide

### Repetición
10. Si `control` ha actualizado `next_task.md`, la persona vuelve a `workbench/`
11. Repite el ciclo:
    - `control` decide
    - `workbench` ejecuta
    - `control` revisa

---

## Cómo saber qué prompt toca en cada momento

### Caso A — Acabas de crear la instancia y aún no has empezado
Usa:
- **PROMPT 1 — Prompt inicial de `control`**

### Caso B — `control` acaba de actualizar `next_task.md`
Usa:
- **PROMPT 3 — Prompt recurrente de `workbench`**

### Caso C — `workbench` acaba de actualizar `task_result.md`
Usa:
- **PROMPT 2 — Prompt recurrente de `control`**

---

## Histórico de trabajo

Para mantener trazabilidad visible durante la demo, el sistema conserva:

### Versiones vivas

En `control/`:
- `next_task.md`
- `review_notes.md`

En `workbench/`:
- `task_result.md`

Estas son siempre las versiones activas más recientes.

### Versiones históricas

Además, antes de sobrescribir las versiones vivas, se debe guardar una copia numerada en `history/`.

Estructura esperada:

```text
control/
├─ next_task.md
├─ review_notes.md
└─ history/
   ├─ 001_next_task.md
   ├─ 001_review_notes.md
   ├─ 002_next_task.md
   ├─ 002_review_notes.md
   └─ ...

workbench/
├─ task_result.md
└─ history/
   ├─ 001_task_result.md
   ├─ 002_task_result.md
   └─ ...
```

### Regla de numeración

Usar numeración correlativa de tres dígitos:
- `001`
- `002`
- `003`
- ...

### Regla de cierre de iteración

#### Cuando actúa `control`
Antes de dejar cerrada la revisión, debe:
1. actualizar `review_notes.md`
2. actualizar `next_task.md` si corresponde
3. guardar una copia histórica numerada en `control/history/` de:
   - `review_notes.md`
   - `next_task.md`

#### Cuando actúa `workbench`
Antes de dejar cerrada la tarea, debe:
1. actualizar `task_result.md`
2. guardar una copia histórica numerada en `workbench/history/` de `task_result.md`

### Objetivo del histórico

El histórico permite:
- trazabilidad explícita durante la demo
- revisar cómo evolucionan las decisiones
- mostrar gobernanza sin depender solo de Git

---

## Qué no hacer

- No hablar directamente con `workbench` para decidir el siguiente paso
- No saltar fases por intuición humana
- No pedir a `workbench` que improvise la tarea
- No forzar conectividad, pyproject.toml, .venv, EDA o modelización antes de que `control` lo decida
- No pedir intervención externa si `control` no ha declarado bloqueo real

---

## Resumen ultracorto

- Primera vez → **PROMPT 1 (control inicial)**
- Si `control/next_task.md` es lo último actualizado → **PROMPT 3 (workbench)**
- Si `workbench/task_result.md` es lo último actualizado → **PROMPT 2 (control recurrente)**
- Antes de sobrescribir, guardar copia en `history/`

Ese es todo el flujo de la demo.
