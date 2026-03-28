# Demo guiada de VS Code + Claude para proyectos de Data Science
## Dos ejercicios de hackathon: Home Credit Default Risk y PKDD’99 Financial

> **Objetivo del documento**
> Este documento reúne todas las instrucciones operativas de la demo, el modelo de trabajo con `control/` y `workbench/`, y la forma correcta de instanciar cada caso desde `ai-ds-project`.

---

# 1. Qué es `ai-ds-project`

`ai-ds-project` es el **repo maestro** del framework.

Aquí evolucionan:
- prompts base;
- skills didácticas;
- agentes;
- documentación reusable;
- scripts de instanciación.

**No es el repo activo del caso.**

Cada caso se crea fuera de este repo como un **nuevo repo único**.

---

# 2. Modelo final de trabajo

## 2.1. Repo maestro
Ejemplo:

```text
/home/griu/git/ai-ds-project
```

## 2.2. Repos instanciados por caso
Ejemplos:

```text
/home/griu/git/home-credit
/home/griu/git/pkdd99
```

## 2.3. Estructura interna de cada caso
Cada caso instanciado tiene un único `.git` en la raíz y dos áreas de trabajo:

```text
/home/griu/git/home-credit/
├─ .git
├─ control/
└─ workbench/
```

- `control/`: define la siguiente tarea y revisa resultados.
- `workbench/`: ejecuta la tarea y devuelve `task_result.md`.

---

# 3. Regla operativa principal

## 3.1. No trabajar directamente en `ai-ds-project`
La demo no se ejecuta sobre el repo maestro.

## 3.2. Instanciar primero un caso
Antes de abrir VS Code para el caso, debes crear el repo del caso con el script de instanciación.

---

# 4. Estructura fuente dentro de `ai-ds-project`

```text
ai-ds-project/
├─ templates/
│  ├─ control/
│  └─ workbench/
├─ demo/
│  ├─ DEMO_HACKATHON_PLAYBOOK.md
│  ├─ scripts/
│  │  ├─ create_case_instance.sh
│  │  ├─ push_case_repos_existing_remote.sh
│  │  └─ create_and_push_case_repos_with_gh.sh
│  └─ cases/
│     ├─ home-credit/
│     │  ├─ control/
│     │  └─ workbench/
│     └─ pkdd99/
│        ├─ control/
│        └─ workbench/
└─ ...
```

Donde:
- `templates/control/` es la base reusable de `control/`.
- `templates/workbench/` es la base reusable de `workbench/`.
- `demo/cases/<slug>/control/` añade ficheros específicos del caso a `control/`.
- `demo/cases/<slug>/workbench/` añade ficheros específicos del caso a `workbench/`.

---

# 5. Cómo crear un caso nuevo

## 5.1. Comando de instanciación

Ejemplo para Home Credit:

```bash
bash ~/git/ai-ds-project/demo/scripts/create_case_instance.sh \
  ~/git/ai-ds-project \
  home-credit \
  ~/git
```

Ejemplo para PKDD’99:

```bash
bash ~/git/ai-ds-project/demo/scripts/create_case_instance.sh \
  ~/git/ai-ds-project \
  pkdd99 \
  ~/git
```

## 5.2. Resultado esperado

```text
/home/griu/git/home-credit/
├─ .git
├─ .gitignore
├─ README.md
├─ home-credit.code-workspace
├─ control/
└─ workbench/
```

---

# 6. Cómo abrir la demo en VS Code

## 6.1. Opción recomendada para la demo: dos ventanas

Para Home Credit:

```bash
code -n ~/git/home-credit/control
code -n ~/git/home-credit/workbench
```

Para PKDD’99:

```bash
code -n ~/git/pkdd99/control
code -n ~/git/pkdd99/workbench
```

## 6.2. Workspace opcional del caso
El script crea también un `.code-workspace` por caso.

Ejemplo:

```bash
code ~/git/home-credit/home-credit.code-workspace
```

Aun así, para la demo de roles, se recomienda usar dos ventanas separadas.

---

# 7. Regla de handoff entre control y workbench

No hace falta duplicar archivos entre ambas áreas.

## 7.1. Fuente de verdad de la tarea activa
- `control/next_task.md`

## 7.2. Fuente de verdad del resultado de ejecución
- `workbench/task_result.md`

## 7.3. Lectura cruzada esperada
- `workbench/` debe leer `../control/next_task.md`
- `control/` debe leer `../workbench/task_result.md`

