#!/usr/bin/env bash
# SPDX-License-Identifier: LGPL-3.0-or-later
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  bash demo/scripts/create_case_instance.sh <master_repo> <case_slug> [target_parent_dir] [target_repo_name]

Argumentos:
  <master_repo>        Ruta al repo maestro ai-ds-project
  <case_slug>          Nombre del overlay del caso, por ejemplo: home-credit
  [target_parent_dir]  Directorio padre donde crear el caso. Si no se informa, se usa el padre de <master_repo>.
  [target_repo_name]   Nombre real del repo de salida. Si no se informa, se usa <case_slug>.
USAGE
}

copy_dir_contents() {
  local src="$1"
  local dst="$2"
  mkdir -p "$dst"
  cp -a "$src"/. "$dst"/
}

remove_nested_git_dirs() {
  local path="$1"
  find "$path" -type d -name .git -prune -exec rm -rf {} + 2>/dev/null || true
}

write_root_gitignore() {
  local target_repo="$1"
  cat > "$target_repo/.gitignore" <<'GITIGNORE'
# Python
**/__pycache__/
**/*.pyc
**/.pytest_cache/
**/.mypy_cache/
**/.ruff_cache/

# Project virtual environment
.venv/

# Jupyter
**/.ipynb_checkpoints/

# Editor / OS
.vscode/
.DS_Store
Thumbs.db
GITIGNORE
}

write_workspace_file() {
  local target_repo="$1"
  local workspace_name="$2"
  local window_title="$3"
  cat > "$target_repo/$workspace_name" <<EOF2
{
  "folders": [
    { "name": "case-root", "path": "." }
  ],
  "settings": {
    "window.title": "$window_title"
  }
}
EOF2
}

