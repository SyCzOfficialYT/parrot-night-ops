# PARROT // NIGHT OPS

CachyOS-first Hyprland dotfiles with an emerald Parrot-inspired security desktop aesthetic.

> Starter project. This is a desktop configuration for CachyOS/Arch Linux, not Parrot OS itself. Review all scripts before running them.

## Goals

- Hyprland with polished emerald borders, shadows, animation and mouse controls
- Clickable Waybar modules and a menu launcher
- Quickshell-based interactive Control Center (planned next milestone)
- System HUD for CPU, memory, network and hardware overview
- Safe user-level installation with backups and rollback

## Current status

The initial repository scaffold is being built. The first milestone focuses on safe configuration overlay, clickable launcher actions and rollback. A fully featured Quickshell dashboard is not yet implemented.

## Dependencies

CachyOS/Arch Linux, Hyprland, Waybar, wofi, kitty, Fish (optional), `notify-send` (optional), `btop` (optional), and `pavucontrol` (optional).

Install packages from trusted CachyOS/Arch repositories yourself. The project installer does not run pacman or use sudo.

## Install

```bash
./install.sh --dry-run
./install.sh
```

The installer backs up existing managed files under `~/.local/state/parrot-night-ops/backups/`. It does not run as root and does not overwrite files outside the listed managed targets.

## Rollback

```bash
./rollback.sh --list
./rollback.sh --latest
```

Rollback restores backed-up files. Newly created files are retained unless explicitly removed by the user, to avoid deleting unrelated content.

## Security

- No root installer and no automatic package installation
- No credentials, API keys, or VPN secrets in the repository
- No automatic network scans or offensive actions
- Power actions require a second confirmation

## License

MIT. See `LICENSE`.
