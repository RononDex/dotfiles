#!/bin/sh
# ------------------------------
# Arch Linux Install
# ------------------------------
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh

sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/21-touchpad.conf /etc/X11/xorg.conf.d/21-touchpad.conf
sudo cp $scriptDir/overrides/mkinitcpio/mkinitcpio.conf /etc/mkinitcpio.conf
sudo cp $scriptDir/overrides/modprobe/i915.conf /etc/modprobe.d/i915.conf
sudo cp $scriptDir/overrides/tlp/10-laptop.conf /etc/tlp.d/10-laptop.conf
cp $scriptDir/overrides/.Xresources ~/.Xresources
sudo cp $scriptDir/overrides/pacman.conf /etc/pacman.conf
cp $scriptDir/overrides/hyprland/monitors.conf ~/.config/hypr/monitors.conf
cp $scriptDir/overrides/hyprland/custom-execs.conf ~/.config/hypr/configs/custom-execs.conf
cp $scriptDir/overrides/hyprland/custom-envs.conf ~/.config/hypr/configs/custom-envs.conf
cp $scriptDir/overrides/waybar/active-modules-top.json ~/.config/waybar/active-modules-top.json
cp $scriptDir/overrides/waybar/bar-output.json ~/.config/waybar/bar-output.json

echo "Installing stuff..."
sudo pacman -S sof-firmware nextcloud-client light xf86-input-wacom dunst libnotify notification-daemon vlc dmenu teamspeak3 blueman qt6-virtualkeyboard wireguard-tools --noconfirm --needed
sudo pacman -S texlive aspnet-runtime xournalpp remmina signal-desktop freerdp --needed --noconfirm
sudo pacman -S nomacs tlp tlp-rdw libreoffice breeze breeze-icons libvncserver --needed --noconfirm
sudo pacman -S virt-manager qemu onboard chromium xf86-video-vesa --needed --noconfirm
sudo pacman -S dotnet-sdk aspnet-runtime aspnet-targeting-pack sof-firmware --needed --noconfirm
sudo pacman -S mesa steam lib32-mesa vulkan-intel intel-ucode intel-media-driver libva-intel-driver --needed --confirm

echo "Setup auto screen rotation"
InstallAurPackage "iio-hyprland" "https://aur.archlinux.org/iio-hyprland.git"

echo "Setting up virtual keyboard"
InstallAurPackage "wvkdb" "https://aur.archlinux.org/wvkbd.git"

sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable tlp
sudo systemctl start tlp
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

InstallWayland
InstallHyprland
SetupWireguardClient
SetupJavaDevEnv
InstallJupyterNotebooks
SetupPythonDev
SetupDotnet
SetupLatex
InstallGrubTheme 
InstallMpv
InstallGoDev
SetupWordpressDev

echo "Installing AUR packages..."
InstallAurPackage "nvm" "https://aur.archlinux.org/nvm.git"
InstallAurPackage "mons" "https://aur.archlinux.org/mons.git"
InstallAurPackage "steam-fonts" "https://aur.archlinux.org/steam-fonts.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "breeze-obsidian-cursor-theme" "https://aur.archlinux.org/breeze-obsidian-cursor-theme.git"
InstallAurPackage "slack-desktop" "https://aur.archlinux.org/slack-desktop.git"
InstallAurPackage "jellyfin-media-player" "https://aur.archlinux.org/jellyfin-media-player.git"
InstallAurPackage "openconnect-sso" "https://aur.archlinux.org/openconnect-sso.git"


echo "Installing drivers for other devices"
InstallAurPackage "wd719x-firmware" "https://aur.archlinux.org/wd719x-firmware.git"
InstallAurPackage "upd72020x-fw" "https://aur.archlinux.org/upd72020x-fw.git"
InstallAurPackage "aic94xx-firmware" "https://aur.archlinux.org/aic94xx-firmware.git"
InstallAurPackage "ast-firmware" "https://aur.archlinux.org/ast-firmware.git"
sudo pacman -Slinux-firmware-qlogic --needed --noconfirm

echo "Setting up rootless docker..."
InstallAurPackage "docker-rootless-extras" "https://aur.archlinux.org/docker-rootless-extras.git"
echo "${USER}:165536:65536" | sudo tee /etc/subuid
echo "${USER}:165536:65536" | sudo tee /etc/subgid
systemctl enable docker.socket --user

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

echo "Updating grub config"
sudo cp $scriptDir/overrides/grub/grub.cfg /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg  

echo "Regenerating initramfs"
sudo mkinitcpio -P
