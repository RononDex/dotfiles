#!/bin/bash
set -euo pipefail

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

echo "Setting up basic packages"
sudo dnf update --assumeyes
sudo dnf upgrade --assumeyes
sudo dnf install --assumeyes git neovim zsh zsh-autosuggestions zsh-syntax-highlighting thefuck htop
sudo dnf install --assumeyes podman podman-compose
sudo dnf install --assumeyes dnf5-plugin-automatic btrfs-progs shadow-utils-subid

echo "Setting up configurations"
sudo cp ${scriptDir}/sshd-config /etc/ssh/sshd_config
sudo cp ${scriptDir}/dnf-automatic.conf /etc/dnf/automatic.conf

echo "Setting up auto-updates"
sudo install -D -m 0644 -- "${scriptDir}/schedule-four-times-daily.conf" "/etc/systemd/system/dnf5-automatic.timer.d/schedule-four-times-daily.conf"
sudo systemctl daemon-reload
sudo systemctl try-restart "dnf5-automatic.timer"
systemctl list-timers --all "dnf5-automatic.timer"

sudo systemctl enable --now dnf-automatic.timer

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

echo "Setting up podman user"
sudo bash ${scriptDir}/setup-podman-user.sh
