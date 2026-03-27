# Demo guiada de VS Code + Claude para proyectos de Data Science
## Dos ejercicios de hackathon: Home Credit Default Risk y PKDD’99 Financial

> **Objetivo del documento**  
> Este documento reúne **todas las instrucciones operativas de la demo**, la explicación del flujo de trabajo con **2 repositorios** (control y ejecución), y la documentación de **2 ejercicios completos** preparados con formato de hackathon.

---

# 1. Qué es este paquete y cómo se usa

Este paquete **no es** el proyecto operativo en sí mismo.  
Este paquete contiene:

1. una **guía maestra** para la demo;
2. dos **casos de hackathon** completos;
3. los **documentos de entrada** que deben copiarse al repo de trabajo de cada caso;
4. las instrucciones para crear una **instancia nueva** a partir de la plantilla base.

La idea didáctica es la siguiente:

- existe una **plantilla base** con 2 repositorios:
  - `ds-control-plane`
  - `ds-project-workbench`
- esa plantilla base **no se toca** durante la demo;
- para **cada caso** o **cada dataset**, se crea una **nueva instancia de trabajo** a partir de la plantilla;
- cada instancia de trabajo usa:
  - un repo de control para **definir, revisar y decidir**;
  - un repo de ejecución para **construir, validar y reportar**.

---

# 2. Regla operativa principal: la plantilla base no se usa directamente

## 2.1. Qué tienes ahora mismo
Lo que tienes ahora mismo es una **plantilla base**.  
Sirve como semilla reusable, no como repositorio final del caso.

## 2.2. Qué debes hacer para cada ejercicio
Para cada ejercicio debes crear una **pareja nueva de repositorios de trabajo**:

- un repo de control **específico del caso**
- un repo de ejecución **específico del caso**

## 2.3. Nomenclatura recomendada
Para evitar confusiones, usa nombres explícitos.

### Caso 1 — Home Credit
- `home-credit-control`
- `home-credit-workbench`

### Caso 2 — PKDD’99
- `pkdd99-control`
- `pkdd99-workbench`

## 2.4. Regla de apertura en VS Code
Para cada demo activa:

- abre **solo 2 ventanas** de VS Code:
  - una con el repo `*-control`
  - otra con el repo `*-workbench`

No abras:
- la plantilla base;
- dos casos distintos a la vez dentro del mismo chat;
- varios repos de casos mezclados en el mismo workspace.

---

# 3. Procedimiento exacto para crear una nueva instancia de caso

## 3.1. Paso 1 — conservar intacta la plantilla
Mantén sin tocar:
- `ds-control-plane`
- `ds-project-workbench`

## 3.2. Paso 2 — duplicar la plantilla para el caso
Crea una copia de los 2 repos base.

### Ejemplo para Home Credit
- copia `ds-control-plane` a `home-credit-control`
- copia `ds-project-workbench` a `home-credit-workbench`

### Ejemplo para PKDD’99
- copia `ds-control-plane` a `pkdd99-control`
- copia `ds-project-workbench` a `pkdd99-workbench`

## 3.3. Paso 3 — copiar el paquete documental del caso
Cada ejercicio de este paquete trae su propia carpeta documental.

Debes copiar:

### Al repo de control del caso
Los ficheros que están en:
- `cases/<caso>/control_seed/`

### Al repo de workbench del caso
Los ficheros que están en:
- `cases/<caso>/workbench_seed/`

## 3.4. Paso 4 — abrir solo esos 2 repos del caso en VS Code
Ejemplo de una sesión de demo para Home Credit:

- ventana 1: `home-credit-control`
- ventana 2: `home-credit-workbench`

## 3.5. Paso 5 — empezar por el repo de control
La demo empieza siempre en el repo de control.

---



# 3 bis. Automatización con Bash y Git para crear una instancia por caso

> **Objetivo de esta sección**  
> Dejar documentado un procedimiento simple y repetible para:  
> 1. copiar la plantilla base;  
> 2. crear una instancia nueva para un caso;  
> 3. inyectar la documentación seed del caso;  
> 4. inicializar o reinicializar Git;  
> 5. subir ambos repositorios nuevos al remoto.

