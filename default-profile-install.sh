#!/bin/bash

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

sudo xbps-install -Su xbps
sudo xbps-install -Syu
sudo xbps-install -Sy wget git

echo "Updating file permissions ..."
chmod +x ~/.xinitrc
chmod +x ~/.config/.xinitrc
chmod +x ~/.profile
chmod +x ~/.zprofile
chmod +x ~/.config/i3/config
chmod +x ~/.config/polybar/config
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/network-traffic.sh
chmod +x ~/.config/xfce4/terminal/terminalrc
chmod +x ~/.i3/scripts/launch-picom.sh
chmod +x ~/.i3/scripts/launch-autostart.sh
chmod +x ~/.i3/scripts/set-background.sh
chmod -R +x ~/.scripts
chmod 700 ~/.gnupg -R

cp ~/Nextcloud/Wallpapers/* -r ~/wallpapers/

source ~/.profile

echo "Installing stuff..."
InstallPowerLineFonts
sudo xbps-install -Sy fakeroot gcc boost ffmpeg make cmake font-fira-otf font-firacode bash-completion zsh zsh-completions automake m4 autoconf
sudo xbps-install -Sy NetworkManager dbus dbus-x11 elogind accountsservice gnome-keyring font-adobe-source-code-pro neofetch xclip
sudo xbps-install -Sy feh xfce4-terminal picom alsa-lib pulseaudio alsa-plugins-pulseaudio libspa-bluetooth
sudo xbps-install -Sy openjdk-jre autofs xdotool
sudo xbps-install -Sy vim neovim libftdi1 cfitsio void-repo-nonfree{,-nonfree}
sudo xbps-install -Sy python python3 python-pip samba opencv gtest wxWidgets-gtk3 libmpdclient bc ranger binutils keychain
sudo xbps-install -Sy htop ImageMagick zlib xdg-utils curl exfat-utils unzip shadow perl-AnyEvent-I3 perl-JSON-XS git-lfs pywal fzf arandr pass
sudo xbps-install -Sy zsh-syntax-highlighting xfce4-power-manager openvpn zsh-autosuggestions calc NetworkManager-openvpn zathura zathura-cb zathura-pdf-mupdf zathura-ps lynx dejavu-fonts-ttf
sudo xbps-install -Sy dkms linux-headers gnupg2 pcsclite pcsc-ccid eudevd smbclient cifs-utils
sudo xbps-install -Sy ueberzug nerd-fonts cava dcron nodejs quazip

# Set default apps
xdg-mime default zathura.desktop application/pdf

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
StartService polkitd
StopService dhcpcd
DisableService dhcpcd
EnableService NetworkManager
StartService NetworkManager
EnableService autofs
StartService autofs

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Copying default ranger config ..."
ranger --copy-config=all

echo "Setting up vim..."
BasicVimInstall

echo "Setting up git"
if grep -q "gitalias" "$HOME/.gitconfig" ; then
    echo "Git aliases already set up"
else
    echo "[include]" >> ~/.gitconfig
    echo "    path = ~/.scripts/gitalias" >> ~/.gitconfig
fi
if grep -q "gitconfig" "$HOME/.gitconfig" ; then
    echo "Git config already set up"
else
    echo "[include]" >> ~/.gitconfig
    echo "    path = ~/.scripts/gitconfig" >> ~/.gitconfig
fi

echo "Enabling services ..."
EnableService dcron
StartService dcron
EnableService pcscd
StartService pcscd

echo "Applying default cron-config ..."
crontab ~/.config/defaultCronConfig

echo "Copying some default files ..."
sudo rm -rf /usr/share/backgrounds/*
SetupBackgroundsFolderForBing
bash ~/.scripts/updateLoginBackground.sh # Execute it ones, to get a new background

echo "Downloading your public key"
gpg --recv 0xB4B88025927E502D
