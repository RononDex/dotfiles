#!/bin/sh
# ------------------------------
# Arch Linux Install
# ------------------------------
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh

cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/21-touchpad.conf /etc/X11/xorg.conf.d/21-touchpad.conf
sudo cp $scriptDir/overrides/mkinitcpio/mkinitcpio.conf /etc/mkinitcpio.conf
sudo cp $scriptDir/overrides/modprobe/i915.conf /etc/modprobe.d/i915.conf
sudo cp $scriptDir/overrides/tlp/10-laptop.conf /etc/tlp.d/10-laptop.conf
cp $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh
cp $scriptDir/overrides/.Xresources ~/.Xresources
sudo cp $scriptDir/overrides/pacman.conf /etc/pacman.conf

sudo pacman -Syu --noconfirm

echo "Installing stuff..."
sudo pacman -Sy sof-firmware i3-gaps nextcloud-client light xf86-input-wacom dunst libnotify notification-daemon vlc dmenu flameshot teamspeak3 blueman qt6-virtualkeyboard wireguard-tools --noconfirm --needed
sudo pacman -Sy texlive-most pulseaudio-bluetooth aspnet-runtime xournalpp remmina signal-desktop freerdp --needed --noconfirm
sudo pacman -Sy nomacs tlp tlp-rdw libreoffice mpv breeze breeze-icons libvncserver --needed --noconfirm
sudo pacman -Sy virt-manager qemu onboard chromium xf86-video-vesa --needed --noconfirm
sudo pacman -Sy dotnet-sdk aspnet-runtime aspnet-targeting-pack sof-firmware --needed --noconfirm
sudo pacman -Sy mesa steam lib32-mesa vulkan-intel intel-ucode --needed --confirm

sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable tlp
sudo systemctl start tlp
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

SetupWireguardClient
SetupJavaDevEnv
InstallJupyterNotebooks
SetupPythonDev
InstallGrubTheme 

echo "Installing AUR packages..."
InstallAurPackage "nvm" "https://aur.archlinux.org/nvm.git"
InstallAurPackage "mons" "https://aur.archlinux.org/mons.git"
InstallAurPackage "steam-fonts" "https://aur.archlinux.org/steam-fonts.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "breeze-obsidian-cursor-theme" "https://aur.archlinux.org/breeze-obsidian-cursor-theme.git"
InstallAurPackage "slack-desktop" "https://aur.archlinux.org/slack-desktop.git"

echo "Installing screenkey"
sudo pacman -Sy python2-setuptools --needed --noconfirm
InstallAurPackage "python2-distutils-extra" "https://aur.archlinux.org/python2-distutils-extra.git"
InstallAurPackage "screenkey" "https://aur.archlinux.org/screenkey.git"

echo "Enabling services ..."
sudo systemctl enable sddm

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

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.i3/workspaces/load-workspaces.sh

echo "Updating grub config"
sudo cp $scriptDir/overrides/grub/grub.cfg /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg  

echo "Regenerating initramfs"
sudo mkinitcpio -P
