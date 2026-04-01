# Streamlit app · Control + Workbench cockpit

App de Streamlit per visualitzar i gestionar la interacció entre `control/` i `workbench/`.

## Què fa
- Mostra l'estat global del workflow i del workbench.
- Detecta quin agent ha estat l'últim a respondre.
- Recomana quin agent hauria d'actuar a continuació.
- Mostra l'històric propi dels markdowns i, opcionalment, el Git history.
- Permet treballar prompts des de la mateixa interfície sense crear nous logs.

## Instal·lació
Des de la carpeta arrel del cas:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r app/requirements.txt
```

## Execució
```bash
bash app/run_streamlit.sh 8501
```

Obre després el navegador a:
- `http://<host>:8501`

## Múltiples instàncies
Per obrir diversos casos alhora, assigna un port diferent a cada repo:
- cas 1 → `8501`
- cas 2 → `8502`
- cas 3 → `8503`

## Configuració del cas
L'app llegeix `app/case_config.json` per mostrar el títol i els paths del cas.
Aquest fitxer s'ha d'escriure automàticament durant `create_case_instance.sh`.
