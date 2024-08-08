#!/bin/sh
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh

echo "Please ensure that Arch Linux ARM was correctly setup prior to launching this profile installer!"
echo "Exit with Ctrl+C if not setup properly yet"

echo "Copying some files..."
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/ssh/sshd_config /etc/ssh/sshd_config
sudo cp $scriptDir/overrides/xrdp/startwm.sh /etc/xrdp/startwm.sh
sudo cp $scriptDir/overrides/samba/smb.conf /etc/samba/smb.conf
cp $scriptDir/overrides/hyprland/custom-execs.conf ~/.config/hypr/configs/custom-execs.conf
cp $scriptDir/overrides/hyprland/custom-config.conf ~/.config/hypr/configs/custom-config.conf
cp $scriptDir/overrides/hyprland/custom-envs.conf ~/.config/hypr/configs/custom-envs.conf
# mkdir -p ~/.local/share/kstars/astrometry
# cp $scriptDir/overrides/kstars/astrometry.cfg ~/.local/share/kstars/astrometry/astrometry.cfg
mkdir ~/.indi
sudo mkdir /data
sudo chown $USER:$USER /data
sudo chmod 700 /data
mkdir ~/.ssh
cp $scriptDir/overrides/ssh/authorized_keys ~/.ssh/authorized_keys

sudo chmod +x /etc/xrdp/startwm.sh

echo "Setting up gps and ntp"
sudo pacman -Sy ntp --needed --noconfirm
sudo cp $scriptDir/overrides/ntp/ntp.conf /etc/ntp.conf
sudo cp $scriptDir/overrides/gpsd/gpsd.conf /etc/default/gpsd
sudo cp $scriptDir/overrides/udev/09-pps.rules /etc/udev/rules.d/09-pps.rules
sudo cp $scriptDir/overrides/udev/25-gpsd-usb.rules /etc/udev/rules.d/25-gpsd-usb.rules
sudo cp $scriptDir/overrides/boot/config.txt /boot/config.txt
sudo cp $scriptDir/overrides/modules/pps.conf /etc/modules-load.d/pps.conf
sudo ln -s /dev/ttyS0 /dev/gps0
sudo timedatectl set-ntp true
sudo systemctl enable ntpd
sudo systemctl start ntpd

echo "Importing keys"
gpg --keyserver keyserver.ubuntu.com --recv-keys 61ECEABBF2BB40E3A35DF30A9F72CDBC01BF10EB


echo "Installing stuff ..."
InstallAurPackage "raspi-config-git" "https://aur.archlinux.org/raspi-config-git.git"
InstallAurPackage "elogind" "https://aur.archlinux.org/elogind.git"
sudo pacman -Sy firefox dnsmasq gpsd --noconfirm --needed
sudo pacman -Sy wayvnc xfce4 --noconfirm --needed
InstallAurPackage "xrdp" "https://aur.archlinux.org/xrdp.git"
InstallAurPackage "xorgxrdp" "https://aur.archlinux.org/xorgxrdp.git"
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
sudo systemctl enable elogind
sudo systemctl start elogind

echo "Setting up astronomy stuff .."
sudo pacman -Sy gpsd libdc1394 sof-firmware --noconfirm --needed
sudo pacman -Sy --noconfirm --needed wcslib opencv ccfits netpbm breeze-icons binutils patch cmake make libraw gpsd gcc gsl

# InstallAurPackage "astrometry.net" "https://aur.archlinux.org/astrometry.net.git"
InstallAstroPy
InstallIndi
InstallFxLoad
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
InstallIndiDriver "libsv305" # Somehow needed by phd2
InstallIndiDriver "indi-sv305" # Somehow needed by phd2
# InstallKstars
sudo pacman -Sy --noconfirm --needed kstars
# InstallAstrometryNet
DownloadIndexFiles
#CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallAurPackage "phd2" "https://aur.archlinux.org/phd2.git"
InstallAurPackage "astap" "https://aur.archlinux.org/astap.git"
InstallAurPackage "d50-star-db-astap" "https://aur.archlinux.org/d50-star-db-astap.git"

# Install missing firmwares for hardware devices
sudo pacman -S linux-firmware-qlogic --needed --noconfirm
InstallAurPackage "wd719x-firmware" "https://aur.archlinux.org/wd719x-firmware.git"


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
sudo mkinitcpio -P
