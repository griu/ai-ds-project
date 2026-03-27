#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Uso: $0 <ROOT_DIR> <CASE_SLUG> <GITHUB_OWNER> <VISIBILITY>"
  exit 1
fi

ROOT_DIR="$1"
CASE_SLUG="$2"
GITHUB_OWNER="$3"
VISIBILITY="$4"

CONTROL_REPO_DIR="${ROOT_DIR}/${CASE_SLUG}-control"
WORKBENCH_REPO_DIR="${ROOT_DIR}/${CASE_SLUG}-workbench"
CONTROL_REPO_NAME="${CASE_SLUG}-control"
WORKBENCH_REPO_NAME="${CASE_SLUG}-workbench"

[[ "$VISIBILITY" == "private" || "$VISIBILITY" == "public" ]] || { echo "VISIBILITY debe ser private o public"; exit 2; }

gh repo create "${GITHUB_OWNER}/${CONTROL_REPO_NAME}" --${VISIBILITY} --source "$CONTROL_REPO_DIR" --remote origin --push
gh repo create "${GITHUB_OWNER}/${WORKBENCH_REPO_NAME}" --${VISIBILITY} --source "$WORKBENCH_REPO_DIR" --remote origin --push
