#!/bin/bash
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cp $scriptDir/overrides/packages.list ~/packages/xbps-mini-builder/packages.list
sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo mkdir -p /etc/X11/xorg.conf.d/
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/30-mouse.conf /etc/X11/xorg.conf.d/30-mouse.conf
mkdir -p ~/.local/share/applications
cp $scriptDir/overrides/mimeapps.list ~/.local/share/applications/mimeapps.list
sudo cp $scriptDir/overrides/mimeapps.list /usr/share/applications/defaults.list
sudo rm /usr/share/applications/mimeinfo.cache
rm ~/.local/share/applications/mimeinfo.cache

mkdir ~/.i3
mkdir ~/.i3/workspaces
mkdir ~/.i3/scripts

cp $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh

echo "Installing stuff..."
sudo xbps-install -y linux-firmware-amd network-manager-applet lightdm lightdm-webkit2-greeter light-locker firefox arc-theme arc-icon-theme nautilus 
sudo xbps-install -y i3-gaps nvidia dunst libnotify notification-daemon dmenu pavucontrol flameshot nextcloud-client cabextract blueman Signal-Desktop 
sudo xbps-install -y nvidia-libs remmina freerdp xf86-input-evdev PrusaSlicer texlive-most
sudo xbps-install -y polybar python3-vdf protontricks vscode ckb-next screenkey vscode gnuplot
sudo xbps-install -y steam libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit nvidia-libs-32bit
sudo xbps-install -y nomacs libreoffice mpv breeze breeze-cursors

InstallXorg
InstallLitarvanLightDmTheme
InstallRustDev
InstallYubiKeyStuff
SetupDotnet

echo "Installing restricted packages ..."
InstallRestrictedPackageFromCache hostdir/binpkgs/nonfree teams-bin
InstallRestrictedPackageFromCache hostdir/binpkgs/nonfree pritunl-client
InstallRestrictedPackageFromCache hostdir/binpkgs/nonfree teamspeak3

echo "Installing rust/cargo stuff ..."
cargo install rustfmt

if [ ! -d ~/.omnisharp ]
then
    mkdir ~/.omnisharp
fi

echo "Setting up omnisharp ..."
rm -rf ~/.omnisharp
cp -Raf $scriptDir/../surface-book/overrides/omnisharp ~/.omnisharp

echo "Enabling services ..."
EnableService lightdm
EnableService ckb-next-daemon
StartService ckb-next-daemon

currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G users ${currentUser}
sudo usermod -a -G audio ${currentUser}
sudo usermod -a -G radio ${currentUser}

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.i3/workspaces/load-workspaces.sh

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "Documents" "://192.168.1.12/Documents" "Downloads" "://192.168.1.12/Downloads" "Software" "://192.168.1.12/Software" "Astrophotography" "://192.168.1.12/Astrophotography" "Backup" "://192.168.1.12/Backup"
SetupAutofsForSmbShare "ATLANTIS-ASTRO-PI1" "data" "://10.42.0.1/data"
