# Personal Linux dotfiles

Machine-specific configurations and setup scripts for Arch Linux, Arch Linux ARM,
and Void Linux, plus a separate Debian/Ubuntu-style backup host setup.

These are personal workstation and server setups, not a general-purpose installer.
They include hardware-specific settings, personal paths, network shares, account
configuration, and service changes.

![Desktop screenshot](Screenshot.jpg)

## What's included

- **Desktop:** Hyprland, Waybar, Wofi, Dunst, Kitty, Wallust, GTK/Qt theming,
  and SDDM configuration.
- **Shell:** Zsh with Oh My Zsh, Starship, vi-mode, autosuggestions,
  syntax highlighting, and shared aliases.
- **Development:** Lua-based Neovim configuration with LSP, formatting,
  debugging, Git integration, and testing plugins; profile-specific language
  toolchains and virtualization tools.
- **Mail and organization:** aerc, isync/mbsync, Notmuch, vdirsyncer, khard,
  and mail synchronization scripts.
- **Utilities:** backup/restore scripts, networking and VPN helpers, YubiKey/GPG
  tools, astronomy utilities, and website publishing scripts.
- **AI tools:** OpenCode with ECC and Ponytail in microsandbox, a Claude VM
  helper, and an agentkernel configuration.

Installed packages vary by distribution and profile. See the
[Arch installer](default-profile-install-arch.sh),
[Void installer](default-profile-install-void.sh), and the selected profile's
`profile-enabler.sh` for the actual package lists and setup steps.

## Profiles

| Profile | Distribution | Purpose |
| --- | --- | --- |
| [ATLANTIS-Desktop](profiles/ATLANTIS-Desktop/) | Arch Linux | Desktop workstation, AMD graphics, gaming/VR, and development |
| [ATLANTIS-Laptop](profiles/ATLANTIS-Laptop/) | Arch Linux | Intel laptop, power management, touch/rotation, and development |
| [ATLANTIS-Euclid](profiles/ATLANTIS-Euclid/) | Arch Linux | Framework laptop, Intel graphics, and development |
| [ATLANTIS-Server](profiles/ATLANTIS-Server/) | Void Linux | Storage, Samba, WireGuard, virtualization, and server services |
| [AstroPi](profiles/AstroPi/) | Arch Linux ARM | Raspberry Pi astronomy system, LXQt/VNC, GPS, and hotspot setup |
| [pollux](profiles/pollux/) | APT-based host | Separate Restic/rclone backup setup using `setup.sh` |

`pollux` does not have a `distro` file or `profile-enabler.sh`; do not select it
through the main profile installer. Its setup is separate and machine-specific.

For Raspberry Pi OS preparation, see [AstroPi-README.md](AstroPi-README.md).
Review those instructions against the current Arch Linux ARM documentation before
using them.

## Installation

> **Back up first.** The installer copies files over your home configuration,
> replaces the user crontab, changes system files and services, and removes or
> replaces directories such as `~/wallpapers`. Profile scripts also change
> boot, storage, networking, and hardware settings. Review and adapt them before
> running anything.

Start with an installed OS, a normal user with working `sudo` access, Bash,
and Git. Install the initial tools with the appropriate package manager:

```bash
# Arch Linux / Arch Linux ARM
sudo pacman -Syu --needed git sudo bash

# Void Linux
sudo xbps-install -Sy git sudo bash
```

Clone the repository into a permanent location. The generated update command
keeps a reference to this checkout. Some helpers expect `~/dev/dotfiles`.

```bash
mkdir -p ~/dev
git clone https://github.com/RononDex/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
bash profile-enabler.sh
```

Choose the matching profile when prompted, or provide its name directly:

```bash
bash profile-enabler.sh ATLANTIS-Desktop
```

Use **Bash**, not `sh`: the scripts use Bash-specific syntax. Do not run the
whole installer as root; it uses the current user's home directory and invokes
`sudo` where needed.

### What the installer does

1. Reads the chosen profile's `distro` file.
2. Copies `defaults/`, including hidden files, into your home directory.
3. Copies the selected profile's contents into `~/.scripts/` and links
   `~/.profile` to `~/.zprofile`.
