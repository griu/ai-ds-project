#!/usr/bin/env bash
# SPDX-License-Identifier: LGPL-3.0-or-later
set -euo pipefail

if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo "Uso: $0 <CASE_REPO_PATH> <GITHUB_OWNER> <REPO_NAME> [VISIBILITY]"
  exit 1
fi

CASE_REPO_PATH="$1"
GITHUB_OWNER="$2"
REPO_NAME="$3"
VISIBILITY="${4:-private}"

[[ "$VISIBILITY" == "private" || "$VISIBILITY" == "public" ]] || { echo "VISIBILITY debe ser private o public"; exit 2; }
[[ -d "$CASE_REPO_PATH/.git" ]] || { echo "No parece un repo Git: $CASE_REPO_PATH"; exit 3; }

gh repo create "${GITHUB_OWNER}/${REPO_NAME}" --${VISIBILITY} --source "$CASE_REPO_PATH" --remote origin --push
