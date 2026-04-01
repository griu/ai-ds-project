# Streamlit app integration notes

## Objectiu
Integrar una app de Streamlit a `templates/app` perquè cada cas instanciat tingui la seva pròpia còpia sota `app/`.

## Carpeta nova
- `templates/app/`

## Cas instanciat
Quan es crea un cas, la carpeta resultant hauria de contenir:

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
Durant `create_case_instance.sh`, s'ha d'escriure:
- `app/case_config.json`

amb com a mínim:
```json
{
  "case_title": "<target_repo_name>",
  "case_slug": "<case_slug>",
  "control_dir": "control",
  "workbench_dir": "workbench"
}
```
