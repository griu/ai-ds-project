#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  bash demo/scripts/create_and_push_case_repos_with_gh.sh <case_repo_path> <github_owner> <visibility> [repo_name]

Ejemplo:
  bash demo/scripts/create_and_push_case_repos_with_gh.sh \
    /home/griu/git/home-credit \
    mi-org \
    private
USAGE
}

main() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ $# -lt 3 || $# -gt 4 ]]; then
    usage
    exit 1
  fi

  local CASE_REPO="$1"
  local GITHUB_OWNER="$2"
  local VISIBILITY="$3"
  local REPO_NAME="${4:-$(basename "$CASE_REPO")}"

  [[ -d "$CASE_REPO/.git" ]] || { echo "ERROR: no parece un repo Git: $CASE_REPO" >&2; exit 1; }
  [[ "$VISIBILITY" == "private" || "$VISIBILITY" == "public" ]] || { echo "ERROR: VISIBILITY debe ser private o public" >&2; exit 2; }

  gh repo create "${GITHUB_OWNER}/${REPO_NAME}" --"${VISIBILITY}" --source "$CASE_REPO" --remote origin --push
  echo ">>> Repo GitHub creado y publicado: ${GITHUB_OWNER}/${REPO_NAME}"
}

main "$@"
