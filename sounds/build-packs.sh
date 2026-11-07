#!/usr/bin/env bash
# Zips each folder with a pack.json into dist/ and writes dist/packs.json.
# The sounds release workflow uploads dist/ to the sounds-vN release.
set -euo pipefail
cd "$(dirname "$0")"
out=${1:-dist}
rm -rf "$out" && mkdir -p "$out" && out=$(cd "$out" && pwd)

sha() { if command -v sha256sum >/dev/null; then sha256sum "$1" | cut -d' ' -f1; else shasum -a 256 "$1" | cut -d' ' -f1; fi; }

entries=()
for dir in */; do
  dir=${dir%/}
  [ -f "$dir/pack.json" ] || continue
  name=$(jq -r .name "$dir/pack.json")
  zipname="yuva-sounds-$name.zip"
  # -X leaves out extra file attributes, -D no folder entries
  (cd "$dir" && zip -qXD -r "$out/$zipname" . -x '.*')
  count=$(find "$dir" -type f ! -name pack.json ! -name '.*' | wc -l | tr -d ' ')
  size=$(wc -c < "$out/$zipname" | tr -d ' ')
  entries+=("$(jq -c --arg file "$zipname" --arg sha "$(sha "$out/$zipname")" --argjson size "$size" --argjson files "$count" \
    '. + {file: $file, size: $size, sha256: $sha, files: $files}' "$dir/pack.json")")
done
printf '%s\n' "${entries[@]}" | jq -s '{packs: .}' > "$out/packs.json"
cat "$out/packs.json"
