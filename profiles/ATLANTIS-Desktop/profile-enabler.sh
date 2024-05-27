#!/bin/bash

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" . $scriptDir/../../functions/htcVivePro2Functions.sh

sudo mkdir -p /etc/X11/xorg.conf.d/
sudo cp $scriptDir/overrides/xorg/10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/21-amdgpu.conf /etc/X11/xorg.conf.d/21-amdgpu.conf
sudo cp $scriptDir/overrides/xorg/30-mouse.conf /etc/X11/xorg.conf.d/30-mouse.conf
sudo cp $scriptDir/overrides/grub/grub /etc/default/grub
sudo cp $scriptDir/overrides/udev/30-amdgpu-pm.rules /etc/udev/rules.d/30-amdgpu-pm.rules
cp $scriptDir/overrides/hyprland/monitors.conf ~/.config/hypr/monitors.conf
cp $scriptDir/overrides/hyprland/custom-execs.conf ~/.config/hypr/configs/custom-execs.conf
cp $scriptDir/overrides/hyprland/custom-config.conf ~/.config/hypr/configs/custom-config.conf
cp $scriptDir/overrides/hyprland/custom-envs.conf ~/.config/hypr/configs/custom-envs.conf
cp $scriptDir/overrides/waybar/bar-output.json ~/.config/waybar/bar-output.json
cp $scriptDir/overrides/waybar/custom-modules-config.json ~/.config/waybar/custom-modules-config.json
mkdir -p ~/.local/share/applications

echo "Installing stuff ..."
sudo pacman -Sy nextcloud-client dunst libnotify notification-daemon vlc flameshot teamspeak3 blueman wireguard-tools --noconfirm --needed
sudo pacman -Sy texlive biber aspnet-runtime xournalpp remmina signal-desktop freerdp --needed polybar --noconfirm
sudo pacman -Sy prusa-slicer obs-studio libreoffice breeze breeze-icons libvncserver --needed --noconfirm
sudo pacman -Sy virt-manager qemu onboard --needed --noconfirm
sudo pacman -Sy dotnet-sdk aspnet-runtime aspnet-targeting-pack --needed --noconfirm
sudo pacman -Sy amd-ucode steam libdrm mesa lib32-libdrm lib32-libglvnd libglvnd --needed --noconfirm
sudo pacman -Sy polkit-kde-agent gamemode --needed --noconfirm

echo "Installing video drivers ..."
sudo pacman -Sy libva-mesa-driver lib32-mesa mesa mesa-vdpau vulkan-mesa-layers --needed --noconfirm
sudo pacman -Sy vulkan-radeon lib32-vulkan-radeon --needed --noconfirm
sudo pacman -Sy rocm-hip-sdk rocm-opencl-sdk rocm-hip-runtime hip-runtime-amd miopen-hip --needed --noconfirm
# InstallAurPackage "amdgpu-pro-installer" "https://aur.archlinux.org/amdgpu-pro-installer.git"
InstallAurPackage "lact" "https://aur.archlinux.org/lact.git"
InstallAurPackage "proton-ge-custom-bin" "https://aur.archlinux.org/proton-ge-custom-bin.git"
# sudo pacman -R vulkan-amdgpu-pro --noconfirm --needed

echo "Installing AUR packages..."
InstallMpv
InstallAurPackage "nvm" "https://aur.archlinux.org/nvm.git"
InstallAurPackage "mons" "https://aur.archlinux.org/mons.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "breeze-obsidian-cursor-theme" "https://aur.archlinux.org/breeze-obsidian-cursor-theme.git"
InstallAurPackage "jellyfin-media-player" "https://aur.archlinux.org/jellyfin-media-player.git"
InstallAurPackage "ckb-next" "https://aur.archlinux.org/ckb-next.git"
InstallAurPackage "cvmfs" "https://aur.archlinux.org/cvmfs.git"
InstallAurPackage "slack-desktop" "https://aur.archlinux.org/slack-desktop.git"
InstallAurPackage "ledger-udev" "https://aur.archlinux.org/ledger-udev.git"
InstallAurPackage "ledger-live-bin" "https://aur.archlinux.org/ledger-live-bin.git"

echo "Installing drivers for other devices"
InstallAurPackage "wd719x-firmware" "https://aur.archlinux.org/wd719x-firmware.git"
InstallAurPackage "upd72020x-fw" "https://aur.archlinux.org/upd72020x-fw.git"
InstallAurPackage "aic94xx-firmware" "https://aur.archlinux.org/aic94xx-firmware.git"
InstallAurPackage "ast-firmware" "https://aur.archlinux.org/ast-firmware.git"
sudo pacman -Sy	linux-firmware-qlogic --needed --noconfirm

echo "Installing screenkey"
sudo pacman -Sy python2-setuptools --needed --noconfirm
InstallAurPackage "python2-distutils-extra" "https://aur.archlinux.org/python2-distutils-extra.git"
InstallAurPackage "screenkey" "https://aur.archlinux.org/screenkey.git"
EnableService "lactd"
StartService "lactd"

InstallWayland
InstallHyprland
InstallRustDev
InstallJupyterNotebooks
SetupDotnet
SetupJavaDevEnv
SetupJavaScriptDevEnv
SetupPythonDev
SetupLatex
InstallGrubTheme -s 4k
PreSteamSetupVivePro2
PostSteamSetupVivePro2

echo "Installing rust/cargo stuff ..."
cargo install rustfmt

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
sudo usermod -a -G wheel ${currentUser}

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.i3/workspaces/load-workspaces.sh

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "Documents" "://192.168.1.12/Documents" "Downloads" "://192.168.1.12/Downloads" "Software" "://192.168.1.12/Software" "Astrophotography" "://192.168.1.12/Astrophotography" "Backup" "://192.168.1.12/Backup"
SetupAutofsForSmbShare "FHNW" "data" "://fs.edu.ds.fhnw.ch/data"

echo "Fixing SE clipboard copy and paste"
if [ -d  ~/.steam/steam/steamapps/common/SpaceEngineers ]; then
		CloneOrUpdateGitRepoToPackages "CosmicWineFixes" "https://github.com/opekope2/CosmicWineFixes"
		cd ~/packages/CosmicWineFixes
		ln -s ~/.steam/steam/steamapps/common/SpaceEngineers/Bin64 Bin64
		dotnet build
		cp $scriptDir/overrides/SpaceEngineers/SpaceEngineersLauncher.py ~/.steam/steam/steamapps/common/SpaceEngineers/Bin64/SpaceEngineersLauncher.py
		chmod +x ~/.steam/steam/steamapps/common/SpaceEngineers/Bin64/SpaceEngineersLauncher.py
		# Also set launch options in steam to ./SpaceEngineersLauncher.py %command%
		wget https://github.com/sepluginloader/SpaceEngineersLauncher/releases/download/v1.0.6/SpaceEngineersLauncher.exe -O ~/.steam/steam/steamapps/common/SpaceEngineers/Bin64/SpaceEngineersLauncher.exe
fi
