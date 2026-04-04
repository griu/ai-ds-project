#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  bash demo/scripts/create_case_instance.sh <master_repo> <case_slug> [target_parent_dir] [target_repo_name]
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
**/__pycache__/
**/*.pyc
**/.pytest_cache/
**/.ruff_cache/
.venv/
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
  local case_slug="$2"
  cat > "$target_repo/README.md" <<EOF2
# ${case_slug}

Proyecto instanciado a partir de ai-ds-project.

## Estructura
- \\`control/\\`: define y revisa la siguiente tarea.
- \\`workbench/\\`: ejecuta la tarea y devuelve resultado.
- \\`app/\\`: cockpit visual de control + workbench en Streamlit.
EOF2
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

  mkdir -p "$TARGET_CONTROL" "$TARGET_WORKBENCH" "$TARGET_APP"
  copy_dir_contents "$CONTROL_TEMPLATE" "$TARGET_CONTROL"
  copy_dir_contents "$WORKBENCH_TEMPLATE" "$TARGET_WORKBENCH"
  if [[ -d "$APP_TEMPLATE" ]]; then
    copy_dir_contents "$APP_TEMPLATE" "$TARGET_APP"
  fi
  if [[ -d "$CONTROL_OVERLAY" ]]; then copy_dir_contents "$CONTROL_OVERLAY" "$TARGET_CONTROL"; fi
  if [[ -d "$WORKBENCH_OVERLAY" ]]; then copy_dir_contents "$WORKBENCH_OVERLAY" "$TARGET_WORKBENCH"; fi

  remove_nested_git_dirs "$TARGET_REPO"
  write_root_gitignore "$TARGET_REPO"
  write_root_readme "$TARGET_REPO" "$CASE_SLUG"
  write_workspace_file "$TARGET_REPO" "control.code-workspace" "$TARGET_REPO_NAME · control"
  write_workspace_file "$TARGET_REPO" "workbench.code-workspace" "$TARGET_REPO_NAME · workbench"
  write_workspace_file "$TARGET_REPO" "app.code-workspace" "$TARGET_REPO_NAME · app"
  write_app_case_config "$TARGET_APP" "$TARGET_REPO_NAME" "$CASE_SLUG"

  git -c init.defaultBranch=main init "$TARGET_REPO"
  git -C "$TARGET_REPO" add .
  git -C "$TARGET_REPO" commit -m "Initialize case $TARGET_REPO_NAME (overlay: $CASE_SLUG) from ai-ds-project template"

  echo "Repo: $TARGET_REPO"
  echo "App workspace: $TARGET_REPO/app.code-workspace"
  echo "Run app: bash $TARGET_REPO/app/run_streamlit.sh 8501"
}

main "$@"
