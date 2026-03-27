#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 5 ]]; then
  echo "Uso: $0 <ROOT_DIR> <CASE_SLUG> <CONTROL_REMOTE_URL> <WORKBENCH_REMOTE_URL> <BRANCH>"
  exit 1
fi

ROOT_DIR="$1"
CASE_SLUG="$2"
CONTROL_REMOTE_URL="$3"
WORKBENCH_REMOTE_URL="$4"
BRANCH="$5"

CONTROL_REPO="${ROOT_DIR}/${CASE_SLUG}-control"
WORKBENCH_REPO="${ROOT_DIR}/${CASE_SLUG}-workbench"

git -C "$CONTROL_REPO" remote remove origin 2>/dev/null || true
git -C "$CONTROL_REPO" remote add origin "$CONTROL_REMOTE_URL"
git -C "$CONTROL_REPO" push -u origin "$BRANCH"

git -C "$WORKBENCH_REPO" remote remove origin 2>/dev/null || true
git -C "$WORKBENCH_REPO" remote add origin "$WORKBENCH_REMOTE_URL"
git -C "$WORKBENCH_REPO" push -u origin "$BRANCH"