write_root_readme() {
  local target_repo="$1"
  local target_repo_name="$2"
  cat > "$target_repo/README.md" <<EOF2
<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# ${target_repo_name}

Proyecto instanciado a partir de \`ai-ds-project\`.

## Estructura
- \`control/\`: define y revisa la siguiente tarea.
- \`workbench/\`: ejecuta la tarea y devuelve resultado.
- \`app/\`: cockpit visual Streamlit para seguir el flujo.

## Workspaces
- \`control.code-workspace\`
- \`workbench.code-workspace\`
- \`app.code-workspace\`

Todos los workspaces abren la **misma raíz del proyecto del caso**.

## Documentos clave
- \`control/DEMO_WORKFLOW_STANDARD.md\`
- \`control/PROJECT_TECHNICAL_REQUIREMENTS.md\`
- \`control/WORKFLOW_STATE.md\`
- \`control/AUTOMATION_POLICY.md\`
- \`workbench/WORKBENCH_STATE.md\`

## Flujo operativo
1. Abre \`control.code-workspace\`.
2. Abre \`workbench.code-workspace\`.
3. Abre \`app.code-workspace\` si quieres cockpit visual.
EOF2
}

copy_license_files_if_present() {
  local master_repo="$1"
  local target_repo="$2"
  [[ -f "$master_repo/COPYING.LESSER" ]] && cp "$master_repo/COPYING.LESSER" "$target_repo/COPYING.LESSER"
  [[ -f "$master_repo/COPYING" ]] && cp "$master_repo/COPYING" "$target_repo/COPYING"
}

write_app_case_config() {
  local target_app="$1"
  local case_title="$2"
  local case_slug="$3"
  cat > "$target_app/case_config.json" <<EOF2
{
  "case_title": "$case_title",
  "case_slug": "$case_slug",
  "control_dir": "control",
  "workbench_dir": "workbench"
}
EOF2
}

main() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi
  if [[ $# -lt 2 || $# -gt 4 ]]; then
    usage
    exit 1
  fi

  local MASTER_REPO="$1"
  local CASE_SLUG="$2"
  local TARGET_PARENT_DIR="${3:-$(dirname "$MASTER_REPO")}"
  local TARGET_REPO_NAME="${4:-$CASE_SLUG}"

  local CONTROL_TEMPLATE="$MASTER_REPO/templates/control"
  local WORKBENCH_TEMPLATE="$MASTER_REPO/templates/workbench"
  local APP_TEMPLATE="$MASTER_REPO/templates/app"

  local CASE_OVERLAY_BASE="$MASTER_REPO/demo/cases/$CASE_SLUG"
  local CONTROL_OVERLAY="$CASE_OVERLAY_BASE/control"
  local WORKBENCH_OVERLAY="$CASE_OVERLAY_BASE/workbench"

  local TARGET_REPO="$TARGET_PARENT_DIR/$TARGET_REPO_NAME"
  local TARGET_CONTROL="$TARGET_REPO/control"
  local TARGET_WORKBENCH="$TARGET_REPO/workbench"
  local TARGET_APP="$TARGET_REPO/app"

  [[ -d "$MASTER_REPO" ]] || { echo "ERROR: no existe master_repo: $MASTER_REPO" >&2; exit 1; }
  [[ -d "$CONTROL_TEMPLATE" ]] || { echo "ERROR: no existe templates/control: $CONTROL_TEMPLATE" >&2; exit 1; }
  [[ -d "$WORKBENCH_TEMPLATE" ]] || { echo "ERROR: no existe templates/workbench: $WORKBENCH_TEMPLATE" >&2; exit 1; }
  [[ -d "$TARGET_PARENT_DIR" ]] || { echo "ERROR: no existe target_parent_dir: $TARGET_PARENT_DIR" >&2; exit 1; }
  if [[ -e "$TARGET_REPO" ]]; then
    echo "ERROR: el destino ya existe: $TARGET_REPO" >&2
    exit 1
  fi

  echo ">>> Creando repo destino: $TARGET_REPO"
  mkdir -p "$TARGET_CONTROL" "$TARGET_WORKBENCH" "$TARGET_APP"

  echo ">>> Copiando plantilla de control"
  copy_dir_contents "$CONTROL_TEMPLATE" "$TARGET_CONTROL"
  echo ">>> Copiando plantilla de workbench"
  copy_dir_contents "$WORKBENCH_TEMPLATE" "$TARGET_WORKBENCH"
  if [[ -d "$APP_TEMPLATE" ]]; then
    echo ">>> Copiando plantilla de app"
    copy_dir_contents "$APP_TEMPLATE" "$TARGET_APP"
  fi

  if [[ -d "$CONTROL_OVERLAY" ]]; then
    echo ">>> Aplicando overlay de control para el caso: $CASE_SLUG"
    copy_dir_contents "$CONTROL_OVERLAY" "$TARGET_CONTROL"
  else
    echo ">>> Sin overlay específico de control para el caso: $CASE_SLUG"
  fi
  if [[ -d "$WORKBENCH_OVERLAY" ]]; then
    echo ">>> Aplicando overlay de workbench para el caso: $CASE_SLUG"
    copy_dir_contents "$WORKBENCH_OVERLAY" "$TARGET_WORKBENCH"
  else
    echo ">>> Sin overlay específico de workbench para el caso: $CASE_SLUG"
  fi

  echo ">>> Eliminando posibles .git heredados dentro del contenido copiado"
  remove_nested_git_dirs "$TARGET_REPO"
  copy_license_files_if_present "$MASTER_REPO" "$TARGET_REPO"
  write_root_gitignore "$TARGET_REPO"
  write_root_readme "$TARGET_REPO" "$TARGET_REPO_NAME"
  write_workspace_file "$TARGET_REPO" "control.code-workspace" "$TARGET_REPO_NAME · control"
  write_workspace_file "$TARGET_REPO" "workbench.code-workspace" "$TARGET_REPO_NAME · workbench"
  write_workspace_file "$TARGET_REPO" "app.code-workspace" "$TARGET_REPO_NAME · app"
  [[ -d "$TARGET_APP" ]] && write_app_case_config "$TARGET_APP" "$TARGET_REPO_NAME" "$CASE_SLUG"

  git -c init.defaultBranch=main init "$TARGET_REPO"
  git -C "$TARGET_REPO" add .
  git -C "$TARGET_REPO" commit -m "Initialize case $TARGET_REPO_NAME (overlay: $CASE_SLUG) from ai-ds-project template"

  echo
  echo ">>> Caso creado correctamente"
  echo "Repo:                $TARGET_REPO"
  echo "Control workspace:   $TARGET_REPO/control.code-workspace"
  echo "Workbench workspace: $TARGET_REPO/workbench.code-workspace"
  echo "App workspace:       $TARGET_REPO/app.code-workspace"
  echo "Run app:             bash $TARGET_REPO/app/run_streamlit.sh 8501"
}

main "$@"
