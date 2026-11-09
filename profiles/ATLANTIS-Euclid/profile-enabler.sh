#!/bin/sh
# ------------------------------
# Arch Linux Install
# ------------------------------
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh

# Bootloader
sudo mkdir -p /boot/EFI/limine
sudo cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine/
# TODO: update conf with partition UUIDS
sudo cp $scriptDir/overrides/limine/limine.conf /boot/EFI/limine/

sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
cp $scriptDir/overrides/hyprland/custom-config.lua ~/.config/hypr/configs/custom-config.lua
cp $scriptDir/overrides/waybar/active-modules-bottom.json ~/.config/waybar/active-modules-bottom.json
cp $scriptDir/overrides/waybar/bar-output.json ~/.config/waybar/bar-output.json
cp $scriptDir/overrides/waybar/custom-modules-config.json ~/.config/waybar/custom-modules-config.json

# TODO: Update crypt store on new laptop
cp $scriptDir/overrides/mbsync/crypt-store/astrophotography-proton ~/.config/mbsync/crypt-store/astrophotography-proton
cp $scriptDir/overrides/mbsync/crypt-store/tino-proton ~/.config/mbsync/crypt-store/tino-proton
cp $scriptDir/overrides/mbsync/crypt-store/tino-sag ~/.config/mbsync/crypt-store/tino-sag
cp $scriptDir/overrides/mbsync/crypt-store/webmaster-sag ~/.config/mbsync/crypt-store/webmaster-sag
cp $scriptDir/overrides/mbsync/certs/proton-bridge.pem ~/.config/mbsync/certs/proton-bridge.pem
cp $scriptDir/overrides/vdirsyncer/crypt-store/nextcloud-cobra.pw ~/.config/vdirsyncer/crypt-store/nextcloud-cobra.pw
cp $scriptDir/overrides/vdirsyncer/crypt-store/nextcloud-sag.pw ~/.config/vdirsyncer/crypt-store/nextcloud-sag.pw
sudo trust anchor --store ~/.config/mbsync/certs/proton-bridge.pem
mkdir -p ~/Mail/astrophotography-proton/
mkdir -p ~/Mail/tino-proton/
mkdir -p ~/Mail/tino-sag/
mkdir -p ~/Mail/webmaster-sag/
chmod -R 700 ~/Mail/


echo "Installing stuff..."
sudo pacman -S nextcloud-client dunst libnotify notification-daemon blueman wireguard-tools --noconfirm --needed
sudo pacman -S texlive aspnet-runtime xournalpp remmina signal-desktop freerdp --needed --noconfirm
sudo pacman -S power-profiles-daemon libreoffice breeze breeze-icons --needed --noconfirm
sudo pacman -S virt-manager qemu chromium xf86-video-vesa cef --needed --noconfirm
sudo pacman -S sof-firmware dotnet-sdk aspnet-runtime aspnet-targeting-pack --needed --noconfirm
sudo pacman -S mesa steam lib32-mesa vulkan-intel intel-ucode intel-media-driver libva-intel-driver --needed --confirm
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable power-profiles-daemon
sudo systemctl start power-profiles-daemon

SetupDotnet
InstallWayland
InstallHyprland
SetupWireguardClient
SetupJavaDevEnv
SetupPythonDev
SetupLatex
InstallEruption
InstallGoDev
SetupWordpressDev
SetupClaudeVm

echo "Installing AUR packages..."
InstallMpv
InstallAurPackage "visual-studio-code-bin"
InstallAurPackage "breeze-obsidian-cursor-theme"
InstallAurPackage "slack-desktop"
InstallAurPackage "cvmfs"
sudo cvmfs_config setup
InstallAurPackage "jellyfin-desktop-git"
InstallAurPackage "ckb-next"
InstallAurPackage "onlyoffice-bin"

echo "Installing Yubico Authenticator..."
curl https://keys.openpgp.org/vks/v1/by-fingerprint/20EE325B86A81BCBD3E56798F04367096FBA95E8 | gpg --import
InstallAurPackage "yubico-authenticator-bin"

echo "Installing Proton Stuff"
sudo pacman -S protonmail-bridge proton-vpn-gtk-app --needed --noconfirm


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

SetupWinBoat

echo "Regenerating initramfs"
sudo mkinitcpio -P