4. Runs `default-profile-install-<distro>.sh`.
5. Runs the profile's `profile-enabler.sh`, when present.
6. Generates `~/.scripts/updateDotFiles` for that checkout and profile.

Review the output for failures before rebooting. These scripts are not
transactional and do not automatically roll back partial changes.

## Updating and customization

After installation, the Zsh alias `up` runs `updateDotFiles`. It pulls repository
changes with `git pull --ff-only` and reruns the installer with the saved profile.
The distribution installers also perform package updates, including AUR updates
on Arch.

Edit files in the checkout rather than only editing the installed copies:
rerunning installation can overwrite local configuration. For example, edit
`defaults/.config/kitty/kitty.conf` for shared Kitty settings, or a profile's
`overrides/` for machine-specific settings.

To create a profile, add `profiles/<name>/distro` containing `arch` or `void`.
Add `profile-enabler.sh` for installation steps and overrides, and `bashprofile`
if you need profile-specific shell initialization. The Zsh configuration sources
the installed `~/.scripts/bashprofile` when it exists.

### Useful commands

| Command | Action |
| --- | --- |
| `up` | Pull and reapply the installed profile |
| `ed` | Open `~/dev/dotfiles` in `$EDITOR` (or `vi`) |
| `dev` | Pick a Git checkout under `~/dev` and open it in the editor |
| `ai` | Launch OpenCode in the current directory's microsandbox |
| `ai --shell` | Open Bash in that sandbox |
| `ai --rm` | Force-remove that directory's sandbox |

Aliases live in [defaults/.scripts/aliasrc](defaults/.scripts/aliasrc).

## AI sandbox

The [`ai` launcher](defaults/.scripts/ai/start-msb-opencode) requires `msb` on the
host. The Desktop, Laptop, and Euclid profiles call `SetupMicrosandbox` to install
it. First launch also needs network access to install OpenCode, ECC, and Ponytail
inside the guest.

Run `ai` from a project directory. It creates or reuses a sandbox identified by
that directory's canonical path and mounts the directory at `/workspace`.
**Edits inside `/workspace` change the host project too.** OpenCode data is
mounted separately at `/root/.local/share/opencode` using a named volume.

### Editable configuration

| Repository file | Sandbox destination | Purpose |
| --- | --- | --- |
| [defaults/.scripts/ai/opencode.json](defaults/.scripts/ai/opencode.json) | `/etc/opencode/opencode.json` | OpenCode settings layered over ECC/Ponytail and project configuration |
| [defaults/.scripts/ai/cli.json](defaults/.scripts/ai/cli.json) | `/root/.config/opencode/cli.json` | Terminal settings: One Dark theme and animations enabled by default |

Each launch, including `ai --shell`, copies both JSON files from beside the
launcher into the guest—even for existing sandboxes. Invalid JSON stops launch.
The ECC global `opencode.json` is not overwritten; the guest `cli.json` is
replaced by the supplied file.

For an installed launcher, edit the repository files and reapply the dotfiles
before the next `ai` launch, or edit the installed copies in `~/.scripts/ai/`.
Keep credentials out of committed configuration.

### Launcher defaults

| Environment variable | Default |
| --- | --- |
| `OC_IMAGE` | `node:22-bookworm` |
| `OC_CPUS` | `2` |
| `OC_MEM` | `4G` |
| `OC_VERSION` | `2.3.2` |
| `ECC_REF` | `main` |

For example: `OC_CPUS=4 OC_MEM=8G ai`.
Image and resource settings apply when creating a sandbox; OpenCode and ECC
versions are used during first-time provisioning, not automatically upgraded on
each launch.

## Repository layout

```text
defaults/                         Shared files copied into ~/
  .config/                        Application and desktop configuration
  .scripts/                       Shell helpers, AI, backups, networking, etc.
  .files/                         Installer assets for system configuration
profiles/                         Machine-specific installers and overrides
functions/                        Shared installation and service helpers
profile-enabler.sh                Main interactive/profile-name installer
default-profile-install-arch.sh   Shared Arch setup
default-profile-install-void.sh   Shared Void setup
AstroPi-README.md                 Raspberry Pi preparation notes
Screenshot.jpg                    Desktop screenshot
```

See [LICENSE](LICENSE) for licensing.
