#!/usr/bin/env bash
# SPDX-License-Identifier: LGPL-3.0-or-later
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Uso: $0 <CASE_REPO_PATH> <REMOTE_URL> [BRANCH]"
  exit 1
fi

CASE_REPO_PATH="$1"
REMOTE_URL="$2"
BRANCH="${3:-main}"

[[ -d "$CASE_REPO_PATH/.git" ]] || { echo "No parece un repo Git: $CASE_REPO_PATH"; exit 2; }

git -C "$CASE_REPO_PATH" remote remove origin 2>/dev/null || true
git -C "$CASE_REPO_PATH" remote add origin "$REMOTE_URL"
git -C "$CASE_REPO_PATH" push -u origin "$BRANCH"
