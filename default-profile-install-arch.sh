#!/bin/sh

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. ./functions/archPackagesFunctions.sh
. ./functions/basicFunctions.sh
. ./functions/systemDFunctions.sh

sudo pacman -Sy archlinux-keyring --noconfirm --needed
sudo pacman -Syu --noconfirm --needed
sudo pacman -Sy wget git --noconfirm --needed

echo "Updating file permissions ..."
chmod +x ~/.xinitrc
chmod +x ~/.config/.xinitrc
chmod +x ~/.profile
chmod +x ~/.zprofile
chmod +x ~/.config/xfce4/terminal/terminalrc
chmod -R +x ~/.scripts
chmod +x ~/.xprofile
chmod 700 ~/.gnupg -R

echo "Copying default config files"
sudo mkdir /etc/sddm.conf.d
sudo cp ~/.files/sddm/custom.conf /etc/sddm.conf.d/custom.conf
sudo cp ~/.files/sddm/sugar-candy/theme.conf /usr/share/sddm/themes/sugar-candy/theme.conf
rm -rf ~/.files

cp ~/Nextcloud/Wallpapers/* -r ~/wallpapers/

isArm=$false
echo "Configuring pacman ..."
architecture=$(uname -m | grep -E "arm|aarch")
if [[ $architecture == *"arm"* ]]; then
    echo -n "$RED"
    echo "ARM system detected ..."
    echo -n "$NC"
    sudo cp defaults/mirrorListARM /etc/pacman.d/mirrorlist
    sudo cp defaults/pacman.arm.conf /etc/pacman.conf
    sudo chmod 744 /etc/pacman.conf
    sudo chmod 744 /etc/pacman.d/mirrorlist
    isArm=$true 
else
    sudo cp defaults/mirrorlist /etc/pacman.d/mirrorlist
    sudo cp defaults/pacman.conf /etc/pacman.conf
    sudo chmod 744 /etc/pacman.conf
    sudo chmod 744 /etc/pacman.d/mirrorlist
    isArm=$false
fi

rm ~/pacman.conf
rm ~/mirrorlist
rm ~/pacman.arm.conf
rm ~/mirrorListARM

source ~/.profile

echo "Installing stuff..."
sudo pacman -S pkgconfig bc powerline-fonts fakeroot debugedit ttf-firacode-nerd ttf-arimo-nerd gcc boost ffmpeg make cmake otf-fira-mono otf-fira-sans ttf-fira-code ttf-fira-mono ttf-fira-sans zsh zsh-completions automake m4 autoconf --noconfirm --needed
sudo pacman -S bash-completion networkmanager gnome-keyring network-manager-applet xorg xorg-xinit firefox adobe-source-code-pro-fonts neofetch xclip --noconfirm --needed
sudo pacman -S picom pipewire pipewire-pulse wireplumber pavucontrol arc-gtk-theme arc-icon-theme nautilus --noconfirm --needed
sudo pacman -S java-runtime-common jre-openjdk xdotool --noconfirm --needed
sudo pacman -S vim neovim libftdi ccfits network-manager-applet adobe-source-code-pro-fonts noto-fonts-extra --noconfirm --needed
sudo pacman -S python debugedit acpi python-pip samba opencv pkgconfig gtest gmock libmpdclient bc ranger xorg-server binutils keychain --needed --noconfirm
sudo pacman -S htop imagemagick zlib curl exfat-utils unzip zip shadow perl-json-xs git-lfs python-pywal fzf arandr pass --needed --noconfirm
sudo pacman -S zsh-syntax-highlighting xfce4-power-manager openvpn zsh-autosuggestions calc diff-so-fancy networkmanager-openvpn powerline-fonts zathura zathura-cb zathura-pdf-mupdf zathura-ps lynx ttf-dejavu --needed --noconfirm
sudo pacman -S dkms btop linux-headers gnupg pcsclite ccid yubikey-manager yubikey-personalization --needed --noconfirm
sudo pacman -S ueberzug autoconf keyutils automake bison openconnect ksshaskpass --needed --noconfirm
sudo pacman -S ttf-liberation kitty libvips lftp python-pip npm linux-firmware-marvell gtk2 ranger fwupd --needed --noconfirm
sudo pacman -S tracker3 webkit2gtk tracker3-miners qt5ct qt6ct otf-font-awesome ddcutil jq polkit --needed --noconfirm

# Install Architecture specific stuff
if [ $isArm ]; then
    sudo pacman -Sy fakeroot --noconfirm --needed
else
    sudo pacman -Sy gtop --noconfirm --needed
fi

git lfs install
git lfs pull

echo "Changing default shell to zsh"
if [[ "$SHELL" != "/bin/zsh" ]]; then
    chsh -s /bin/zsh
fi

echo "Setting up oh-my-zsh ..."
if [ ! -d ${ZSH} ]; then
		sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
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

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Copying default ranger config ..."
ranger --copy-config=all

echo "Setting up vim..."
BasicNvimInstall

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

echo "Installing AUR packages"
InstallAurPackage "dcron" "https://aur.archlinux.org/dcron.git"
InstallAurPackage "nomacs" "https://aur.archlinux.org/nomacs.git"
InstallAurPackage "ddcui" "https://aur.archlinux.org/ddcui.git"

echo "Setting up Display Manager"
InstallSddm

# Needed key for autofs
gpg --fetch-keys https://keyserver.ubuntu.com/pks/lookup\?op\=get\&search\=0xcd0a6e3cbb6768800b0736a8e7677380f54fd8a9
InstallAurPackage "autofs" "https://aur.archlinux.org/autofs.git"

echo "Downloading your public key"
gpg2 --recv 0xB4B88025927E502D

echo "Enabling services ..."
sudo systemctl enable dcron
sudo systemctl start dcron
sudo systemctl enable autofs
sudo systemctl start autofs
sudo systemctl start polkit.service
sudo systemctl enable polkit.service
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

echo "Applying default cron-config ..."
crontab ~/.config/defaultCronConfig

echo "Copying some default files ..."
sudo rm -rf /usr/share/backgrounds/*
SetupBackgroundsFolderForBing
sh ~/.scripts/updateLoginBackground.sh # Execute it ones, to get a new background

echo "Updating gpg-agent"
echo "UPDATESTARTUPTTY" | gpg-connect-agent > /dev/null 2>&1

# Install nordic theme
DownloadAndInstallGtkTheme "1267246"
gsettings set org.gnome.desktop.interface gtk-theme 'Nordic-v40'
gsettings set org.gnome.desktop.wm.preferences theme 'Nordic-v40'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
