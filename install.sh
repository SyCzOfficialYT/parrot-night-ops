#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'
APP=parrot-night-ops
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/$APP"
BACKUP_ROOT="$STATE/backups"
DRY_RUN=0
for arg in "$@"; do case "$arg" in --dry-run) DRY_RUN=1;; -h|--help) echo 'Usage: ./install.sh [--dry-run]'; exit 0;; *) echo "Unknown option: $arg" >&2; exit 2;; esac; done
[[ $EUID -ne 0 ]] || { echo 'Do not run as root.' >&2; exit 1; }
[[ -d "$ROOT/config" ]] || { echo 'Missing config directory.' >&2; exit 1; }
STAMP="$(date +%Y%m%d-%H%M%S)"; BACKUP="$BACKUP_ROOT/$STAMP"
# Explicit source => destination list. No globbing and no sudo.
declare -a pairs=(
  "$ROOT/config/hypr/hyprland.conf|$HOME/.config/hypr/hyprland.conf"
  "$ROOT/config/waybar/config.jsonc|$HOME/.config/waybar/config.jsonc"
  "$ROOT/config/waybar/style.css|$HOME/.config/waybar/style.css"
  "$ROOT/scripts/night-ops-menu|$HOME/.local/bin/night-ops-menu"
  "$ROOT/scripts/system-hud|$HOME/.local/bin/night-ops-hud"
)
echo "PARROT // NIGHT OPS — $([[ $DRY_RUN -eq 1 ]] && echo DRY-RUN || echo APPLY)"
printf '  %s\n' "${pairs[@]//|/ -> }"
[[ $DRY_RUN -eq 0 ]] || { echo 'No files changed.'; exit 0; }
mkdir -p "$BACKUP" "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.local/bin"
for pair in "${pairs[@]}"; do
  src="${pair%%|*}"; dst="${pair#*|}"
  [[ -f "$src" ]] || { echo "Missing source: $src" >&2; exit 1; }
  if [[ -e "$dst" || -L "$dst" ]]; then
    rel="${dst#"$HOME"/}"; mkdir -p "$BACKUP/$(dirname "$rel")"; cp -a -- "$dst" "$BACKUP/$rel"
    echo "Backed up: $dst"
  fi
  if [[ "$src" == */scripts/* ]]; then install -m 0755 -- "$src" "$dst"; else install -m 0644 -- "$src" "$dst"; fi
  echo "Installed: $dst"
done
printf '%s\n' "$BACKUP" > "$STATE/latest-backup"; chmod 600 "$STATE/latest-backup"
echo "Done. Backup: $BACKUP"
echo 'Note: this starter currently replaces the main Hyprland config file; merge any custom settings first.'
