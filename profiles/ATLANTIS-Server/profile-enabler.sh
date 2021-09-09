#!/bin/bash
# Void Linux Install
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cp $scriptDir/overrides/packages.list ~/packages/xbps-mini-builder/packages.list
sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
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
if [ ! -f /etc/wireguard/ATLANTIS-Net.conf]; then
    sudo cp $scriptDir/overrides/wireguard/ATLANTIS-Net.conf /etc/wireguard/ATLANTIS-Net.conf
fi
sudo chmod 700 /etc/wireguard/ATLANTIS-Net.conf
sudo mkdir -p /etc/samba
sudo cp $scriptDir/overrides/samba/smb.conf /etc/samba/smb.conf
sudo mkdir -p /etc/php/php-fpm.d
sudo cp $scriptDir/overrides/php/php.ini /etc/php/php.ini
sudo cp $scriptDir/overrides/php/php-fpm.conf /etc/php/php-fpm.conf
sudo cp $scriptDir/overrides/php/www.conf /etc/php/php-fpm.d/www.conf
sudo mkdir -p /etc/nginx/sites-available
sudo mkdir -p /etc/nginx/sites-enabled
sudo cp $scriptDir/overrides/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp $scriptDir/overrides/nginx/nextcloud /etc/nginx/sites-available/nextcloud
sudo mkdir -p /data


sudo cp $scriptDir/overrides/sysctl.conf /etc/sysctl.conf
sudo sysctl -p

mkdir ~/.i3
mkdir ~/.i3/workspaces
mkdir ~/.i3/scripts

cp $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh

echo "Installing stuff..."
sudo xbps-install -y linux-firmware-amd network-manager-applet lightdm lightdm-webkit2-greeter light-locker firefox arc-theme arc-icon-theme nautilus 
sudo xbps-install -y i3-gaps dunst libnotify notification-daemon dmenu pavucontrol flameshot nextcloud-client cabextract xf86-input-evdev
sudo xbps-install -y qemu virt-manager php php-fpm php-gd php-mysql php-intl nginx certbot certbot-nginx php-imagick php-sodium
sudo xbps-install -y polybar python3-vdf protontricks vscode ckb-next screenkey vscode gnuplot
sudo xbps-install -y xf86-video-amdgpu amdvlk mesa cryptsetup tpm2-tss dcron
sudo xbps-install -y nomacs breeze breeze-cursors samba
sudo xbps-install -y mdadm wireguard tigervnc

InstallXorg
InstallLitarvanLightDmTheme
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
EnableService lightdm
EnableService sshd
EnableService mdadm
EnableService libvirtd
EnableService virtlockd
EnableService virtlogd
EnableService nginx
EnableService smbd
EnableService wireguard
EnableService php-fpm

crontab ~/.config/customCronConfig

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
sudo mkdir -p /etc/sv/vncserver-cobra/
sudo cp $scriptDir/overrides/vnc/vncserverruncobra /etc/sv/vncserver-cobra/run
sudo chmod +x /etc/sv/vncserver-cobra/run

EnableService vncserver-cobra
