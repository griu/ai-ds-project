#!/usr/bin/env bash
# SPDX-License-Identifier: LGPL-3.0-or-later
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  bash demo/scripts/create_case_instance.sh <master_repo> <case_slug> [target_parent_dir]

Argumentos:
  <master_repo>        Ruta al repo maestro ai-ds-project
  <case_slug>          Nombre del caso a instanciar, por ejemplo: home-credit
  [target_parent_dir]  Directorio padre donde crear el caso.
                       Si no se informa, se usa el directorio padre de <master_repo>.
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

# Legacy local virtual envs if any
control/.venv/
workbench/.venv/

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
  local case_slug="$2"

  cat > "$target_repo/README.md" <<EOF2
<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# ${case_slug}

Proyecto instanciado a partir de \`ai-ds-project\`.

## Estructura
- \`control/\`: define y revisa la siguiente tarea.
- \`workbench/\`: ejecuta la tarea y devuelve resultado.

## Workspaces
- \`control.code-workspace\`
- \`workbench.code-workspace\`

Ambos workspaces abren la **misma raíz del proyecto del caso**.

## Documentos clave
- \`control/DEMO_WORKFLOW_STANDARD.md\`
- \`control/PROJECT_TECHNICAL_REQUIREMENTS.md\`
- \`control/WORKFLOW_STATE.md\`
- \`workbench/WORKBENCH_STATE.md\`

## Flujo operativo
1. Abre \`control.code-workspace\`.
2. Abre \`workbench.code-workspace\`.
3. En la ventana de \`control\`, trabaja con rutas relativas a la raíz del caso:
   - \`control/next_task.md\`
   - \`control/review_notes.md\`
   - \`control/WORKFLOW_STATE.md\`
   - \`workbench/WORKBENCH_STATE.md\`
   - \`workbench/task_result.md\`
4. En la ventana de \`workbench\`, trabaja también con rutas relativas a la raíz del caso:
   - \`control/next_task.md\`
   - \`control/PROJECT_TECHNICAL_REQUIREMENTS.md\`
   - \`control/WORKFLOW_STATE.md\`
   - \`workbench/WORKBENCH_STATE.md\`
   - \`workbench/task_result.md\`
   - \`workbench/docs/\`

## Entorno técnico
- Formato preferido de dependencias: \`pyproject.toml\`.
- Entorno virtual local del proyecto: \`.venv/\` en la raíz del repo del caso.
EOF2
}

copy_license_files_if_present() {
  local master_repo="$1"
  local target_repo="$2"

  if [[ -f "$master_repo/COPYING.LESSER" ]]; then
    cp "$master_repo/COPYING.LESSER" "$target_repo/COPYING.LESSER"
  fi

  if [[ -f "$master_repo/COPYING" ]]; then
    cp "$master_repo/COPYING" "$target_repo/COPYING"
  fi
}

main() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ $# -lt 2 || $# -gt 3 ]]; then
    usage
    exit 1
  fi

  local MASTER_REPO="$1"
  local CASE_SLUG="$2"
  local TARGET_PARENT_DIR="${3:-$(dirname "$MASTER_REPO")}"

  local CONTROL_TEMPLATE="$MASTER_REPO/templates/control"
  local WORKBENCH_TEMPLATE="$MASTER_REPO/templates/workbench"

  local CASE_OVERLAY_BASE="$MASTER_REPO/demo/cases/$CASE_SLUG"
  local CONTROL_OVERLAY="$CASE_OVERLAY_BASE/control"
  local WORKBENCH_OVERLAY="$CASE_OVERLAY_BASE/workbench"

  local TARGET_REPO="$TARGET_PARENT_DIR/$CASE_SLUG"
  local TARGET_CONTROL="$TARGET_REPO/control"
  local TARGET_WORKBENCH="$TARGET_REPO/workbench"

  [[ -d "$MASTER_REPO" ]] || { echo "ERROR: no existe master_repo: $MASTER_REPO" >&2; exit 1; }
  [[ -d "$CONTROL_TEMPLATE" ]] || { echo "ERROR: no existe templates/control: $CONTROL_TEMPLATE" >&2; exit 1; }
  [[ -d "$WORKBENCH_TEMPLATE" ]] || { echo "ERROR: no existe templates/workbench: $WORKBENCH_TEMPLATE" >&2; exit 1; }
  [[ -d "$TARGET_PARENT_DIR" ]] || { echo "ERROR: no existe target_parent_dir: $TARGET_PARENT_DIR" >&2; exit 1; }

  if [[ -e "$TARGET_REPO" ]]; then
    echo "ERROR: el destino ya existe: $TARGET_REPO" >&2
    exit 1
  fi

  echo ">>> Creando repo destino: $TARGET_REPO"
  mkdir -p "$TARGET_CONTROL" "$TARGET_WORKBENCH"

  echo ">>> Copiando plantilla de control"
  copy_dir_contents "$CONTROL_TEMPLATE" "$TARGET_CONTROL"

  echo ">>> Copiando plantilla de workbench"
  copy_dir_contents "$WORKBENCH_TEMPLATE" "$TARGET_WORKBENCH"

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

  echo ">>> Copiando licencias del scaffold si existen"
  copy_license_files_if_present "$MASTER_REPO" "$TARGET_REPO"

  echo ">>> Creando .gitignore raíz"
  write_root_gitignore "$TARGET_REPO"

  echo ">>> Creando README raíz"
  write_root_readme "$TARGET_REPO" "$CASE_SLUG"

  echo ">>> Creando workspaces de VS Code"
  write_workspace_file "$TARGET_REPO" "control.code-workspace" "$CASE_SLUG · control"
  write_workspace_file "$TARGET_REPO" "workbench.code-workspace" "$CASE_SLUG · workbench"

  echo ">>> Inicializando un único repositorio Git en la raíz del caso"
  git -c init.defaultBranch=main init "$TARGET_REPO"
  git -C "$TARGET_REPO" add .
  git -C "$TARGET_REPO" commit -m "Initialize case $CASE_SLUG from ai-ds-project template"

  echo
  echo ">>> Caso creado correctamente"
  echo "Repo:                $TARGET_REPO"
  echo "Control workspace:   $TARGET_REPO/control.code-workspace"
  echo "Workbench workspace: $TARGET_REPO/workbench.code-workspace"
  echo "Control dir:         $TARGET_CONTROL"
  echo "Workbench dir:       $TARGET_WORKBENCH"
}

main "$@"
