#!/bin/bash
# Void Linux Install
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cp $scriptDir/overrides/packages.list ~/packages/xbps-mini-builder/packages.list
sudo mkdir -p /etc/X11/xorg.conf.d/
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/30-mouse.conf /etc/X11/xorg.conf.d/30-mouse.conf
mkdir -p ~/.ssh
cp $scriptDir/overrides/ssh/authorized_keys ~/.ssh/authorized_keys
sudo cp $scriptDir/overrides/ssh/sshd_config /etc/ssh/sshd_config
cp $scriptDir/overrides/mimeapps.list ~/.local/share/applications/mimeapps.list
sudo cp $scriptDir/overrides/mimeapps.list /usr/share/applications/defaults.list
sudo rm /usr/share/applications/mimeinfo.cache
rm ~/.local/share/applications/mimeinfo.cache
cp $scriptDir/overrides/dcronConfig ~/.config/customCronConfig
sudo cp $scriptDir/overrides/networking/interfaces /etc/network/interfaces
sudo mkdir -p /etc/mdadm
sudo cp $scriptDir/overrides/mdadm/mdadm.conf /etc/mdadm/mdadm.conf
sudo cp $scriptDir/overrides/docker/daemon.json /etc/docker/daemon.json
if [ ! -f /etc/wireguard/ATLANTIS-Net.conf]; then
    sudo cp $scriptDir/overrides/wireguard/ATLANTIS-Net.conf /etc/wireguard/ATLANTIS-Net.conf
fi
sudo chmod 700 /etc/wireguard/ATLANTIS-Net.conf
sudo mkdir -p /etc/samba
sudo cp $scriptDir/overrides/samba/smb.conf /etc/samba/smb.conf
sudo mkdir -p /data
sudo cp ~/.scripts/utilities/updateAndReboot /root/updateAndReboot
sudo cp ~/.scripts/networking/updateSslCertbot /usr/bin/updateSslCertbot
sudo chmod +x /usr/bin/updateSslCertbot


sudo cp $scriptDir/overrides/sysctl.conf /etc/sysctl.conf
sudo sysctl -p

mkdir ~/.i3
mkdir ~/.i3/workspaces
mkdir ~/.i3/scripts

cp $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh

echo "Installing stuff..."
sudo xbps-install -y linux-firmware-amd network-manager-applet firefox arc-theme arc-icon-theme nautilus 
sudo xbps-install -y i3-gaps dunst libnotify notification-daemon dmenu pavucontrol flameshot nextcloud-client cabextract xf86-input-evdev
sudo xbps-install -y qemu virt-manager smartmontools
sudo xbps-install -y polybar python3-vdf protontricks vscode ckb-next screenkey vscode gnuplot
sudo xbps-install -y xf86-video-amdgpu vulkan-loader mesa cryptsetup tpm2-tss cronie mesa-vaapi mesa-vdpau mesa-vulkan-radeon mesa-dri
sudo xbps-install -y nomacs breeze breeze-cursors samba
sudo xbps-install -y mdadm wireguard tigervnc docker postfix

InstallXorg
InstallYubiKeyStuff
SetupDotnet
SetupWireguardServer
SetupMariaMySqlDb

echo "Setting default apps overrides"
xdg-mime default nomacs.desktop image/jpeg
xdg-mime default nomacs.desktop image/png
xdg-mime default nomacs.desktop image/tiff
xdg-mime default nomacs.desktop image/jpg

echo "Installing restricted packages ..."
InstallRestrictedPackageFromCache hostdir/binpkgs/nonfree teams-bin
InstallRestrictedPackageFromCache hostdir/binpkgs/nonfree pritunl-client
InstallRestrictedPackageFromCache hostdir/binpkgs/nonfree teamspeak3

echo "Enabling services ..."
EnableService sshd
EnableService mdadm
EnableService smartd
EnableService libvirtd
EnableService virtlockd
EnableService virtlogd
EnableService smbd
EnableService wireguard
EnableService docker
EnableService cronie
EnableService postfix

echo "Ensure smartctl watches RAID devices"
sudo smartctl --smart=on --offlineauto=on --saveauto=on /dev/sda 
sudo smartctl --smart=on --offlineauto=on --saveauto=on /dev/sdb 
sudo smartctl --smart=on --offlineauto=on --saveauto=on /dev/sdc 
sudo smartctl --smart=on --offlineauto=on --saveauto=on /dev/sdd 

crontab ~/.config/customCronConfig
sudo crontab $scriptDir/overrides/defaultRootCronCfg


sudo groupadd ssh_access
sudo groupadd basicfilesharing

currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G users ${currentUser}
sudo usermod -a -G audio ${currentUser}
sudo usermod -a -G radio ${currentUser}
sudo usermod -a -G ssh_access ${currentUser}
sudo usermod -a -G basicfilesharing ${currentUser}
sudo usermod -a -G libvirt ${currentUser}
sudo usermod -a -G wheel ${currentUser}

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.i3/workspaces/load-workspaces.sh


echo "Setting up vnc server ..."
sudo mkdir -p /etc/vnc/
sudo cp $scriptDir/overrides/vnc/config /etc/vnc/config
sudo mkdir -p /home/cobra/.vnc/
sudo cp $scriptDir/overrides/vnc/configCobra /home/cobra/.vnc/config
sudo cp $scriptDir/overrides/vnc/xstartupcobra /home/cobra/.vnc/xstartup
sudo chmod +x /home/cobra/.vnc/xstartup
sudo chown cobra:cobra /home/cobra/.vnc -R

updateDockerContainersServer
