from __future__ import annotations

import json
import re
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import pandas as pd

STATUS_ORDER = {"Pendiente": 0, "En curso": 1, "En revisión": 2, "Finalizado": 3}
WORKBENCH_STATUS_ORDER = {"Pendiente": 0, "En curso": 1, "En revisión": 2, "Finalizado": 3, "Ejecutado": 3}


@dataclass
class FileSnapshot:
    path: Path
    exists: bool
    mtime: float | None
    content: str | None


def read_text_if_exists(path: Path) -> str | None:
    if not path.exists() or not path.is_file():
        return None
    try:
        return path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return path.read_text(encoding="utf-8", errors="replace")


def snapshot(path: Path) -> FileSnapshot:
    exists = path.exists()
    mtime = path.stat().st_mtime if exists else None
    return FileSnapshot(path=path, exists=exists, mtime=mtime, content=read_text_if_exists(path))


def load_case_config(app_dir: Path) -> dict[str, Any]:
    path = app_dir / "case_config.json"
    if not path.exists():
        return {
            "case_title": app_dir.parent.name,
            "case_slug": app_dir.parent.name,
            "control_dir": "control",
            "workbench_dir": "workbench",
        }
    return json.loads(path.read_text(encoding="utf-8"))


def normalize_slug_to_title(slug: str) -> str:
    return slug.replace("-", " ").replace("_", " ").title()


def parse_control_workflow(md_text: str | None) -> pd.DataFrame:
    if not md_text:
        return pd.DataFrame(columns=["step_no", "step_name", "status", "close_date", "summary"])
    lines = md_text.splitlines()
    rows = []
    current = None
    summary_lines: list[str] = []
    for line in lines:
        m = re.match(r"^##\s+(\d+)\.\s+(.*)$", line.strip())
        if m:
            if current:
                current["summary"] = "\n".join(summary_lines).strip()
                rows.append(current)
            current = {
                "step_no": int(m.group(1)),
                "step_name": m.group(2).strip(),
                "status": "Pendiente",
                "close_date": "—",
            }
            summary_lines = []
            continue
        if current is None:
            continue
        stripped = line.strip()
        if stripped.startswith("- Estado:"):
            current["status"] = stripped.split(":", 1)[1].strip()
        elif stripped.startswith("- Fecha de cierre:"):
            current["close_date"] = stripped.split(":", 1)[1].strip()
        elif stripped.startswith("- ") and not stripped.startswith("- Estado") and not stripped.startswith("- Fecha"):
            summary_lines.append(stripped[2:])
    if current:
        current["summary"] = "\n".join(summary_lines).strip()
        rows.append(current)
    df = pd.DataFrame(rows)
    if not df.empty:
        df["status_order"] = df["status"].map(STATUS_ORDER).fillna(-1)
    return df


def parse_workbench_state(md_text: str | None) -> pd.DataFrame:
    if not md_text:
        return pd.DataFrame(columns=["step_no", "step_name", "global_status", "local_status", "last_execution", "notes"])
    lines = md_text.splitlines()
    rows = []
    current = None
    note_lines: list[str] = []
    for line in lines:
        m = re.match(r"^###\s+(\d+)\.\s+(.*)$", line.strip())
        if m:
            if current:
                current["notes"] = "\n".join(note_lines).strip()
                rows.append(current)
            current = {
                "step_no": int(m.group(1)),
                "step_name": m.group(2).strip(),
                "global_status": "Pendiente",
                "local_status": "Pendiente",
                "last_execution": "—",
            }
            note_lines = []
            continue
        if current is None:
            continue
        stripped = line.strip()
        if stripped.startswith("- Estado global heredado:"):
            current["global_status"] = stripped.split(":", 1)[1].strip()
        elif stripped.startswith("- Estado local en workbench:"):
            status = stripped.split(":", 1)[1].strip()
            if status == "Ejecutado":
                status = "Finalizado"
            current["local_status"] = status
        elif stripped.startswith("- Última ejecución:"):
            current["last_execution"] = stripped.split(":", 1)[1].strip()
        elif stripped.startswith("- ") and not stripped.startswith("- Estado") and not stripped.startswith("- Última"):
            note_lines.append(stripped[2:])
    if current:
        current["notes"] = "\n".join(note_lines).strip()
        rows.append(current)
    df = pd.DataFrame(rows)
    if not df.empty:
        df["local_status_order"] = df["local_status"].map(WORKBENCH_STATUS_ORDER).fillna(-1)
    return df


def infer_latest_actor(case_root: Path, control_dir: str, workbench_dir: str) -> dict[str, Any]:
    tracked = {
        "control/next_task.md": case_root / control_dir / "next_task.md",
        "control/review_notes.md": case_root / control_dir / "review_notes.md",
        "control/WORKFLOW_STATE.md": case_root / control_dir / "WORKFLOW_STATE.md",
        "workbench/task_result.md": case_root / workbench_dir / "task_result.md",
        "workbench/WORKBENCH_STATE.md": case_root / workbench_dir / "WORKBENCH_STATE.md",
    }
    rows = []
    for label, path in tracked.items():
        if path.exists():
            rows.append({
                "label": label,
                "mtime": path.stat().st_mtime,
                "actor": "control" if label.startswith("control/") else "workbench",
                "path": str(path),
            })
    if not rows:
        return {"latest_actor": "unknown", "next_actor": "control", "latest_file": None}
    rows.sort(key=lambda x: x["mtime"], reverse=True)
    latest = rows[0]
    next_actor = "workbench" if latest["actor"] == "control" else "control"
    if latest["label"] == "control/next_task.md":
        next_actor = "workbench"
    elif latest["label"] == "workbench/task_result.md":
        next_actor = "control"
    return {"latest_actor": latest["actor"], "next_actor": next_actor, "latest_file": latest}


