# Streamlit app integration notes

## Objetivo
Integrar una app de Streamlit a `templates/app` para que cada caso instanciado tenga su propia copia bajo `app/`.

## Rol funcional de la app
La app se considera un **cockpit operativo y de seguimiento**.

Su función principal es:
- visualizar el estado global y local;
- explorar artefactos del flujo;
- facilitar la operación manual o supervisada del sistema;
- ayudar a entender qué agente debería actuar a continuación.

Por ahora, **no es la fuente de verdad del workflow** ni el motor principal de dispatch.
La fuente de verdad sigue siendo:
- `control/WORKFLOW_STATE.md`
- `workbench/WORKBENCH_STATE.md`
- `control/next_task.md`
- `workbench/task_result.md`
- `control/AUTOMATION_POLICY.md`

## Carpeta nueva
- `templates/app/`

## Caso instanciado
Cuando se crea un caso, la carpeta resultante debe contener:

```text
<CASE_REPO>/
├─ control/
├─ workbench/
└─ app/
   ├─ app.py
   ├─ case_config.json
   ├─ requirements.txt
   ├─ run_streamlit.sh
   ├─ README.md
   └─ lib/repo_state.py
```

## Títol del cas
Durante `create_case_instance.sh`, se escribe:
- `app/case_config.json`

con como mínimo:
```json
{
  "case_title": "<target_repo_name>",
  "case_slug": "<case_slug>",
  "control_dir": "control",
  "workbench_dir": "workbench"
}
```

## Datos que consume la app
La app debe leer directamente:
- `control/WORKFLOW_STATE.md`
- `control/AUTOMATION_POLICY.md`
- `control/next_task.md`
- `control/review_notes.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `workbench/WORKBENCH_STATE.md`
- `workbench/task_result.md`
- historial markdown de `control/history/` y `workbench/history/`
- historial Git si existe

## Reglas de coherencia
- La app no debe imponer un vocabulario de estados distinto del definido en `control/WORKFLOW_STATE.md` y `workbench/WORKBENCH_STATE.md`.
- Si existe compatibilidad hacia atrás con estados antiguos, debe implementarse como alias, no como nuevo vocabulario oficial.
- La app debe ayudar a seguir el flujo, no a redefinir el framework por su cuenta.
