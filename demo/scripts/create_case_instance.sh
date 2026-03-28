#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  bash demo/scripts/create_case_instance.sh <master_repo> <case_slug> <target_parent_dir>

Ejemplo:
  bash demo/scripts/create_case_instance.sh \
    /home/griu/git/ai-ds-project \
    home-credit \
    /home/griu/git

Resultado:
  /home/griu/git/home-credit/
    ├─ .git
    ├─ .gitignore
    ├─ home-credit.code-workspace
    ├─ control/
    └─ workbench/
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

# Local virtual envs
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
  local case_slug="$2"

  cat > "$target_repo/$case_slug.code-workspace" <<EOF2
{
  "folders": [
    { "name": "control", "path": "control" },
    { "name": "workbench", "path": "workbench" }
  ],
  "settings": {}
}
EOF2
}

write_root_readme() {
  local target_repo="$1"
  local case_slug="$2"

  cat > "$target_repo/README.md" <<EOF2
# ${case_slug}

Proyecto instanciado a partir de \`ai-ds-project\`.

## Estructura
- \`control/\`: define y revisa la siguiente tarea.
- \`workbench/\`: ejecuta la tarea y devuelve resultado.

## Flujo operativo
1. Abre \`control/\` en una ventana de VS Code.
2. Abre \`workbench/\` en otra ventana de VS Code.
3. En \`control/\`, redacta o actualiza \`next_task.md\`.
4. En \`workbench/\`, usa como fuente de verdad \`../control/next_task.md\`.
5. En \`workbench/\`, actualiza \`task_result.md\`.
6. En \`control/\`, revisa \`../workbench/task_result.md\` y define el siguiente paso.

## Workspace recomendado
- \`${case_slug}.code-workspace\`
EOF2
}

main() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ $# -ne 3 ]]; then
    usage
    exit 1
  fi

  local MASTER_REPO="$1"
  local CASE_SLUG="$2"
  local TARGET_PARENT_DIR="$3"

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

  echo ">>> Creando .gitignore raíz"
  write_root_gitignore "$TARGET_REPO"

  echo ">>> Creando README raíz"
  write_root_readme "$TARGET_REPO" "$CASE_SLUG"

  echo ">>> Creando workspace de VS Code"
  write_workspace_file "$TARGET_REPO" "$CASE_SLUG"

  echo ">>> Inicializando un único repositorio Git en la raíz del caso"
  git -c init.defaultBranch=main init "$TARGET_REPO"
  git -C "$TARGET_REPO" add .
  git -C "$TARGET_REPO" commit -m "Initialize case $CASE_SLUG from ai-ds-project template"

  echo
  echo ">>> Caso creado correctamente"
  echo "Repo:      $TARGET_REPO"
  echo "Control:   $TARGET_CONTROL"
  echo "Workbench: $TARGET_WORKBENCH"
  echo "Workspace: $TARGET_REPO/$CASE_SLUG.code-workspace"
}

main "$@"
