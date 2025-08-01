#!/bin/bash

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. ./functions/voidPackagesFunctions.sh
. ./functions/runitFunctions.sh

sudo xbps-install -Su xbps
sudo xbps-install -Syu
sudo xbps-install -Sy wget git

echo "Updating file permissions ..."
chmod +x ~/.profile
chmod +x ~/.zprofile
chmod -R +x ~/.scripts
chmod 700 ~/.gnupg -R

cp ~/Nextcloud/Wallpapers/* -r ~/wallpapers/
mkdir -p ~/.ssh
cp ~/Nextcloud/Documents/ssh_config ~/.ssh/config

source ~/.profile

echo "Installing stuff..."
InstallPowerLineFonts
sudo xbps-install -y fakeroot gcc boost ffmpeg make cmake bash-completion zsh zsh-completions automake m4 autoconf
sudo xbps-install -y NetworkManager dbus dbus-x11 elogind accountsservice gnome-keyring font-adobe-source-code-pro neofetch xclip
sudo xbps-install -y feh picom libspa-bluetooth netcat
sudo xbps-install -y openjdk-jre autofs xdotool chrony ksshaskpass socklog-void rsync rclone
sudo xbps-install -y vim neovim neovim-remote libftdi1 cfitsio void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
sudo xbps-install -y python python3 python-pip samba opencv gtest wxWidgets-gtk3 libmpdclient ranger binutils keychain lftp
sudo xbps-install -y htop kitty ImageMagick zlib xdg-utils curl exfat-utils unzip shadow perl-AnyEvent-I3 perl-JSON-XS git-lfs pywal fzf arandr pass patch ncurses ncurses-devel
sudo xbps-install -y zsh-syntax-highlighting xfce4-power-manager openvpn zsh-autosuggestions calc NetworkManager-openvpn zathura zathura-cb zathura-pdf-mupdf zathura-ps lynx dejavu-fonts-ttf
sudo xbps-install -y dkms linux-headers linux-firmware gnupg2 gnupg2-scdaemon pcsclite pcsc-ccid eudev smbclient cifs-utils debootstrap inetutils-ftp
sudo xbps-install -y ueberzug redshift nerd-fonts cava dcron nodejs quazip pinentry-gtk dracut-network psmisc base-devel openconnect NetworkManager-openconnect qt5-plugin-sqlite
sudo xbps-install -y tar zip xz glibc-32bit keyutils bc elfutils-devel flex gmp-devel kmod libmpc-devel openssl-devel perl uboot-mkimage cpio pahole python3 vips lm_sensors

InstallXbpsMiniBuilder
UpdateRestrictedPackages

# Set default apps
xdg-mime default zathura.desktop application/pdf
xdg-mime default nvim text/plain
xdg-mime default nvim text/css
xdg-mime default nvim text/csv
xdg-mime default nvim text/xml

git lfs install
git lfs pull

echo "Changing default shell to zsh"
if [[ "$SHELL" != "/bin/zsh" ]]; then
	chsh -s /bin/zsh
fi

echo "Setting up oh-my-zsh ..."
if [ ! -d ${ZSH} ]; then
	ZSH=${ZSH} bash -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended --keep-zshrc
fi

if [ ! -d ${ZSH}/themes/powerlevel10k ]; then
	cd ${ZSH}/themes
	echo "Cloning powerlevel10k"
	git clone https://github.com/romkatv/powerlevel10k.git ${ZSH}/themes/powerlevel10k
else
	cd ${ZSH}/themes/powerlevel10k
	echo "Updating powerlevel10k"
	git pull
fi

if [ ! -d ${ZPLUG_HOME} ]; then
	git clone https://github.com/zplug/zplug $ZPLUG_HOME
else
	cd ${ZPLUG_HOME}
	git pull
fi

zplug update

EnableService dbus
StartService dbus
EnableService elogind
StartService elogind
EnableService eudevd
EnableService polkitd
EnableService socklog-unix
EnableService nanoklogd
StartService nanoklogd
StartService polkitd
StopService dhcpcd
DisableService dhcpcd
EnableService NetworkManager
StartService NetworkManager
EnableService autofs
StartService autofs
EnableService chronyd
StartService chronyd

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Copying default ranger config ..."
ranger --copy-config=all

echo "Setting up vim..."
BasicVimInstall

echo "Setting up git"
if grep -q "gitalias" "$HOME/.gitconfig"; then
	echo "Git aliases already set up"
else
	echo "[include]" >>~/.gitconfig
	echo "    path = ~/.scripts/gitalias" >>~/.gitconfig
fi
if grep -q "gitconfig" "$HOME/.gitconfig"; then
	echo "Git config already set up"
else
	echo "[include]" >>~/.gitconfig
	echo "    path = ~/.scripts/gitconfig" >>~/.gitconfig
fi

echo "Enabling services ..."
EnableService dcron
StartService dcron

echo "Applying default cron-config ..."
crontab ~/.config/defaultCronConfig

echo "Copying some default files ..."
sudo rm -rf /usr/share/backgrounds/*
SetupBackgroundsFolderForBing
bash ~/.scripts/updateLoginBackground.sh # Execute it ones, to get a new background

echo "Downloading your public key"
gpg2 --recv 0xB4B88025927E502D

echo "Removing obsolete kernels"
sudo vkpurge rm all

echo "Scanning for fans"
if [[ ! -f /etc/conf.d/lm_sensors ]]; then
	sudo sensors-detect --auto
fi

echo "Updating Python packages ..."
UpdatePipPackages

# Dark Theme by default
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

echo "Installing python packages"
sudo -H pip install --upgrade youtube-dl
