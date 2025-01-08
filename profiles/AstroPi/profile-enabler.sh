#!/bin/sh
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh

echo "Please ensure that Arch Linux ARM was correctly setup prior to launching this profile installer!"
echo "Exit with Ctrl+C if not setup properly yet"

echo "Copying some files..."
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/ssh/sshd_config /etc/ssh/sshd_config
sudo cp $scriptDir/overrides/samba/smb.conf /etc/samba/smb.conf
chmod +x ~/.xinitrc
mkdir -p ~/.local/share/kstars/astrometry
cp $scriptDir/overrides/kstars/astrometry.cfg ~/.local/share/kstars/astrometry/astrometry.cfg
mkdir ~/.indi
sudo mkdir /data
sudo chown $USER:$USER /data
sudo chmod 700 /data
mkdir ~/.ssh
cp $scriptDir/overrides/ssh/authorized_keys ~/.ssh/authorized_keys

echo "Setting up gps and ntp"
sudo pacman -Sy ntp --needed --noconfirm
sudo cp $scriptDir/overrides/ntp/ntp.conf /etc/ntp.conf
sudo cp $scriptDir/overrides/gpsd/gpsd.conf /etc/default/gpsd
sudo cp $scriptDir/overrides/udev/09-pps.rules /etc/udev/rules.d/09-pps.rules
sudo cp $scriptDir/overrides/udev/25-gpsd-usb.rules /etc/udev/rules.d/25-gpsd-usb.rules
sudo cp $scriptDir/overrides/boot/config.txt /boot/config.txt
sudo cp $scriptDir/overrides/boot/cmdline.txt /boot/cmdline.txt
sudo cp $scriptDir/overrides/modules/pps.conf /etc/modules-load.d/pps.conf
sudo ln -s /dev/ttyS1 /dev/gps0
sudo timedatectl set-ntp true
sudo systemctl enable ntpd
sudo systemctl start ntpd

echo "Importing keys"
gpg --keyserver keyserver.ubuntu.com --recv-keys 61ECEABBF2BB40E3A35DF30A9F72CDBC01BF10EB


echo "Installing stuff ..."
sudo pacman -Sy firefox tigervnc dnsmasq --noconfirm --needed
sudo pacman -Sy lxde --noconfirm --needed
# CompileFixedUBootForRpi4 $scriptDir

# InstallWayland
# InstallHyprland

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
sudo systemctl enable smb.service
sudo systemctl start smb.service
sudo systemctl enable gpsd.service
sudo systemctl start gpsd.service
sudo systemctl stop sddm
sudo systemctl disable sddm

echo "Setting up astronomy stuff .."
sudo pacman -Sy gpsd libdc1394 sof-firmware xf86-video-fbdev --noconfirm --needed
sudo pacman -Sy --noconfirm --needed wcslib opencv ccfits netpbm breeze-icons binutils patch cmake make libraw gpsd gcc gsl

echo "Setting up gpsd console"
sudo stty -F /dev/ttyS1 raw 9600 cs8 clocal -cstopb

echo "Setting up VNC server"
sudo cp $scriptDir/overrides/vnc/vncserver.users /etc/tigervnc/vncserver.users
sudo cp $scriptDir/overrides/vnc/vncserver-config-mandatory /etc/tigervnc/vncserver-config-mandatory
echo "Setting vnc password:"
vncpasswd
sudo systemctl enable vncserver@:1
sudo systemctl start vncserver@:1

InstallAurPackage "astrometry.net" "https://aur.archlinux.org/astrometry.net.git"
InstallIndi
InstallFxLoad
CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"

# InstallIndi drivers
CloneOrUpdateGitRepoToPackages "indi-3rdparty" "--depth=1 https://github.com/indilib/indi-3rdparty"
InstallIndiDriver "indi-gphoto"
InstallIndiDriver "libasi"
InstallIndiDriver "libatik"
InstallIndiDriver "indi-atik"
InstallIndiDriver "indi-asi"
InstallIndiDriver "libqhy"
InstallIndiDriver "indi-qhy"
InstallIndiDriver "indi-gpsd"

# InstallKstars
sudo pacman -Sy --noconfirm --needed kstars
InstallAstrometryNet
DownloadIndexFiles
#CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallAurPackage "phd2" "https://aur.archlinux.org/phd2.git"
# InstallAurPackage "astap" "https://aur.archlinux.org/astap.git"
# InstallAurPackage "d50-star-db-astap" "https://aur.archlinux.org/d50-star-db-astap.git"

# Install missing firmwares for hardware devices
sudo pacman -S linux-firmware-qlogic --needed --noconfirm
InstallAurPackage "wd719x-firmware" "https://aur.archlinux.org/wd719x-firmware.git"
InstallAurPackage "ast-firmware" "https://aur.archlinux.org/ast-firmware.git"


echo "Adjust user permissions"
currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G tty ${currentUser}
sudo usermod -a -G users ${currentUser}
sudo usermod -a -G wheel ${currentUser}
sudo usermod -a -G disk ${currentUser}
sudo smbpasswd -a ${currentUser}

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "Documents" "://192.168.1.12/Documents" "Downloads" "://192.168.1.12/Downloads" "Software" "://192.168.1.12/Software" "Astrophotography" "://192.168.1.12/Astrophotography" "Backup" "://192.168.1.12/Backup"

sudo chown ${currentUser} ~/.xinitrc

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile

echo "ATLANTIS-ASTRO-PI" | sudo tee /etc/hostname
sudo mkinitcpio -P

cd /boot
sudo bash ./mkscr
