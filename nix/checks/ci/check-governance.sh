#!/usr/bin/env bash

set -euo pipefail

repo_root=$1

required_paths=(
  ARCHITECTURE.md
  CONSTRAINTS.md
  DECISIONS.md
  DESIGN.md
  PRODUCT_BRIEF.md
  README.md
  STATE.md
  TASKS.json
  schemas/TASKS.schema.json
)

for rel_path in "${required_paths[@]}"; do
  path="$repo_root/$rel_path"

  if [[ ! -e $path ]]; then
    echo "missing governance artifact: $rel_path" >&2
    exit 1
  fi
done
