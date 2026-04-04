# Streamlit app · Control + Workbench cockpit

App de Streamlit para **monitorizar y guiar** la interacción entre `control/` y `workbench/`.

## Qué hace
- Muestra el estado global del workflow y del workbench.
- Detecta qué artefacto se actualizó más recientemente.
- Orienta sobre qué prompt o actor conviene usar a continuación.
- Muestra la traza documental y, opcionalmente, actividad Git.
- Ayuda a inspeccionar el caso sin crear logs nuevos.

## Qué no hace por ahora
- No es el motor principal del bucle autónomo.
- No sustituye al chat de `control` en VS Code.
- No gobierna las iteraciones entre `control` y `workbench`.

## Papel correcto en el framework
La orquestación principal vive en **VS Code, desde `control`**, usando `workbench` como subagente.  
La app Streamlit queda como:
- cockpit visual;
- monitor del estado;
- guía de prompts y artefactos.

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
