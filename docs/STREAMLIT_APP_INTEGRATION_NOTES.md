# Streamlit app integration notes

## Objetivo
Integrar una app de Streamlit a `templates/app` para que cada caso instanciado tenga su propia copia bajo `app/`.

## Papel correcto de la app
La app Streamlit debe actuar como:
- monitor del estado global y local;
- cockpit de seguimiento;
- ayuda visual para prompts, artefactos e histórico.

No debe actuar, por ahora, como motor principal de ejecución autónoma.

## Motor principal de la automatización
La automatización principal vive en **VS Code, desde el chat de `control`**, donde:
- `control` gobierna el ciclo;
- invoca a `workbench` como subagente;
- revisa el resultado;
- y continúa iterando mientras no aparezca una condición de parada humana.

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

## Título del caso
Durante `create_case_instance.sh`, se debe escribir:
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
