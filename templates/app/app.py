from __future__ import annotations

from datetime import datetime
from pathlib import Path
import json

import pandas as pd
import streamlit as st

from lib.repo_state import (
    build_prompt_catalog,
    current_focus,
    infer_latest_actor,
    list_markdown_files,
    list_prompt_files,
    load_case_config,
    normalize_slug_to_title,
    parse_control_workflow,
    parse_workbench_state,
    progress_from_control,
    read_git_activity,
    read_text_if_exists,
)

st.set_page_config(
    page_title="AI DS Orchestration Cockpit",
    page_icon="🧭",
    layout="wide",
    initial_sidebar_state="expanded",
)

CUSTOM_CSS = """
<style>
.kpi-card {
  background: linear-gradient(135deg, rgba(102,217,239,0.12), rgba(16,185,129,0.10));
  border: 1px solid rgba(148,163,184,0.22);
  padding: 16px 18px;
  border-radius: 16px;
  min-height: 110px;
}
.kpi-title {font-size: 0.85rem; color: #94a3b8; margin-bottom: 0.35rem;}
.kpi-value {font-size: 1.8rem; font-weight: 700;}
.kpi-sub {font-size: 0.9rem; color: #cbd5e1; margin-top: 0.4rem;}
.small-note {color:#94a3b8; font-size:0.85rem;}
.prompt-box textarea {font-family: ui-monospace, SFMono-Regular, Menlo, monospace !important;}
</style>
"""
st.markdown(CUSTOM_CSS, unsafe_allow_html=True)

app_dir = Path(__file__).resolve().parent
case_root = app_dir.parent
cfg = load_case_config(app_dir)
case_title = cfg.get("case_title") or normalize_slug_to_title(cfg.get("case_slug", case_root.name))
control_dir = cfg.get("control_dir", "control")
workbench_dir = cfg.get("workbench_dir", "workbench")

control_path = case_root / control_dir
workbench_path = case_root / workbench_dir

control_workflow_md = read_text_if_exists(control_path / "WORKFLOW_STATE.md")
workbench_state_md = read_text_if_exists(workbench_path / "WORKBENCH_STATE.md")
next_task_md = read_text_if_exists(control_path / "next_task.md")
review_notes_md = read_text_if_exists(control_path / "review_notes.md")
task_result_md = read_text_if_exists(workbench_path / "task_result.md")
project_context_md = read_text_if_exists(control_path / "project_context.md")
jury_goals_md = read_text_if_exists(control_path / "jury_and_demo_goals.md")
tech_req_md = read_text_if_exists(control_path / "PROJECT_TECHNICAL_REQUIREMENTS.md")
demo_workflow_md = read_text_if_exists(control_path / "DEMO_WORKFLOW_STANDARD.md")
automation_policy_md = read_text_if_exists(control_path / "AUTOMATION_POLICY.md")

control_df = parse_control_workflow(control_workflow_md)
wb_df = parse_workbench_state(workbench_state_md)
done, total, progress = progress_from_control(control_df)
activity = infer_latest_actor(case_root, control_dir, workbench_dir)
focus = current_focus(control_df, wb_df)
prompts = build_prompt_catalog(case_root, control_dir, workbench_dir)
git_df = read_git_activity(case_root, limit=30)

st.sidebar.title("🧭 Orchestration Cockpit")
st.sidebar.markdown(f"**Case**: {case_title}")
st.sidebar.markdown(f"**Repo root**: `{case_root}`")
selected_tab = st.sidebar.radio(
    "Navegació",
    [
        "Cockpit",
        "Prompt Studio",
        "Artifacts Explorer",
        "Workflow Maps",
        "History & Results",
        "Operational Guide",
    ],
)
refresh = st.sidebar.button("🔄 Refresh state")
if refresh:
    st.rerun()

st.title(f"🧠 {case_title} · Control + Workbench")
st.caption("Orquestració visual del flux del cas, reutilitzant els markdowns i l’històric propi del repo sense generar logs nous.")

c1, c2, c3, c4 = st.columns(4)
with c1:
    st.markdown(
        f"<div class='kpi-card'><div class='kpi-title'>Progress global</div><div class='kpi-value'>{done}/{total}</div><div class='kpi-sub'>{progress:.0%} steps finalitzats</div></div>",
        unsafe_allow_html=True,
    )
with c2:
    latest_actor = activity["latest_actor"].capitalize() if activity.get("latest_actor") else "Unknown"
    latest_file = activity.get("latest_file", {})
    latest_label = latest_file.get("label", "—") if latest_file else "—"
    st.markdown(
        f"<div class='kpi-card'><div class='kpi-title'>Últim agent que ha respost</div><div class='kpi-value'>{latest_actor}</div><div class='kpi-sub'>{latest_label}</div></div>",
        unsafe_allow_html=True,
    )
