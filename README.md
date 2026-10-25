# PARROT // NIGHT OPS

CachyOS-first Hyprland dotfiles with an emerald Parrot-inspired security desktop aesthetic.

> Starter project. This configures a desktop experience on CachyOS/Arch Linux; it does not install Parrot OS itself. Review scripts before running them.

## Current milestone

- Hyprland emerald theme with shadows, blur, animations and mouse window controls
- Clickable Waybar workspaces, system indicators and menu actions
- Wofi-based session/network menu with confirmation before restart or shutdown
- System HUD fallback using btop or a basic system report
- User-level installer with dry-run and timestamped backups
- Rollback for previously backed-up files

**Quickshell Control Center is the next milestone and is not implemented yet.** This initial scaffold is not a complete match for the visual mockup.

## Dependencies

CachyOS/Arch Linux, Hyprland, Waybar, wofi, kitty, and optionally swaync, btop, pavucontrol, pamixer, hyprlock, NetworkManager's `nmcli`/`nm-connection-editor`, and `yad`.

Install packages yourself from trusted CachyOS/Arch repositories. The project installer never invokes pacman or sudo.

## Install

```bash
chmod +x install.sh rollback.sh scripts/night-ops-menu scripts/system-hud
./install.sh --dry-run
./install.sh
```

**Important:** the installer manages `~/.config/hypr/hyprland.conf` as a whole file. Back up and merge your current Hyprland configuration first if it contains custom settings. Existing target files are backed up under `~/.local/state/parrot-night-ops/backups/`.

After install, verify syntax and restart/reload Hyprland only when you are ready. Some optional menu actions require the corresponding optional packages.

## Rollback

```bash
./rollback.sh --list
./rollback.sh --latest
```

Rollback restores files found in the selected backup. If a target did not exist before installation, the installer does not create a backup copy for it; remove those newly created managed files manually if you want a full uninstall. Files replaced during rollback are retained with a `.pre-rollback` suffix.

## Security principles

- No root installer or automatic package installation
- No credentials, API keys, or VPN secrets in the repository
- No automatic network scans or offensive actions
- Restart/shutdown actions require a second confirmation

## License

MIT. See `LICENSE`.
