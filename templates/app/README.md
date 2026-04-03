# Streamlit app · Control + Workbench cockpit

App de Streamlit per visualitzar i gestionar la interacció entre `control/` i `workbench/`.

## Què fa
- Mostra l'estat global del workflow i del workbench.
- Detecta quin agent ha estat l'últim a respondre.
- Recomana quin agent hauria d'actuar a continuació.
- Mostra l'històric propi dels markdowns i, opcionalment, el Git history.
- Permet treballar prompts des de la mateixa interfície sense crear nous logs.
- Llegeix també la política d'automatització de `control/AUTOMATION_POLICY.md`.

## Què no fa
- No substitueix `control` ni `workbench` com a actors del flux.
- No és la font de veritat dels estats.
- No redefineix per si sola el workflow.

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

## Fonts de veritat que consumeix
- `control/WORKFLOW_STATE.md`
- `control/AUTOMATION_POLICY.md`
- `control/next_task.md`
- `control/review_notes.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `workbench/WORKBENCH_STATE.md`
- `workbench/task_result.md`