with c3:
    st.markdown(
        f"<div class='kpi-card'><div class='kpi-title'>Següent agent a gestionar</div><div class='kpi-value'>{activity['next_actor'].capitalize()}</div><div class='kpi-sub'>Segons l’últim artifact actualitzat</div></div>",
        unsafe_allow_html=True,
    )
with c4:
    focus_label = f"{focus['step_no']}. {focus['step_name']}" if focus.get("step_no") else focus["step_name"]
    st.markdown(
        f"<div class='kpi-card'><div class='kpi-title'>Focus actual</div><div class='kpi-value' style='font-size:1.1rem'>{focus_label}</div><div class='kpi-sub'>{focus['source']} · {focus['status']}</div></div>",
        unsafe_allow_html=True,
    )

if selected_tab == "Cockpit":
    left, right = st.columns([1.15, 0.85])
    with left:
        st.subheader("Workflow status board")
        if not control_df.empty:
            df = control_df[["step_no", "step_name", "status", "close_date"]].copy()
            df.columns = ["Step", "Name", "Status", "Close date"]
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info("No s’ha pogut parsejar `control/WORKFLOW_STATE.md`.")

        st.subheader("Workbench execution board")
        if not wb_df.empty:
            df2 = wb_df[["step_no", "step_name", "global_status", "local_status", "last_execution"]].copy()
            df2.columns = ["Step", "Name", "Global", "Workbench", "Last execution"]
            st.dataframe(df2, use_container_width=True, hide_index=True)
        else:
            st.info("No s’ha pogut parsejar `workbench/WORKBENCH_STATE.md`.")

    with right:
        st.subheader("Next move recommendation")
        actor = activity["next_actor"]
        if actor == "workbench":
            st.success("Següent moviment recomanat: **engegar Workbench** amb el prompt genèric d’iteració.")
            st.code(prompts.get("workbench_iterate", "No prompt available"), language="markdown")
        else:
            st.info("Següent moviment recomanat: **engegar Control** per revisar resultat i decidir la següent tasca.")
            st.code(prompts.get("control_review") or prompts.get("control_next_task", "No prompt available"), language="markdown")

        st.subheader("Latest artifacts")
        artifact_rows = []
        for rel in [
            f"{control_dir}/next_task.md",
            f"{control_dir}/review_notes.md",
            f"{control_dir}/WORKFLOW_STATE.md",
            f"{control_dir}/AUTOMATION_POLICY.md",
            f"{workbench_dir}/task_result.md",
            f"{workbench_dir}/WORKBENCH_STATE.md",
        ]:
            p = case_root / rel
            if p.exists():
                artifact_rows.append({
                    "Artifact": rel,
                    "Last update": datetime.fromtimestamp(p.stat().st_mtime).strftime("%Y-%m-%d %H:%M:%S"),
                    "KB": round(p.stat().st_size / 1024, 1),
                })
        if artifact_rows:
            st.dataframe(pd.DataFrame(artifact_rows), use_container_width=True, hide_index=True)

elif selected_tab == "Prompt Studio":
    st.subheader("Prompt Studio")
    st.caption("Pensat per copy/paste ràpid i edició directa del prompt abans de llançar-lo a l’agent correcte.")
    prompt_key = st.selectbox(
        "Prompt preset",
        options=list(prompts.keys()),
        format_func=lambda x: x.replace("_", " ").title(),
    )
    seed_text = prompts[prompt_key]

    helper_context = st.text_input(
        "Context extra opcional",
        placeholder="Ex: reobrir a l’estat 08, incorporar noves restriccions, prioritzar explicabilitat...",
    )
    final_prompt = seed_text if not helper_context else f"{seed_text}\n\nContext addicional de la iteració:\n{helper_context}\n"

    edited = st.text_area("Editable prompt", value=final_prompt, height=360, key="prompt_editor")
    st.code(edited, language="markdown")
    st.download_button(
        "⬇️ Download prompt.txt",
        data=edited.encode("utf-8"),
        file_name=f"{prompt_key}.txt",
        mime="text/plain",
    )
    st.markdown("**Prompt files detectats al repo**")
    pf = list_prompt_files(case_root, control_dir)
    if pf:
        for p in pf:
            st.markdown(f"- `{p.relative_to(case_root)}`")
    else:
        st.info("No s’han trobat prompt files al repo del cas.")

elif selected_tab == "Artifacts Explorer":
    st.subheader("Artifacts Explorer")
    artifact_map = {
        "control/next_task.md": next_task_md,
        "control/review_notes.md": review_notes_md,
        "control/WORKFLOW_STATE.md": control_workflow_md,
        "workbench/task_result.md": task_result_md,
        "workbench/WORKBENCH_STATE.md": workbench_state_md,
        "control/project_context.md": project_context_md,
        "control/jury_and_demo_goals.md": jury_goals_md,
        "control/PROJECT_TECHNICAL_REQUIREMENTS.md": tech_req_md,
        "control/DEMO_WORKFLOW_STANDARD.md": demo_workflow_md,
        "control/AUTOMATION_POLICY.md": automation_policy_md,
    }
    artifact_name = st.selectbox("Artifact", list(artifact_map.keys()))
    content = artifact_map[artifact_name]
    if content:
        mode = st.radio("View mode", ["Rendered markdown", "Raw"], horizontal=True)
        if mode == "Rendered markdown":
            st.markdown(content)
        else:
            st.code(content, language="markdown")
    else:
        st.warning("Artifact buit o no trobat.")

