# Dinámica estándar de trabajo para la demo `control` ↔ `workbench`

## Propósito de este documento

Este documento define la forma **estándar, simple y repetible** de trabajar con la demo.

La idea es que:

- `ai-ds-project` actúe como **repo maestro / plantilla viva**.
- cada caso instanciado, por ejemplo `home-credit`, sea **un repo independiente**.
- dentro de cada caso existan dos áreas:
  - `control/`
  - `workbench/`
- la interacción humana se haga **preferentemente con `control/`**.
- `workbench/` ejecute tareas.
- `control/` revise resultados y decida el siguiente paso.
- ni el usuario ni el asistente externo impongan manualmente la siguiente fase salvo que `control/` lo pida explícitamente.

---

# 1. Dónde guardar este documento

## En el repo maestro
Guardar este archivo en una ruta como:

```text
ai-ds-project/docs/DEMO_WORKFLOW_STANDARD.md
```

## En los casos instanciados
Copiar este archivo en:

```text
/home/griu/git/home-credit/control/DEMO_WORKFLOW_STANDARD.md
```

y equivalentes para otros casos.

El objetivo es que el área `control/` tenga visible la dinámica de trabajo desde el primer momento.

---

# 2. Modelo operativo correcto

## Repo maestro

```text
/home/griu/git/ai-ds-project
```

Es el repositorio donde evolucionan:
- plantillas
- prompts
- skills
- estructura base
- documentación del framework
- scripts de instanciación

## Repo instanciado por caso

Ejemplo:

```text
/home/griu/git/home-credit
```

Dentro del repo del caso:

```text
/home/griu/git/home-credit/
├─ control/
└─ workbench/
```

## Regla clave

- `control/` **define y revisa**
- `workbench/` **ejecuta y reporta**

Pero ambos cuelgan del **mismo repo Git del caso**.

---

# 3. Flujo estándar de trabajo

## Secuencia general

1. `control/` genera o redefine `next_task.md`
2. `workbench/` lee `../control/next_task.md`
3. `workbench/` ejecuta la tarea
4. `workbench/` actualiza `task_result.md`
5. `control/` lee `../workbench/task_result.md`
6. `control/` decide autónomamente si:
   - la tarea se cierra,
   - se redefine,
   - o se abre una nueva fase.

## Regla de autonomía

La siguiente fase **no debe ser impuesta manualmente** por el usuario ni por un asistente externo.

El siguiente paso debe decidirlo `control/` a partir del estado real del proyecto.

## Regla de intervención humana

La intervención humana solo debe producirse cuando:
- `control/` pida una aclaración,
- falten datos críticos,
- haya una ambigüedad de negocio no resoluble con los artefactos existentes,
- o se quiera modificar conscientemente la gobernanza del método.

---

# 4. Reinicio de la demo desde cero

Estas instrucciones sirven para recomenzar el caso `home-credit` desde cero.

## 4.1. Reemplazar primero en `ai-ds-project` los ficheros corregidos

Antes de reiniciar, asegúrate de que en el repo maestro ya están actualizados al menos estos elementos:

- `templates/control/...`
- `templates/workbench/...`
- `demo/cases/home-credit/control/...`
- `demo/cases/home-credit/workbench/...`
- `demo/scripts/create_case_instance.sh`

## 4.2. Borrar la instancia antigua del caso

```bash
rm -rf ~/git/home-credit
```

## 4.3. Crear de nuevo la instancia del caso

```bash
bash ~/git/ai-ds-project/demo/scripts/create_case_instance.sh \
  ~/git/ai-ds-project \
  home-credit \
  ~/git
```

## 4.4. Resultado esperado

Debe crearse:

```text
/home/griu/git/home-credit/
├─ .git
├─ README.md
├─ .gitignore
├─ home-credit.code-workspace
├─ control/
└─ workbench/
```

## 4.5. Confirmación opcional

