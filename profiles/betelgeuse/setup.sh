#!/bin/bash
set -euo pipefail

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

echo "Setting up basic packages"
sudo dnf update --assumeyes
sudo dnf upgrade --assumeyes
sudo dnf install --assumeyes git neovim zsh zsh-autosuggestions zsh-syntax-highlighting thefuck htop
sudo dnf install --assumeyes podman podman-compose
sudo dnf install --assumeyes dnf5-plugin-automatic

echo "Setting up configurations"
sudo cp ${scriptDir}/sshd-config /etc/ssh/sshd_config
sudo cp ${scriptDir}/dnf-automatic.conf /etc/dnf/automatic.conf

echo "Setting up auto-updates"
sudo install -D -m 0644 -- "${scriptDir}/schedule-four-times-daily.conf" "/etc/systemd/system/dnf5-automatic.timer.d/schedule-four-times-daily.conf"
sudo systemctl daemon-reload
sudo systemctl try-restart "dnf5-automatic.timer"
systemctl list-timers --all "dnf5-automatic.timer"

sudo systemctl enable --now dnf-automatic.timer

echo "Setting up starship"
curl -sS https://starship.rs/install.sh | sh
