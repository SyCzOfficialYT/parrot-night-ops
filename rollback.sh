#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/parrot-night-ops"
ROOT="$STATE/backups"
case "${1:---help}" in
  --help|-h) echo 'Usage: ./rollback.sh --list | --latest | --backup /path'; exit 0;;
  --list) [[ -d "$ROOT" ]] && find "$ROOT" -mindepth 1 -maxdepth 1 -type d -print | sort -r || echo 'No backups found.'; exit 0;;
  --latest) [[ -f "$STATE/latest-backup" ]] || { echo 'No backup marker found.' >&2; exit 1; }; backup="$(<"$STATE/latest-backup")";;
  --backup) [[ $# -eq 2 ]] || { echo 'Provide backup path.' >&2; exit 2; }; backup="$2";;
  *) echo 'Unknown option. Use --help.' >&2; exit 2;;
esac
[[ -d "$backup" && "$backup" == "$ROOT/"* ]] || { echo 'Backup path is invalid or outside the managed backup directory.' >&2; exit 1; }
while IFS= read -r -d '' saved; do
  rel="${saved#"$backup"/}"; target="$HOME/$rel"; mkdir -p "$(dirname "$target")"
  if [[ -e "$target" || -L "$target" ]]; then mv -- "$target" "$target.pre-rollback.$(date +%Y%m%d-%H%M%S)"; fi
  cp -a -- "$saved" "$target"; echo "Restored: $target"
done < <(find "$backup" -type f -print0)
echo 'Rollback complete. New files not represented in the backup are intentionally left untouched.'
