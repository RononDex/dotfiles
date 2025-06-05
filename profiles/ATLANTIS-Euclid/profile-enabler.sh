#!/bin/sh
# ------------------------------
# Arch Linux Install
# ------------------------------
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh

sudo cp $scriptDir/overrides/mkinitcpio/mkinitcpio.conf /etc/mkinitcpio.conf
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/21-touchpad.conf /etc/X11/xorg.conf.d/21-touchpad.conf
sudo cp $scriptDir/overrides/hosts /etc/hosts
sudo cp $scriptDir/overrides/tlp/10-laptop.conf /etc/tlp.d/10-laptop.conf
cp $scriptDir/overrides/.Xresources ~/.Xresources
sudo cp $scriptDir/overrides/pacman.conf /etc/pacman.conf
cp $scriptDir/overrides/hyprland/monitors.conf ~/.config/hypr/monitors.conf
cp $scriptDir/overrides/hyprland/custom-execs.conf ~/.config/hypr/configs/custom-execs.conf
cp $scriptDir/overrides/hyprland/custom-envs.conf ~/.config/hypr/configs/custom-envs.conf
cp $scriptDir/overrides/waybar/active-modules-bottom.json ~/.config/waybar/active-modules-bottom.json
cp $scriptDir/overrides/waybar/bar-output.json ~/.config/waybar/bar-output.json
cp $scriptDir/overrides/waybar/custom-modules-config.json ~/.config/waybar/custom-modules-config.json

sudo pacman -Syy
sudo pacman -Syu --noconfirm

echo "Installing stuff..."
sudo pacman -Sy nextcloud-client light dunst libnotify notification-daemon vlc blueman wireguard-tools --noconfirm --needed
sudo pacman -Sy texlive aspnet-runtime xournalpp remmina signal-desktop freerdp --needed --noconfirm
sudo pacman -Sy nomacs tlp tlp-rdw libreoffice breeze breeze-icons --needed --noconfirm
sudo pacman -Sy virt-manager qemu chromium xf86-video-vesa --needed --noconfirm
sudo pacman -Syu sof-firmware dotnet-sdk aspnet-runtime aspnet-targeting-pack --needed --noconfirm
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable tlp
sudo systemctl start tlp

SetupDotnet
InstallWayland
InstallHyprland
SetupWireguardClient
SetupJavaDevEnv
InstallJupyterNotebooks
SetupPythonDev
SetupLatex
InstallGrubTheme -s 1080p
InstallEruption
InstallGoDev
SetupWordpressDev

echo "Installing AUR packages..."
InstallMpv
InstallAurPackage "steam-fonts" "https://aur.archlinux.org/steam-fonts.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "breeze-obsidian-cursor-theme" "https://aur.archlinux.org/breeze-obsidian-cursor-theme.git"
# InstallAurPackage "teams" "https://aur.archlinux.org/teams.git"
InstallAurPackage "slack-desktop" "https://aur.archlinux.org/slack-desktop.git"
InstallAurPackage "cvmfs" "https://aur.archlinux.org/cvmfs.git"
InstallAurPackage "jellyfin-media-player" "https://aur.archlinux.org/jellyfin-media-player.git"
InstallAurPackage "ckb-next" "https://aur.archlinux.org/ckb-next.git"
InstallAurPackage "openconnect-sso" "https://aur.archlinux.org/openconnect-sso.git"

EnableService ckb-next-daemon
StartService ckb-next-daemon

echo "Installing screenkey"
sudo pacman -Sy python2-setuptools --needed --noconfirm
InstallAurPackage "python2-distutils-extra" "https://aur.archlinux.org/python2-distutils-extra.git"
InstallAurPackage "screenkey" "https://aur.archlinux.org/screenkey.git"

echo "Setting up rootless docker..."
InstallAurPackage "docker-rootless-extras" "https://aur.archlinux.org/docker-rootless-extras.git"
echo "${USER}:165536:65536" | sudo tee /etc/subuid
echo "${USER}:165536:65536" | sudo tee /etc/subgid
systemctl enable docker.socket --user

echo "Enabling services ..."
sudo systemctl enable libvirtd

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "Documents" "://10.142.0.1/Documents" "Downloads" "://10.142.0.1/Downloads" "Software" "://10.142.0.1/Software" "Astrophotography" "://10.142.0.1/Astrophotography" "Backup" "://10.142.0.1/Backup"
SetupAutofsForSmbShare "FHNW" "data" "" "://fs.edu.ds.fhnw.ch/data"

echo "Adjust user permissions"
currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G users ${currentUser}
sudo usermod -a -G audio ${currentUser}
sudo usermod -a -G libvirt ${currentUser}
sudo usermod -a -G wheel ${currentUser}

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.i3/workspaces/load-workspaces.sh

echo "Updating grub config"
sudo cp $scriptDir/overrides/grub/grub /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg  