def list_markdown_files(path: Path) -> list[Path]:
    if not path.exists():
        return []
    return sorted([p for p in path.rglob("*.md") if p.is_file()], key=lambda p: p.stat().st_mtime, reverse=True)


def list_prompt_files(case_root: Path, control_dir: str) -> list[Path]:
    prompt_dir = case_root / control_dir / ".github" / "prompts"
    if not prompt_dir.exists():
        return []
    return sorted(prompt_dir.glob("*.md"))


def read_git_activity(case_root: Path, limit: int = 30) -> pd.DataFrame:
    if not (case_root / ".git").exists():
        return pd.DataFrame(columns=["commit", "date", "author", "message", "files"])
    cmd = [
        "git", "-C", str(case_root), "log",
        f"--max-count={limit}",
        "--date=iso",
        "--pretty=format:%H%x1f%ad%x1f%an%x1f%s",
        "--name-only",
    ]
    try:
        out = subprocess.check_output(cmd, text=True, stderr=subprocess.DEVNULL)
    except Exception:
        return pd.DataFrame(columns=["commit", "date", "author", "message", "files"])
    rows = []
    current = None
    for line in out.splitlines():
        if "\x1f" in line:
            if current:
                rows.append(current)
            h, d, a, s = line.split("\x1f", 3)
            current = {"commit": h, "date": d, "author": a, "message": s, "files": []}
        elif line.strip():
            if current is not None:
                current["files"].append(line.strip())
    if current:
        rows.append(current)
    return pd.DataFrame(rows)


def progress_from_control(df: pd.DataFrame) -> tuple[int, int, float]:
    if df.empty:
        return 0, 0, 0.0
    total = len(df)
    done = int((df["status"] == "Finalizado").sum())
    return done, total, done / total if total else 0.0


def current_focus(control_df: pd.DataFrame, wb_df: pd.DataFrame) -> dict[str, Any]:
    if not control_df.empty:
        active = control_df[control_df["status"].isin(["En curso", "En revisión"])]
        if not active.empty:
            row = active.sort_values(["status_order", "step_no"], ascending=[False, True]).iloc[0]
            return {"step_no": int(row["step_no"]), "step_name": row["step_name"], "source": "control", "status": row["status"]}
    if not wb_df.empty:
        active = wb_df[wb_df["local_status"].isin(["En curso", "En revisión"])]
        if not active.empty:
            row = active.sort_values(["local_status_order", "step_no"], ascending=[False, True]).iloc[0]
            return {"step_no": int(row["step_no"]), "step_name": row["step_name"], "source": "workbench", "status": row["local_status"]}
    if not control_df.empty:
        pending = control_df[control_df["status"] == "Pendiente"]
        if not pending.empty:
            row = pending.sort_values("step_no").iloc[0]
            return {"step_no": int(row["step_no"]), "step_name": row["step_name"], "source": "control", "status": row["status"]}
    return {"step_no": None, "step_name": "No focus detected", "source": "n/a", "status": "n/a"}


def build_prompt_catalog(case_root: Path, control_dir: str, workbench_dir: str) -> dict[str, str]:
    prompts = {}
    mapping = {
        "control_bootstrap": case_root / control_dir / ".github" / "prompts" / "01_bootstrap_project.prompt.md",
        "control_review": case_root / control_dir / ".github" / "prompts" / "02_review_task_result.prompt.md",
        "control_next_task": case_root / control_dir / ".github" / "prompts" / "03_define_next_task.prompt.md",
        "control_human_review": case_root / control_dir / ".github" / "prompts" / "04_human_review_and_task_correction.prompt.md",
        "control_resume": case_root / control_dir / ".github" / "prompts" / "05_reopen_or_resume_from_state.prompt.md",
    }
    for key, path in mapping.items():
        txt = read_text_if_exists(path)
        if txt:
            prompts[key] = txt
    prompts.setdefault(
        "workbench_iterate",
        """Lee `control/next_task.md`, `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/WORKFLOW_STATE.md` y `workbench/WORKBENCH_STATE.md`.\n\nActúa como workbench del caso.\n\nDebes:\n- ejecutar la tarea pedida en `control/next_task.md`;\n- actualizar `workbench/WORKBENCH_STATE.md`;\n- dejar el resultado en `workbench/task_result.md`;\n- usar rutas relativas a la raíz del caso;\n- no modificar `control/WORKFLOW_STATE.md`.""",
    )
    prompts.setdefault(
        "control_modify_specs",
        """Lee `control/PROJECT_TECHNICAL_REQUIREMENTS.md`, `control/review_notes.md`, `workbench/task_result.md` y `control/WORKFLOW_STATE.md`.\n\nActúa como control plane del caso.\n\nDebes:\n- actualizar las especificaciones técnicas o funcionales si la revisión humana lo requiere;\n- reflejar el cambio en `control/PROJECT_TECHNICAL_REQUIREMENTS.md`;\n- escribir la nueva instrucción operativa en `control/next_task.md`;\n- actualizar `control/WORKFLOW_STATE.md` antes de pasar a workbench.""",
    )
    return prompts