elif selected_tab == "Workflow Maps":
    st.subheader("Workflow maps")
    cc1, cc2 = st.columns(2)
    with cc1:
        st.markdown("### Control flow")
        if not control_df.empty:
            status_counts = control_df.groupby("status").size().rename("count").reset_index()
            st.dataframe(status_counts, use_container_width=True, hide_index=True)
            st.progress(progress)
        st.markdown("### Current focus card")
        st.info(f"**{focus.get('step_no', '—')} · {focus['step_name']}**\n\nSource: {focus['source']}\n\nStatus: {focus['status']}")
    with cc2:
        st.markdown("### Workbench local flow")
        if not wb_df.empty:
            status_counts = wb_df.groupby("local_status").size().rename("count").reset_index()
            st.dataframe(status_counts, use_container_width=True, hide_index=True)
        sync_df = pd.DataFrame([
            {
                "Control steps": len(control_df) if not control_df.empty else 0,
                "Workbench steps": len(wb_df) if not wb_df.empty else 0,
                "Latest actor": activity["latest_actor"],
                "Next actor": activity["next_actor"],
            }
        ])
        st.dataframe(sync_df, use_container_width=True, hide_index=True)

elif selected_tab == "History & Results":
    st.subheader("History & Results")
    h1, h2 = st.columns(2)
    with h1:
        st.markdown("### Control history")
        control_history = list_markdown_files(control_path / "history")
        if control_history:
            for p in control_history[:20]:
                st.markdown(f"- `{p.relative_to(case_root)}` · {datetime.fromtimestamp(p.stat().st_mtime).strftime('%Y-%m-%d %H:%M:%S')}")
        else:
            st.caption("No hi ha markdowns a `control/history/`.")

        st.markdown("### Workbench history")
        wb_history = list_markdown_files(workbench_path / "history")
        if wb_history:
            for p in wb_history[:20]:
                st.markdown(f"- `{p.relative_to(case_root)}` · {datetime.fromtimestamp(p.stat().st_mtime).strftime('%Y-%m-%d %H:%M:%S')}")
        else:
            st.caption("No hi ha markdowns a `workbench/history/`.")

    with h2:
        st.markdown("### Git activity")
        if not git_df.empty:
            display = git_df[["date", "author", "message"]].copy()
            st.dataframe(display, use_container_width=True, hide_index=True)
            with st.expander("Show touched files by commit"):
                for _, row in git_df.iterrows():
                    st.markdown(f"**{row['date']} · {row['author']}** — {row['message']}")
                    for f in row["files"][:25]:
                        st.markdown(f"- `{f}`")
        else:
            st.caption("No s’ha pogut llegir activitat Git o el repo no té `.git`.")

        st.markdown("### Latest result snapshot")
        if task_result_md:
            st.markdown(task_result_md[:8000])
        else:
            st.caption("`workbench/task_result.md` buit o no disponible.")

elif selected_tab == "Operational Guide":
    st.subheader("Operational Guide")
    st.markdown(
        """
### Com operar l’eina
1. Mira **Latest actor** i **Next actor** al cockpit.
2. Obre **Prompt Studio** i selecciona el preset adequat.
3. Copia/adapta el prompt amb el context humà de la iteració.
4. Revisa **Artifacts Explorer** per veure el `next_task.md`, `task_result.md` i els estats.
5. Consulta **History & Results** per tenir traçabilitat sense generar logs nous.

### Port i múltiples instàncies
Cada cas pot tenir la seva pròpia app dins de `app/`.
Executa-la des del repo del cas amb un port diferent per instància.

Exemples:
- Cas A → `bash app/run_streamlit.sh 8501`
- Cas B → `bash app/run_streamlit.sh 8502`
- Cas C → `bash app/run_streamlit.sh 8503`

### Instal·lació mínima
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r app/requirements.txt
bash app/run_streamlit.sh 8501
```

### Disseny de dades que consumeix l’app
L’app llegeix directament:
- `control/WORKFLOW_STATE.md`
- `control/next_task.md`
- `control/review_notes.md`
- `control/PROJECT_TECHNICAL_REQUIREMENTS.md`
- `control/DEMO_WORKFLOW_STANDARD.md`
- `control/AUTOMATION_POLICY.md`
- `workbench/WORKBENCH_STATE.md`
- `workbench/task_result.md`
- `control/history/**/*.md`
- `workbench/history/**/*.md`
- Git history si el repo és Git

No genera cap log propi del flux de negoci.
"""
    )