---

# 8. Flujo operativo de la demo

## Iteración 1
1. Abre `control/`.
2. Pide a Claude que lea `project_context.md`, `jury_and_demo_goals.md` y redacte `next_task.md`.
3. Abre `workbench/`.
4. Pide a Claude que lea `../control/next_task.md` y ejecute la tarea.
5. Claude actualiza `task_result.md` en `workbench/`.
6. Vuelve a `control/`.
7. Pide a Claude que revise `../workbench/task_result.md` y redacte la siguiente tarea.

## Orden recomendado de fases
1. Normalización documental del caso.
2. Decisión de conectividad y entorno.
3. Preparación de `pyproject.toml` y `.venv/` cuando aplique.
4. EDA con `ydata-profiling`.
5. Limpieza y feature engineering.
6. Estrategia de modelización.
7. Monitoring y drift.

---

# 9. Publicación del repo del caso

## 9.1. Si el remoto ya existe

```bash
bash ~/git/ai-ds-project/demo/scripts/push_case_repos_existing_remote.sh \
  ~/git/home-credit \
  git@github.com:usuario/home-credit.git \
  main
```

## 9.2. Si quieres crear el repo remoto con GitHub CLI

```bash
bash ~/git/ai-ds-project/demo/scripts/create_and_push_case_repos_with_gh.sh \
  ~/git/home-credit \
  mi-org \
  private
```

---

# 10. Ejercicio 1 — Home Credit Default Risk

## 10.1. Propósito didáctico
Mostrar un problema de riesgo de crédito con varias tablas, necesidad de agregaciones históricas y fuerte relevancia de leakage, definición de target y despliegue posterior.

## 10.2. Objetivo del hackathon
Definir correctamente el proyecto antes de modelar:
- unidad de predicción;
- target;
- fecha de observación;
- tablas que exigen agregaciones;
- backlog para conectividad, EDA y modelización.

## 10.3. Inputs específicos del caso
### En `control/`
- `project_context.md`
- `jury_and_demo_goals.md`

### En `workbench/inputs/`
- `business_docs/00_hackathon_brief_home_credit.md`
- `business_docs/01_business_constraints_home_credit.md`
- `technical_docs/02_data_landscape_home_credit.md`
- `technical_docs/03_model_operating_assumptions_home_credit.md`
- `dictionaries/04_table_dictionary_home_credit.md`
- `data_samples/README_data_acquisition.md`

## 10.4. Qué debe quedar claro
- el modelo no arranca en XGBoost;
- primero se define el problema y la unidad de decisión;
- la EDA debe descubrir reglas de limpieza y familias de features;
- las tablas históricas requieren agregación documentada.

---

# 11. Ejercicio 2 — PKDD’99 Financial

## 11.1. Propósito didáctico
Mostrar un caso temporal y relacional donde la fecha de corte cambia completamente la validez del proyecto.

## 11.2. Objetivo del hackathon
Definir un proyecto de scoring respetando estrictamente observabilidad temporal y evitando leakage por uso de información posterior al préstamo.

## 11.3. Inputs específicos del caso
### En `control/`
- `project_context.md`
- `jury_and_demo_goals.md`

### En `workbench/inputs/`
- `business_docs/00_hackathon_brief_pkdd99.md`
- `business_docs/01_business_constraints_pkdd99.md`
- `technical_docs/02_data_landscape_pkdd99.md`
- `technical_docs/03_temporal_modeling_assumptions_pkdd99.md`
- `dictionaries/04_table_dictionary_pkdd99.md`
- `data_samples/README_data_acquisition.md`

## 11.4. Qué debe quedar claro
- la fecha de corte debe fijarse antes de crear features;
- no se puede usar información posterior al préstamo;
- el backlog debe transformar una restricción temporal en tareas concretas.

---

# 12. Checklist antes de arrancar la demo

- [ ] `ai-ds-project` está limpio y actualizado.
- [ ] El caso está instanciado fuera del repo maestro.
- [ ] El repo del caso tiene `control/` y `workbench/`.
- [ ] Abres dos ventanas de VS Code, una por área.
- [ ] `control/project_context.md` y `control/jury_and_demo_goals.md` existen.
- [ ] `workbench/inputs/` contiene la documentación del caso.
- [ ] Tienes claro que `../control/next_task.md` y `../workbench/task_result.md` son las fuentes de verdad del handoff.
