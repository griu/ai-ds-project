#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  bash demo/scripts/push_case_repos_existing_remote.sh <case_repo_path> <remote_url> [branch]

Ejemplo:
  bash demo/scripts/push_case_repos_existing_remote.sh \
    /home/griu/git/home-credit \
    git@github.com:usuario/home-credit.git \
    main
USAGE
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

  local CASE_REPO="$1"
  local REMOTE_URL="$2"
  local BRANCH="${3:-main}"

  [[ -d "$CASE_REPO/.git" ]] || { echo "ERROR: no parece un repo Git: $CASE_REPO" >&2; exit 1; }

  if git -C "$CASE_REPO" remote get-url origin >/dev/null 2>&1; then
    git -C "$CASE_REPO" remote set-url origin "$REMOTE_URL"
  else
    git -C "$CASE_REPO" remote add origin "$REMOTE_URL"
  fi

  git -C "$CASE_REPO" push -u origin "$BRANCH"
  echo ">>> Repo publicado: $CASE_REPO"
}

main "$@"
