#!/usr/bin/env bash
# Scan every publishable file for internal terms before committing.
# Terms come from private/denylist.txt (gitignored), so the list itself is never published.
# Exit code: 0 = clean, 1 = matches found, 2 = denylist missing.
set -euo pipefail
cd "$(dirname "$0")/.."

DENYLIST="private/denylist.txt"
if [[ ! -f "$DENYLIST" ]]; then
  echo "No $DENYLIST found. Create it with one internal term per line." >&2
  exit 2
fi

mapfile -t TERMS < <(grep -vE '^\s*(#|$)' "$DENYLIST")
if [[ ${#TERMS[@]} -eq 0 ]]; then
  echo "Denylist is empty; nothing to check."
  exit 0
fi

PATTERN=$(IFS='|'; echo "${TERMS[*]}")
FILES=$(find . -type f \( -name '*.html' -o -name '*.md' -o -name '*.css' -o -name '*.js' -o -name '*.json' -o -name '*.txt' \) \
  -not -path './private/*' -not -path './.git/*')

if grep -nwiE "$PATTERN" $FILES; then
  echo
  echo "✗ Internal terms found above. Remove them before publishing." >&2
  exit 1
fi
echo "✓ No internal terms found in publishable files."