## 3 bis.1. Convención recomendada

Se parte de una carpeta de trabajo con esta estructura mínima:

```text
/git/ai-ds-project/
├─ templates/
│  ├─ ds-control-plane/
│  └─ ds-project-workbench/
└─ demo/
   └─ cases/
      ├─ home-credit/
      └─ pkdd99/
```

Donde:
- `templates/ds-control-plane/` es la plantilla base del repo de control.
- `templates/ds-project-workbench/` es la plantilla base del repo de ejecución.
- `demo/cases/<caso>/` contiene la semilla documental de cada ejercicio.

## 3 bis.2. Script Bash para crear una instancia local de caso

Guarda este script como `scripts/create_case_instance.sh` en una carpeta auxiliar de tu elección.

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 5 ]]; then
  echo "Uso: $0 <ROOT_DIR> <CASE_SLUG> <CONTROL_TEMPLATE> <WORKBENCH_TEMPLATE> <CASEPACK_DIR>"
  echo "Ejemplo: $0 ~/git/ai-ds-project home-credit ~/git/ai-ds-project/templates/ds-control-plane ~/git/ai-ds-project/templates/ds-project-workbench ~/git/ai-ds-project/demo/cases/home-credit"
  exit 1
fi

ROOT_DIR="$1"
CASE_SLUG="$2"
CONTROL_TEMPLATE="$3"
WORKBENCH_TEMPLATE="$4"
CASEPACK_DIR="$5"

CONTROL_REPO="${ROOT_DIR}/${CASE_SLUG}-control"
WORKBENCH_REPO="${ROOT_DIR}/${CASE_SLUG}-workbench"

mkdir -p "$ROOT_DIR"

if [[ -e "$CONTROL_REPO" || -e "$WORKBENCH_REPO" ]]; then
  echo "Error: ya existe una carpeta de destino para el caso ${CASE_SLUG}."
  echo "Control:   $CONTROL_REPO"
  echo "Workbench: $WORKBENCH_REPO"
  exit 2
fi

echo ">>> Copiando plantilla de control"
cp -R "$CONTROL_TEMPLATE" "$CONTROL_REPO"

echo ">>> Copiando plantilla de workbench"
cp -R "$WORKBENCH_TEMPLATE" "$WORKBENCH_REPO"

echo ">>> Inyectando seed documental del caso en control"
cp -R "$CASEPACK_DIR/control_seed/." "$CONTROL_REPO/"

echo ">>> Inyectando seed documental del caso en workbench"
cp -R "$CASEPACK_DIR/workbench_seed/." "$WORKBENCH_REPO/"

echo ">>> Eliminando metadatos Git heredados de la plantilla si existen"
find "$CONTROL_REPO" "$WORKBENCH_REPO" -type d -name .git -prune -exec rm -rf {} + 2>/dev/null || true

echo ">>> Inicializando repos Git locales"
git -C "$CONTROL_REPO" init
git -C "$WORKBENCH_REPO" init

echo ">>> Creando rama principal main"
git -C "$CONTROL_REPO" checkout -b main
git -C "$WORKBENCH_REPO" checkout -b main

echo ">>> Primer commit local en ambos repos"
git -C "$CONTROL_REPO" add .
git -C "$CONTROL_REPO" commit -m "Initialize ${CASE_SLUG} control repo from template"

git -C "$WORKBENCH_REPO" add .
git -C "$WORKBENCH_REPO" commit -m "Initialize ${CASE_SLUG} workbench repo from template"

echo ">>> Instancia creada correctamente"
echo "Control:   $CONTROL_REPO"
echo "Workbench: $WORKBENCH_REPO"
```

## 3 bis.3. Ejemplo de uso para Home Credit

```bash
bash scripts/create_case_instance.sh \
  ~/git/ai-ds-project \
  home-credit \
  ~/git/ai-ds-project/templates/ds-control-plane \
  ~/git/ai-ds-project/templates/ds-project-workbench \
  ~/git/ai-ds-project/demo/cases/home-credit
