#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 5 ]]; then
  echo "Uso: $0 <ROOT_DIR> <CASE_SLUG> <CONTROL_TEMPLATE> <WORKBENCH_TEMPLATE> <CASEPACK_DIR>"
  exit 1
fi

ROOT_DIR="$1"
CASE_SLUG="$2"
CONTROL_TEMPLATE="$3"
WORKBENCH_TEMPLATE="$4"
CASEPACK_DIR="$5"

CONTROL_REPO="${ROOT_DIR}/${CASE_SLUG}-control"
WORKBENCH_REPO="${ROOT_DIR}/${CASE_SLUG}-workbench"

mkdir -p "$ROOT_DIR"
[[ ! -e "$CONTROL_REPO" ]] || { echo "Ya existe $CONTROL_REPO"; exit 2; }
[[ ! -e "$WORKBENCH_REPO" ]] || { echo "Ya existe $WORKBENCH_REPO"; exit 2; }

cp -R "$CONTROL_TEMPLATE" "$CONTROL_REPO"
cp -R "$WORKBENCH_TEMPLATE" "$WORKBENCH_REPO"
cp -R "$CASEPACK_DIR/control_seed/." "$CONTROL_REPO/"
cp -R "$CASEPACK_DIR/workbench_seed/." "$WORKBENCH_REPO/"
find "$CONTROL_REPO" "$WORKBENCH_REPO" -type d -name .git -prune -exec rm -rf {} + 2>/dev/null || true

git -C "$CONTROL_REPO" init
git -C "$CONTROL_REPO" checkout -b main
git -C "$CONTROL_REPO" add .
git -C "$CONTROL_REPO" commit -m "Initialize ${CASE_SLUG} control repo from template"

git -C "$WORKBENCH_REPO" init
git -C "$WORKBENCH_REPO" checkout -b main
git -C "$WORKBENCH_REPO" add .
git -C "$WORKBENCH_REPO" commit -m "Initialize ${CASE_SLUG} workbench repo from template"

echo "Control:   $CONTROL_REPO"
echo "Workbench: $WORKBENCH_REPO"
