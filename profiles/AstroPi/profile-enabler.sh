#!/bin/sh
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh

echo "Please ensure that Arch Linux ARM was correclty setup prior to launching this profile installer!"
echo "Exit with Ctrl+C if not setup properly yet"

echo "Copying some files..."
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
cp $scriptDir/overrides/.xinitrc ~/.xinitrc
cp $scriptDir/overrides/xfce4/terminalrc ~/.config/xfce4/terminal/terminalrc
cp $scriptDir/overrides/xfce4/xfce4-desktop.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/ssh/sshd_config /etc/ssh/sshd_config
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/xrdp/startwm.sh /etc/xrdp/startwm.sh
sudo cp $scriptDir/overrides/samba/smb.conf /etc/samba/smb.conf
sudo cp $scriptDir/overrides/fxload/fxload /sbin/fxload
sudo chmod +x /sbin/fxload
mkdir -p ~/.local/share/kstars/astrometry
cp $scriptDir/overrides/kstars/astrometry.cfg ~/.local/share/kstars/astrometry/astrometry.cfg
mkdir ~/.indi
cp $scriptDir/overrides/indi/* ~/.indi/
cp $scriptDir/overrides/kstars/kstarsrc ~/.config/kstarsrc
sudo mkdir /data
sudo chown cobra:cobra /data
sudo chmod 700 /data
mkdir ~/.ssh
cp $scriptDir/overrides/ssh/authorized_keys ~/.ssh/authorized_keys

sudo chmod +x /etc/xrdp/startwm.sh

echo "Setting up gps and ntp"
sudo pacman -Sy ntp --needed --noconfirm
sudo cp $scriptDir/overrides/ntp/ntp.conf /etc/ntp.conf
sudo cp $scriptDir/overrides/gpsd/gpsd.conf /etc/default/gpsd
sudo ln -s /dev/ttyS0 /dev/gps0
sudo timedatectl set-ntp true
sudo systemctl enable ntpd
sudo systemctl start ntpd

echo "Importing keys"
gpg --keyserver keyserver.ubuntu.com --recv-keys 61ECEABBF2BB40E3A35DF30A9F72CDBC01BF10EB

echo "Setting up XFCE"
sudo pacman -Sy lxde firefox dnsmasq gpsd --noconfirm --needed

echo "Installing stuff ..."
InstallAurPackage "xrdp" "https://aur.archlinux.org/xrdp.git"
InstallAurPackage "xorgxrdp" "https://aur.archlinux.org/xorgxrdp.git"
InstallAurPackage "raspi-config-git" "https://aur.archlinux.org/raspi-config-git.git"

echo "Setting up xrdp ..."
sudo rm /etc/X11/Xwrapper.config
echo "allowed_users=anybody" | sudo tee /etc/X11/Xwrapper.config

echo "Setting up network .."
SetupHotspot "wlan0" "ATLANTIS-ASTRO-PI1-AP" true
sudo mkdir /usr/share/scripts
sudo cp ~/.scripts/networking/startHotspotATLANTIS-ASTRO-PI1-AP /usr/share/scripts/startHotspot.sh
sudo cp $scriptDir/overrides/hotspot.service /etc/systemd/system/hotspot.service
sudo systemctl daemon-reload
sudo systemctl enable mymonitor.service
sudo chmod u+x /usr/share/scripts/startHotspot.sh
InstallAurPackage "libhdf5" "https://aur-dev.archlinux.org/libhdf5.git"

echo "Enabling services"
sudo systemctl enable lightdm.service
sudo systemctl enable xrdp
sudo systemctl start xrdp
sudo systemctl enable smb.service
sudo systemctl start smb.service

echo "Setting up astronomy stuff .."
sudo pacman -Sy gpsd libdc1394 --noconfirm --needed
sudo pacman -Sy --noconfirm --needed wcslib opencv ccfits netpbm breeze-icons binutils patch cmake make libraw gpsd gcc
sudo pacman -Sy --noconfirm --needed kstars libindi

InstallAstroPy
CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
# InstallIndi
CloneOrUpdateGitRepoToPackages "indi-3rdparty" "--depth=1 https://github.com/indilib/indi-3rdparty"
InstallIndiDriver "fxload"
InstallIndiDriver "fxload-libusb"
InstallIndiDriver "indi-gphoto"
InstallIndiDriver "libasi"
InstallIndiDriver "libatik"
InstallIndiDriver "indi-atik"
InstallIndiDriver "indi-asi"
InstallIndiDriver "libqhy"
InstallIndiDriver "indi-qhy"
InstallIndiDriver "indi-gpsd"
# InstallKstars
InstallAstrometryNet
DownloadIndexFiles
CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallPHD2

echo "Adjust user permissions"
currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G tty ${currentUser}
sudo usermod -a -G users ${currentUser}
sudo smbpasswd -a ${currentUser}

sudo chown ${currentUser} ~/.xinitrc

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.config/xfce4/terminal/terminalrc

echo "ATLANTIS-ASTRO-PI" | sudo tee /etc/hostname