```

## 3 bis.4. Ejemplo de uso para PKDD’99

```bash
bash scripts/create_case_instance.sh \
  ~/git/ai-ds-project \
  pkdd99 \
  ~/git/ai-ds-project/templates/ds-control-plane \
  ~/git/ai-ds-project/templates/ds-project-workbench \
  ~/git/ai-ds-project/demo/cases/pkdd99
```

## 3 bis.5. Qué hace exactamente este script

1. crea dos carpetas nuevas para el caso;
2. copia la plantilla base en ambas;
3. copia la documentación seed del caso;
4. elimina cualquier `.git` heredado de las plantillas;
5. inicializa ambos repositorios desde cero;
6. hace el primer commit local.

Con esto, cada caso queda aislado y listo para abrirse en dos ventanas de VS Code.

# 3 ter. Publicación de los repositorios nuevos en remoto

## 3 ter.1. Opción A — ya existen los repositorios remotos

Si ya has creado en GitHub, GitLab o similar estos dos remotos:
- `<CASE_SLUG>-control`
- `<CASE_SLUG>-workbench`

usa este procedimiento.

### Script para vincular y subir repos ya existentes

Guarda este script como `scripts/push_case_repos_existing_remote.sh`.

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 5 ]]; then
  echo "Uso: $0 <ROOT_DIR> <CASE_SLUG> <CONTROL_REMOTE_URL> <WORKBENCH_REMOTE_URL> <BRANCH>"
  echo "Ejemplo: $0 ~/git/ai-ds-project home-credit git@github.com:tu-org/home-credit-control.git git@github.com:tu-org/home-credit-workbench.git main"
  exit 1
fi

ROOT_DIR="$1"
CASE_SLUG="$2"
CONTROL_REMOTE_URL="$3"
WORKBENCH_REMOTE_URL="$4"
BRANCH="$5"

CONTROL_REPO="${ROOT_DIR}/${CASE_SLUG}-control"
WORKBENCH_REPO="${ROOT_DIR}/${CASE_SLUG}-workbench"

git -C "$CONTROL_REPO" remote remove origin 2>/dev/null || true
git -C "$CONTROL_REPO" remote add origin "$CONTROL_REMOTE_URL"
git -C "$CONTROL_REPO" push -u origin "$BRANCH"

git -C "$WORKBENCH_REPO" remote remove origin 2>/dev/null || true
git -C "$WORKBENCH_REPO" remote add origin "$WORKBENCH_REMOTE_URL"
git -C "$WORKBENCH_REPO" push -u origin "$BRANCH"

echo ">>> Repositorios publicados correctamente"
```

### Ejemplo de uso

```bash
bash scripts/push_case_repos_existing_remote.sh \
  ~/git/ai-ds-project \
  home-credit \
  git@github.com:tu-org/home-credit-control.git \
  git@github.com:tu-org/home-credit-workbench.git \
  main
```

## 3 ter.2. Opción B — crear y publicar con GitHub CLI (`gh`)

Si usas GitHub y tienes `gh` autenticado, puedes automatizar también la creación del remoto.

### Script para crear los remotos y publicar

Guarda este script como `scripts/create_and_push_case_repos_with_gh.sh`.

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Uso: $0 <ROOT_DIR> <CASE_SLUG> <GITHUB_OWNER> <VISIBILITY>"
  echo "Ejemplo: $0 ~/git/ai-ds-project home-credit mi-org private"
  exit 1
fi

ROOT_DIR="$1"
CASE_SLUG="$2"
GITHUB_OWNER="$3"
VISIBILITY="$4"   # private o public

CONTROL_REPO_DIR="${ROOT_DIR}/${CASE_SLUG}-control"
WORKBENCH_REPO_DIR="${ROOT_DIR}/${CASE_SLUG}-workbench"
CONTROL_REPO_NAME="${CASE_SLUG}-control"
WORKBENCH_REPO_NAME="${CASE_SLUG}-workbench"

if [[ "$VISIBILITY" != "private" && "$VISIBILITY" != "public" ]]; then
  echo "VISIBILITY debe ser private o public"
  exit 2
fi

