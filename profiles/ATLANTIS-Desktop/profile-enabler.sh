#!/bin/bash
# ------------------------------
# Void Linux Install
# ------------------------------
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cp $scriptDir/overrides/packages.list ~/packages/xbps-mini-builder/packages.list
sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/web-greeter.yml /etc/lightdm/web-greeter.yml 
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo mkdir -p /etc/X11/xorg.conf.d/
sudo cp $scriptDir/overrides/xorg/10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/30-mouse.conf /etc/X11/xorg.conf.d/30-mouse.conf
mkdir -p ~/.local/share/applications

mkdir ~/.i3
mkdir ~/.i3/workspaces
mkdir ~/.i3/scripts

cp $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh

echo "Installing stuff ..."
sudo pacman -Sy i3-gaps nextcloud-client light dunst libnotify notification-daemon vlc dmenu flameshot teamspeak3 blueman wireguard-tools --noconfirm --needed
sudo pacman -Sy texlive-most biber pulseaudio-bluetooth aspnet-runtime xournalpp remmina signal-desktop freerdp --needed polybar --noconfirm
sudo pacman -Sy nomacs prusa-slicer obs-studio libreoffice mpv breeze breeze-icons libvncserver --needed --noconfirm
sudo pacman -Sy virt-manager qemu onboard --needed --noconfirm
sudo pacman -Sy dotnet-sdk aspnet-runtime aspnet-targeting-pack --needed --noconfirm
sudo pacman -Sy steam libdrm lib32-libdrm lib32-libglvnd libglvnd --needed --noconfirm

echo "Installing video drivers ..."
sudo pacman -Sy libva-mesa-driver lib32-mesa  --needed --noconfirm
InstallAurPackage "amdgpu-pro-installer" "https://aur.archlinux.org/amdgpu-pro-installer.git"
InstallAurPackage "obs-studio-amf" "https://aur.archlinux.org/obs-studio-amf.git"

echo "Installing AUR packages..."
InstallAurPackage "nvm" "https://aur.archlinux.org/nvm.git"
InstallAurPackage "mons" "https://aur.archlinux.org/mons.git"
InstallAurPackage "steam-fonts" "https://aur.archlinux.org/steam-fonts.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "breeze-obsidian-cursor-theme" "https://aur.archlinux.org/breeze-obsidian-cursor-theme.git"
InstallAurPackage "mesa-git" "https://aur.archlinux.org/mesa-git.git"

echo "Installing screenkey"
sudo pacman -Sy python2-setuptools --needed --noconfirm
InstallAurPackage "python2-distutils-extra" "https://aur.archlinux.org/python2-distutils-extra.git"
InstallAurPackage "screenkey" "https://aur.archlinux.org/screenkey.git"

InstallLitarvanLightDmTheme
InstallRustDev
InstallJupyterNotebooks
#SetupDotnet                # Use official dotnet packages instead
SetupJavaDevEnv
SetupJavaScriptDevEnv
SetupPythonDev
InstallGrubTheme -s 2k

echo "Installing rust/cargo stuff ..."
cargo install rustfmt

if [ ! -d ~/.omnisharp ]
then
    mkdir ~/.omnisharp
fi

echo "Setting up omnisharp ..."
rm -rf ~/.omnisharp
cp -Raf $scriptDir/../ATLANTIS-Surface/overrides/omnisharp ~/.omnisharp

echo "Enabling services ..."
EnableService lightdm
EnableService ckb-next-daemon
StartService ckb-next-daemon
EnableService bluetooth

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
SetupAutofsForSmbShare "FHNW" "data" "://fs.edu.ds.fhnw.ch/data"
