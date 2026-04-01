#!/usr/bin/env bash
set -euo pipefail
PORT="${1:-8501}"
HOST="${2:-0.0.0.0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
streamlit run "$SCRIPT_DIR/app.py" --server.port "$PORT" --server.address "$HOST"