gh repo create "${GITHUB_OWNER}/${CONTROL_REPO_NAME}" --${VISIBILITY} --source "$CONTROL_REPO_DIR" --remote origin --push
gh repo create "${GITHUB_OWNER}/${WORKBENCH_REPO_NAME}" --${VISIBILITY} --source "$WORKBENCH_REPO_DIR" --remote origin --push

echo ">>> Repositorios creados y publicados en GitHub"
```

### Ejemplo de uso

```bash
bash scripts/create_and_push_case_repos_with_gh.sh \
  ~/git/ai-ds-project \
  pkdd99 \
  mi-org \
  private
```

## 3 ter.3. Flujo mínimo recomendado para la demo

Para no complicar la operativa, el flujo más simple es este:

1. conservar plantillas en `templates/`;
2. ejecutar `create_case_instance.sh` para el caso que se vaya a demostrar;
3. si hace falta remoto:
   - o bien crear los repos a mano y usar `push_case_repos_existing_remote.sh`;
   - o bien usar `create_and_push_case_repos_with_gh.sh` si trabajas con GitHub CLI;
4. abrir en VS Code solo:
   - `<CASE_SLUG>-control`
   - `<CASE_SLUG>-workbench`

## 3 ter.4. Qué debe evitarse

- no reutilizar una carpeta activa para dos casos distintos;
- no empujar varios casos al mismo remoto;
- no mantener `.git` heredados de la plantilla;
- no abrir plantilla y caso activo en el mismo chat.


# 4. Flujo estándar de la demo

## 4.1. Papel del repo de control
El repo de control:
- lee el contexto del caso;
- analiza el estado del proyecto;
- redacta `next_task.md`;
- revisa `task_result.md`;
- decide si se avanza o no.

## 4.2. Papel del repo de ejecución
El repo de ejecución:
- lee `next_task.md`;
- valida inputs y estado inicial;
- ejecuta la tarea;
- genera documentación, scripts o notebooks;
- redacta `task_result.md`.

## 4.3. Intercambio mínimo entre repos
La demo se gobierna con **dos archivos visibles**:

- `next_task.md`
- `task_result.md`

### Movimiento de archivos
1. `next_task.md` se genera en el repo de control.
2. Se copia al repo de ejecución.
3. `task_result.md` se genera en el repo de ejecución.
4. Se copia al repo de control.

---

# 5. Secuencia de fases recomendada para cualquier caso

## Fase 1 — Normalización del problema
Objetivo:
- convertir documentos brutos en documentación estructurada del proyecto.

Entregables esperados:
- `docs/00_business_brief.md`
- `docs/01_decision_frame.md`
- `docs/02_data_sources.md`
- `docs/03_model_operating_model.md`

## Fase 2 — Conectividad y entorno
Objetivo:
- decidir el escenario de acceso a datos;
- preparar `pyproject.toml`;
- preparar `.venv/` local del repo;
- dejar un smoke test de acceso.

Escenarios soportados por la plantilla:
- PostgreSQL + carpetas locales
- Oracle + carpetas locales
- BigQuery + GCS + carpetas locales

## Fase 3 — EDA inicial
Objetivo:
- usar `ydata-profiling` para el perfilado inicial;
- detectar calidad de datos, nulos, cardinalidades, outliers y riesgos de leakage;
- derivar hipótesis de limpieza y features.

## Fase 4 — Limpieza y feature engineering
Objetivo:
- formalizar reglas de limpieza;
- definir agregaciones;
- crear variables derivadas;
- documentar exclusiones y transformaciones.

## Fase 5 — Modelización y comparación
Objetivo:
- proponer baseline y modelos comparables;
- validar temporalmente cuando aplique;
- justificar métricas de negocio.

## Fase 6 — Preparación de industrialización
Objetivo:
- describir pipeline modular;
- definir scoring batch o recurrente;
- preparar seguimiento, estabilidad y drift.

---

# 6. Guion operativo exacto de la demo

## 6.1. Prompt de arranque en el repo de control
Usa este prompt en el chat del repo `*-control`:

```text
Lee `project_context.md` y los materiales de control disponibles.
Quiero que redactes la primera versión de `next_task.md`.

