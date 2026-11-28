#!/bin/bash
set -euo pipefail

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. ${scriptDir}/.scripts/aliasrc

### ----------------------------------------------------
### Install necessary packages
### ----------------------------------------------------

echo "Setting up basic packages"
sudo dnf update --assumeyes
sudo dnf upgrade --assumeyes
sudo dnf install --assumeyes git neovim zsh zsh-autosuggestions zsh-syntax-highlighting thefuck htop
sudo dnf install --assumeyes podman podman-compose
sudo dnf install --assumeyes dnf5-plugin-automatic btrfs-progs shadow-utils-subid
sudo dnf install --assumeyes restic rclone fuse-sshfs

### ----------------------------------------------------
### Basic config setup
### ----------------------------------------------------

echo "Setting up configurations"
sudo cp ${scriptDir}/sshd-config /etc/ssh/sshd_config
sudo cp ${scriptDir}/dnf-automatic.conf /etc/dnf/automatic.conf

echo "Disabling fedora server cockpit (web-application)"
sudo systemctl disable --now cockpit.socket
sudo systemctl stop cockpit.service

### ----------------------------------------------------
### Setup automatic updates every 6 hours
### ----------------------------------------------------

echo "Setting up auto-updates"
sudo install -D -m 0644 -- "${scriptDir}/schedule-four-times-daily.conf" "/etc/systemd/system/dnf5-automatic.timer.d/schedule-four-times-daily.conf"
sudo systemctl daemon-reload
sudo systemctl try-restart "dnf5-automatic.timer"
sudo systemctl list-timers --all "dnf5-automatic.timer"

sudo systemctl enable --now dnf-automatic.timer

### ----------------------------------------------------
### Setup zsh and starship
### ----------------------------------------------------

echo "Setting up Oh My Zsh"
zsh_path=$(command -v zsh) || {
	echo 'Install zsh first.' >&2
	exit 1
}

if [[ $(getent passwd "$(id -un)" | cut -d: -f7) != */zsh ]]; then
	chsh -s "$zsh_path" || exit 1
fi

omz_dir="$HOME/.config/oh-my-zsh"
if [ -f "$omz_dir/tools/upgrade.sh" ]; then
	ZSH="$omz_dir" "$zsh_path" -f "$omz_dir/tools/upgrade.sh"
else
	installer=$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) &&
		ZDOTDIR="$HOME/.config/zsh" ZSH="$omz_dir" \
			sh -c "$installer" -- --unattended --keep-zshrc
fi

cp ${scriptDir}/../../defaults/.config/zsh/.zshrc ~/.zshrc
cp ${scriptDir}/../../defaults/.config/starship.toml ~/.config/starship.toml
cp ${scriptDir}/../../defaults/.bashrc ~/.bashrc
cp -r ${scriptDir}/.scripts/. ~/.scripts/

curl -sS https://starship.rs/install.sh | sh -s -- --yes

### ----------------------------------------------------
### Setup podman stuff
### ----------------------------------------------------

echo "Setting up podman user"
sudo bash ${scriptDir}/setup-podman-user.sh

echo "Setting up podman config"
sudo mkdir -p /srv/data/podman-volumes
sudo chown -R podman-svc:podman-svc /srv/data/podman-volumes
sudo chmod 0700 /srv/data/podman-volumes # Only top level should have 0700 permissions
volpath=$(podman-svc info --format '{{.Store.VolumePath}}')
printf 'Podman volume directory: %s\n' "$volpath"
target=/srv/data/podman-volumes

if ! sudo test -L "$volpath"; then
	if ! mountpoint -q /srv/data || ! sudo test -d "$target"; then
		echo "Mount /srv/data and create $target first." >&2
		exit 1
	fi

	if sudo test -e "$volpath"; then
		sudo rmdir -- "$volpath" || exit 1
	fi

	sudo ln -sT -- "$target" "$volpath"
fi

### ----------------------------------------------------
### Setup backup stuff
### ----------------------------------------------------
echo "Setting up backup user"
sudo bash ${scriptDir}/setup-backup-user.sh

sudo mkdir -p /home/backup-svc/scripts
sudo cp ${scriptDir}/backup/backupHostpointRestic.sh /home/backup-svc/scripts/backup-hotpoint-restic.sh
sudo cp ${scriptDir}/backup/backupServerRestic.sh /home/backup-svc/scripts/backup-server-restic.sh
sudo chown -R backup-svc:backup-svc /home/backup-svc/scripts

echo "Setting up backup systemD services / triggers"
sudo cp ${scriptDir}/backup/backup-server-restic.service /etc/systemd/system/restic-server-backup.service
sudo cp ${scriptDir}/backup/backup-server-restic.timer /etc/systemd/system/restic-server-backup.timer
sudo cp ${scriptDir}/backup/backup-hostpoint-restic.service /etc/systemd/system/restic-hostpoint-backup.service
sudo cp ${scriptDir}/backup/backup-hostpoint-restic.timer /etc/systemd/system/restic-hostpoint-backup.timer

sudo systemctl daemon-reload
#sudo systemctl enable --now restic-server-backup.timer
#sudo systemctl enable --now restic-hostpoint-backup.timer
systemctl list-timers restic-server-backup.timer
systemctl list-timers restic-hostpoint-backup.timer