```bash
git -C ~/git/home-credit rev-parse --show-toplevel
```

Debe devolver:

```text
/home/griu/git/home-credit
```

---

# 5. Sincronización con Git remoto

## Cuándo hacerlo

La sincronización con remoto se hace **después** de crear la instancia local.

## Si el remoto ya existe

```bash
cd ~/git/home-credit
git remote add origin <URL_DEL_REPO>
git push -u origin main
```

## Si quieres crear el remoto con GitHub CLI

```bash
cd ~/git/home-credit
gh repo create home-credit --private --source . --push
```

## Comprobación

```bash
git -C ~/git/home-credit remote -v
```

Si no aparece nada, el repo local todavía no está conectado a ningún remoto.

---

# 6. Cómo abrir el caso en VS Code

## Opción recomendada para la demo: dos ventanas

```bash
code -n ~/git/home-credit/control
code -n ~/git/home-credit/workbench
```

## Si VS Code detecta un repo Git en una carpeta padre

Es normal.

Debes aceptar la detección del repo padre porque:
- `control/` y `workbench/` cuelgan del repo Git del caso,
- el `.git` está en `/home/griu/git/home-credit/.git`.

Si aparece el aviso de VS Code, responde:

- **Yes**

---

# 7. Regla operativa clave para `control`

`control/` debe actuar como orquestador autónomo.

## Qué sí hace `control`

- lee `../workbench/task_result.md`
- evalúa el estado real del proyecto
- actualiza `review_notes.md`
- decide si la tarea está:
  - finalizada
  - parcialmente finalizada
  - no finalizada
- define o redefine `next_task.md`

## Qué no debe hacer `control`

- no debe asumir por adelantado cuál es la siguiente fase
- no debe forzar conectividad, entorno, EDA o modelización si la fase previa no está cerrada
- no debe obedecer una secuencia fija si el estado real del proyecto indica otra cosa

---

# 8. Regla operativa clave para `workbench`

`workbench/` debe ejecutar la tarea definida por `control/`.

## Qué sí hace `workbench`

- lee `../control/next_task.md`
- inspecciona `inputs/`
- ejecuta la tarea pedida
- genera o actualiza artefactos en `docs/`, `src/`, `notebooks/`, etc.
- actualiza `task_result.md`

## Qué no debe hacer `workbench`

- no debe cambiar el alcance por su cuenta
- no debe avanzar a una fase posterior sin que `control/` la haya abierto
- no debe inventar información que no esté respaldada por inputs o artefactos previos

---

# 9. Prompt de inicialización para `control`

Este prompt sirve para arrancar la demo desde cero en el área `control/`.

Usarlo en la ventana de VS Code abierta sobre:

```text
~/git/home-credit/control
```

## Prompt

```text
Lee `project_context.md`, `jury_and_demo_goals.md`, `CLAUDE.md` y el prompt file `./.github/prompts/01_bootstrap_project.prompt.md`.

Tu trabajo es iniciar el caso de forma gobernada.

Debes:
1. entender el caso y los objetivos de la demo,
2. revisar qué debería pedir a `workbench/` como primera tarea,
3. redactar una primera versión operativa de `next_task.md`.

Reglas:
- la primera tarea debe ser pequeña, clara y verificable,
- debe apoyarse en los materiales existentes en `../workbench/inputs/`,
- no debes asumir por adelantado cuál será la segunda fase,
- no abras conectividad, entorno, EDA o modelización si antes no está consolidada la base documental.

Escribe `next_task.md` en castellano.
```

---

# 10. Prompt estándar de ejecución para `workbench`

Este prompt se usa después de que `control/` haya dejado lista una nueva versión de `next_task.md`.

Usarlo en la ventana de VS Code abierta sobre:

```text
~/git/home-credit/workbench
```

## Prompt