Reglas:
- La tarea debe ser pequeña, gobernada y verificable.
- No debe entrar todavía en modelización.
- Debe centrarse en convertir los inputs del repo de ejecución en documentación base del proyecto.
- Debe pedir outputs concretos en `docs/`.
- Debe incluir criterios de finalización y límites.
- Escribe todo en castellano.
```

## 6.2. Acción manual
Copia `next_task.md` del repo de control al repo de ejecución.

## 6.3. Prompt de arranque en el repo de ejecución
Usa este prompt en el chat del repo `*-workbench`:

```text
Lee `next_task.md` y ejecútala.

Antes de empezar:
1. valida qué inputs existen realmente;
2. confirma si la tarea está bien definida;
3. señala vacíos o ambigüedades relevantes.

Después:
- genera los documentos base del proyecto en `docs/`;
- no entres todavía en modelización;
- actualiza `task_result.md` con resultado, incidencias y grado de cierre.
```

## 6.4. Acción manual
Copia `task_result.md` del repo de ejecución al repo de control.

## 6.5. Prompt de revisión en el repo de control
Usa este prompt en el chat del repo `*-control`:

```text
Revisa `task_result.md` y decide si la tarea está cerrada.

Después:
- redacta `review_notes.md`;
- genera una nueva versión de `next_task.md`;
- la nueva tarea debe centrarse en la siguiente fase lógica del proyecto;
- mantén el trabajo gobernado, pequeño y verificable.
```

## 6.6. Orden recomendado para la demo en directo
Para que la demo sea clara, la secuencia recomendada es:

1. framing del problema;
2. conectividad y entorno (`pyproject.toml` + `.venv`);
3. EDA con `ydata-profiling`;
4. reglas de limpieza y features;
5. estrategia de modelización;
6. blueprint de industrialización.

---

# 7. Criterios de evaluación de la demo

## 7.1. Qué se quiere demostrar
La demo debe demostrar que:

- el proyecto se define de forma gobernada;
- Claude no empieza por “hacer código al azar”;
- la tarea pasa primero por framing y documentación;
- el trabajo se divide en pasos pequeños;
- cada paso deja evidencia y estado;
- el método es reusable entre datasets.

## 7.2. Qué no se quiere demostrar
No es necesario demostrar en la primera sesión:

- un modelo final perfecto;
- un pipeline completo en producción;
- automatizaciones complejas;
- integración real con sistemas corporativos;
- orquestación multiusuario.

---

# 8. Ejercicio 1 — Home Credit Default Risk Hackathon

## 8.1. Narrativa del ejercicio
**Nombre del reto:**  
**Retail Credit Risk Sprint — Home Credit**

**Contexto de hackathon:**  
Un equipo de riesgo retail quiere rediseñar el proceso inicial de modelización para evaluar el riesgo de impago de nuevas solicitudes de préstamo al consumo. La prioridad no es ganar Kaggle, sino demostrar un método gobernado que convierta documentación y datos dispersos en un proyecto de data science bien definido y ejecutable.

**Pregunta de negocio:**  
¿Cómo debe estructurarse un proyecto de predicción de riesgo de impago para nuevas solicitudes, usando datos de solicitud actuales y el historial relacional del cliente, de forma que el proyecto sea explicable, reusable y apto para evolucionar a producción?

**Objetivo didáctico de la demo:**  
Mostrar que la EDA y el feature engineering relacional-temporal no son un “extra”, sino parte esencial para definir correctamente el problema y preparar modelos comparables.

## 8.2. Qué hace interesante este caso
Este caso es interesante para la demo porque:
- parte de un problema clásico de riesgo de crédito;
- tiene varias tablas relacionadas;
- obliga a agregar historia pasada;
- fuerza a pensar en leakage y en qué fecha se puede observar cada dato;
- permite comparar baseline, XGBoost y opciones más avanzadas;
- permite discutir scoring batch, explainability y monitorización.

## 8.3. Hechos públicos del dataset a tener presentes
El reto Home Credit Default Risk es una competición pública de Kaggle orientada a predecir la capacidad de repago de una solicitud, y el dataset se articula alrededor de la tabla de solicitud actual y varias tablas relacionales de histórico como `bureau`, `bureau_balance`, `previous_application`, `POS_CASH_balance`, `installments_payments` y `credit_card_balance`. Para usarlo en la práctica hace falta acceso a Kaggle y aceptación de sus condiciones del reto. [Fuente pública para la demo: Kaggle competition overview y materiales públicos asociados.]

## 8.4. Resultado esperado del framing
Al finalizar las primeras iteraciones, el proyecto debería haber definido:

- unidad de predicción: solicitud actual;
- target: probabilidad de default / no repago;
- ventana de observación: historia previa del cliente conocida antes de la solicitud actual;
- riesgo principal: leakage por mezclar información futura o agregaciones mal fechadas;
- output esperado: scoring priorizable para revisión o pricing de riesgo.

## 8.5. Paquete documental del caso
Los documentos de entrada preparados para este caso están en:

- `cases/home-credit/control_seed/`
- `cases/home-credit/workbench_seed/`

### Contenido previsto en control
- `project_context.md`
- `jury_and_demo_goals.md`

### Contenido previsto en workbench
- `inputs/business_docs/00_hackathon_brief_home_credit.md`
- `inputs/business_docs/01_business_constraints_home_credit.md`
- `inputs/technical_docs/02_data_landscape_home_credit.md`
- `inputs/technical_docs/03_model_operating_assumptions_home_credit.md`
- `inputs/dictionaries/04_table_dictionary_home_credit.md`
- `inputs/data_samples/README_data_acquisition.md`

## 8.6. Objetivos de la demo para este caso
### Objetivo funcional
Definir el proyecto de riesgo de crédito de forma gobernada.

### Objetivo técnico
Preparar el terreno para:
- conectividad;
- perfilado;
- agregaciones relacionales;
- validación temporal;
- benchmark de modelos.

### Objetivo narrativo de la demo
Enseñar que la parte más valiosa al principio no es el modelo, sino la capacidad de convertir negocio + datos + restricciones en un backlog ordenado.

## 8.7. Primera tarea recomendada
La primera `next_task.md` de este caso debe pedir:

- revisión completa de los inputs del caso;
- generación de los 4 documentos base del proyecto;
- identificación explícita de leakage risk;
- lista de preguntas abiertas antes de diseñar conectividad y entorno.

## 8.8. Segunda tarea recomendada
La segunda `next_task.md` de este caso debe pedir:

- selección del escenario de conectividad;
- preparación de `pyproject.toml`;
- preparación de `.venv/`;
- definición del módulo inicial de acceso a datos;
- smoke test mínimo;
- documentación del escenario elegido.

## 8.9. Tercera tarea recomendada
La tercera `next_task.md` de este caso debe pedir:

- EDA inicial con `ydata-profiling`;
- resumen accionable de calidad de datos;
- hipótesis de agregación por tabla histórica;
- riesgos de sesgo temporal y leakage.

## 8.10. Preguntas de jurado o audiencia para dar interés
- ¿Qué fecha exacta define qué información es observable y qué información ya sería leakage?
- ¿Qué tablas aportan señal de comportamiento histórico y cuáles aportan ruido o riesgo de inconsistencia?
- ¿Cómo se documentará una feature agregada para que luego sea reproducible en scoring?
- ¿Qué haría falta cambiar para convertir un notebook ganador en un pipeline mantenible?

---

# 9. Ejercicio 2 — PKDD’99 Financial Hackathon

## 9.1. Narrativa del ejercicio
**Nombre del reto:**  
**Temporal Relational Credit Challenge — PKDD’99**

**Contexto de hackathon:**  
Un equipo de analítica avanzada quiere usar un dataset relacional clásico con transacciones históricas para demostrar un enfoque serio de modelización temporal. El objetivo no es solo clasificar préstamos, sino dejar claro por qué la restricción temporal y la definición correcta del target cambian por completo el proyecto.

**Pregunta de negocio:**  
¿Cómo se construye un proyecto de scoring de préstamos cuando el dato está repartido en un esquema relacional con transacciones y la línea temporal es crítica para evitar leakage?

**Objetivo didáctico de la demo:**  
Mostrar que la modelización temporal bien planteada empieza mucho antes del modelo: empieza por respetar qué se sabía en la fecha de concesión.

## 9.2. Qué hace interesante este caso
Este caso es interesante para la demo porque:
- el dataset es relacional y temporal;
- tiene préstamos, cuentas, clientes, disposiciones y transacciones;
- permite enseñar el error clásico de mezclar información posterior al evento;
- obliga a decidir la unidad de observación y la fecha de corte;
- deja muy claro el valor del framing antes del código.

## 9.3. Hechos públicos del dataset a tener presentes
El dataset **Financial / PKDD’99** del repositorio relacional de CTU contiene 8 tablas, más de 1 millón de filas, datos temporales y valores faltantes. Su tarea estándar es predecir el resultado del préstamo en la tabla `loan`, usando como unidad `account_id` y como timestamp objetivo la fecha `loan.date`; la propia documentación pública advierte que ignorar la restricción temporal altera de forma crítica los resultados. El dataset puede exportarse desde una base MariaDB pública con credenciales de invitado. [Fuente pública para la demo: CTU Relational Dataset Repository.]

## 9.4. Resultado esperado del framing
Al finalizar las primeras iteraciones, el proyecto debería haber definido:

- unidad de predicción: préstamo / cuenta con préstamo;
- target: estado del préstamo según formulación acordada;
- fecha de corte: fecha de inicio del préstamo;
- restricción clave: no usar transacciones posteriores a la fecha del préstamo;
- output esperado: score o clasificación explicable en el momento de originación.

## 9.5. Paquete documental del caso
Los documentos de entrada preparados para este caso están en:

- `cases/pkdd99/control_seed/`
- `cases/pkdd99/workbench_seed/`

### Contenido previsto en control
- `project_context.md`
- `jury_and_demo_goals.md`

### Contenido previsto en workbench
- `inputs/business_docs/00_hackathon_brief_pkdd99.md`
- `inputs/business_docs/01_business_constraints_pkdd99.md`
- `inputs/technical_docs/02_data_landscape_pkdd99.md`
- `inputs/technical_docs/03_temporal_modeling_assumptions_pkdd99.md`
- `inputs/dictionaries/04_table_dictionary_pkdd99.md`
- `inputs/data_samples/README_data_acquisition.md`

## 9.6. Objetivos de la demo para este caso
### Objetivo funcional
Definir un proyecto de scoring temporal respetando la observabilidad real.

### Objetivo técnico
Preparar el terreno para:
- conectividad o ingestión;
- filtrado temporal;
- agregaciones históricas hasta fecha de corte;
- benchmark baseline vs boosting;
- monitorización de drift temporal y segmentación.

### Objetivo narrativo de la demo
Enseñar que un proyecto puede parecer “fácil” si ignora el tiempo, pero se vuelve serio y más realista cuando el tiempo se trata correctamente.

## 9.7. Primera tarea recomendada
La primera `next_task.md` de este caso debe pedir:

- revisión de inputs;
- generación de documentación base;
- definición de unidad de predicción, target y fecha de corte;
- inventario de riesgos de leakage temporal;
- preguntas abiertas antes de preparar conectividad.

## 9.8. Segunda tarea recomendada
La segunda `next_task.md` de este caso debe pedir:

- selección del escenario de conectividad;
- preparación de `pyproject.toml`;
- preparación de `.venv/`;
- primera estrategia de extracción o carga;
- smoke test mínimo;
- documentación de tablas prioritarias.

## 9.9. Tercera tarea recomendada
La tercera `next_task.md` de este caso debe pedir:

- EDA inicial con `ydata-profiling`;
- caracterización de tablas y claves;
- propuesta de filtros temporales;
- hipótesis de agregaciones de transacciones y órdenes hasta la fecha de corte.

## 9.10. Preguntas de jurado o audiencia para dar interés
- ¿Qué ocurre si se usan transacciones posteriores a la concesión del préstamo?
- ¿Cuál es la mejor unidad de modelización: préstamo, cuenta o cliente?
- ¿Qué agregaciones aportan más valor sin romper la restricción temporal?
- ¿Cómo se documentaría la fecha de corte para que ingeniería la respete después?

---

# 10. Cómo decidir qué ejercicio usar en la demo

## 10.1. Usa Home Credit si quieres enseñar
- riesgo de crédito moderno;
- muchas tablas conocidas por la comunidad;
- feature engineering relacional;
- comparativa clara de modelos;
- una narrativa cercana a banca retail actual.

## 10.2. Usa PKDD’99 si quieres enseñar
- modelización temporal de verdad;
- riesgo de leakage muy visible;
- diseño relacional clásico;
- valor del framing temporal;
- cómo el problema cambia si se respeta la fecha de corte.

## 10.3. Recomendación práctica
Si solo vas a enseñar una demo breve:
- usa **Home Credit**.

Si vas a enseñar dos demos o quieres remarcar la importancia del tiempo:
- usa **PKDD’99** como segundo ejercicio.

---

# 11. Qué se espera crear físicamente en el repo de ejecución

## Tras la Fase 1
- `docs/00_business_brief.md`
- `docs/01_decision_frame.md`
- `docs/02_data_sources.md`
- `docs/03_model_operating_model.md`

## Tras la Fase 2
- `pyproject.toml`
- `.venv/` local en el repo
- módulo base de conectividad o lectura
- smoke test mínimo
- nota técnica del escenario elegido

## Tras la Fase 3
- informe de `ydata-profiling`
- nota accionable de hallazgos
- backlog de limpieza y features

---

# 12. Qué se espera crear físicamente en el repo de control

- `next_task.md`
- `review_notes.md`
- tareas sucesivas pequeñas y verificables
- evidencia de cierre de fase

---

# 13. Recomendación de guion para una sesión de 30–40 minutos

## Tramo 1 — 5 min
Explicar:
- plantilla base;
- por qué hay 2 repos;
- cómo se instancia un caso a partir de la plantilla.

## Tramo 2 — 10 min
En el repo de control:
- usar el prompt de arranque;
- generar `next_task.md`.

## Tramo 3 — 10 min
En el repo de ejecución:
- ejecutar la tarea;
- generar los documentos base;
- cerrar `task_result.md`.

## Tramo 4 — 10 min
Volver al repo de control:
- revisar `task_result.md`;
- generar siguiente tarea de conectividad y entorno.

## Tramo 5 — 5 min
Explicar cómo continuar después con:
- `pyproject.toml`
- `.venv/`
- conectividad
- `ydata-profiling`
- features
- modelos
- drift

---

# 14. Recomendación de guion para una sesión más larga de 60–90 minutos

## Primer bloque
Framing y documentación base

## Segundo bloque
Entorno técnico y conectividad

## Tercer bloque
EDA y backlog de limpieza/features

## Cuarto bloque
Diseño de modelización y blueprint de industrialización

---

# 15. Lista de comprobación antes de arrancar la demo

- [ ] Se han creado las copias del caso a partir de la plantilla base
- [ ] Se ha copiado el paquete documental correcto al repo del caso
- [ ] Solo están abiertas las 2 ventanas del caso
- [ ] El repo de control tiene `project_context.md`
- [ ] El repo de ejecución tiene inputs cargados
- [ ] Claude Sonnet 4.6 está disponible/seleccionable
- [ ] No se está trabajando dentro de la plantilla base

---

# 16. Fuentes públicas utilizadas para diseñar los ejercicios

## Home Credit Default Risk
- Kaggle competition: Home Credit Default Risk
- Materiales públicos y notebooks comunitarios que describen la estructura relacional del reto

## PKDD’99 Financial
- CTU Relational Dataset Repository — Financial dataset

## VS Code / Claude / Skills
- Visual Studio Code: custom agents, prompt files, agent skills
- Claude Code: skills

> En la respuesta de chat asociada a este documento se citan las fuentes públicas verificadas.  
> Dentro del markdown se ha priorizado la legibilidad del documento para posterior paso a Word o presentación.