```text
Lee `../control/next_task.md`, `CLAUDE.md` y revisa todo el contenido disponible en `inputs/`.

Tu objetivo es ejecutar la tarea definida por el control plane.

Antes de empezar:
- valida qué inputs existen realmente,
- identifica si falta información crítica,
- no cambies el alcance de la tarea por tu cuenta.

Durante la ejecución:
- crea o actualiza los artefactos necesarios,
- documenta hallazgos, lagunas y restricciones,
- no avances a fases posteriores sin autorización explícita del control plane.

Al finalizar:
- actualiza `task_result.md`,
- indica qué has hecho,
- qué artefactos has generado,
- qué dudas o lagunas quedan,
- y si la tarea está finalizada, parcialmente finalizada o no finalizada.
```

---

# 11. Prompt estándar de revisión para `control`

Este prompt se usa después de que `workbench/` haya actualizado `task_result.md`.

## Prompt

```text
Lee `../workbench/task_result.md`, `next_task.md`, `CLAUDE.md` y el prompt file `./.github/prompts/02_review_task_result.prompt.md`.

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
```

---

# 12. Prompt estándar de trabajo recursivo `control` ↔ `workbench`

Este es el patrón estable que debe repetirse durante toda la demo.

## Bucle operativo

### Paso A — `control`
- revisa el estado
- decide el siguiente paso
- actualiza `next_task.md`

### Paso B — `workbench`
- lee `../control/next_task.md`
- ejecuta la tarea
- actualiza `task_result.md`

### Paso C — `control`
- lee `../workbench/task_result.md`
- decide si:
  - cerrar tarea,
  - redefinirla,
  - o abrir una nueva fase

## Prompt compacto para repetir el bucle

### En `control`

```text
Revisa `../workbench/task_result.md`, `next_task.md`, `review_notes.md` y el marco del repositorio.
Decide autónomamente si la tarea anterior está cerrada.
Actualiza `review_notes.md` y redefine `next_task.md` solo si corresponde.
No presupongas la siguiente fase: decide a partir del estado real del proyecto.
```

### En `workbench`

```text
Lee `../control/next_task.md`, `task_result.md` y el marco del repositorio.
Ejecuta la tarea exactamente en el alcance definido.
Actualiza `task_result.md` con trabajo realizado, artefactos generados, lagunas y estado final.
No avances a fases posteriores sin autorización explícita de `control`.
```

---

# 13. Señales de que la demo está funcionando bien

La demo va bien si ocurre esto:

- `control/` no salta fases por inercia
- `workbench/` no inventa ni sobre-extiende el trabajo
- aparecen bloqueos reales cuando faltan datos importantes
- `control/` pide completar información antes de avanzar cuando corresponde
- cada tarea queda escrita de forma pequeña y verificable
- el trabajo avanza por fases, no por improvisación

---

# 14. Qué hacer si `control` pide intervención humana

Solo intervenir si `control/` deja claro en `review_notes.md` o `next_task.md` que hay un bloqueo no resoluble con los artefactos actuales.

Ejemplos:
- falta variable objetivo exacta
- falta métrica oficial del hackathon
- faltan join keys
- faltan URLs, nombres de ficheros o fuentes reales
- hay una ambigüedad de negocio no resoluble

En ese caso, la intervención humana debe consistir en:
- aportar la información faltante,
- actualizar inputs,
- y volver a dejar que `control/` decida el siguiente paso.

---

# 15. Resumen ejecutivo de la dinámica

## Repo maestro
`ai-ds-project`
- mantiene el método
- mantiene plantillas, prompts, skills y scripts

## Repo del caso
`home-credit`
- contiene el estado real del proyecto
- contiene `control/` y `workbench/`

## Rol humano
- interactúa preferentemente con `control/`
- no fuerza la secuencia de fases
- solo interviene si `control/` lo pide

## Regla principal
La gobernanza la marca `control/`.
La ejecución la realiza `workbench/`.
La decisión del siguiente paso debe emerger del estado real del proyecto.

