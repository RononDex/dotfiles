#!/bin/sh


InstallPowerLineFonts() {
    CloneOrUpdateGitRepoToPackages "powerline-fonts" "https://github.com/powerline/fonts.git"
    # install
    cd ~/packages/powerline-fonts
    sh ./install.sh
}

MakePackage() {
    cd ~/packages/$1
    mkdir build
    cd build
    cmake ..
    make
}

BasicVimInstall() {
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi

    if command -v xbps-install &> /dev/null
    then
        sudo xbps-install -Sy the_silver_searcher python3-neovim
    fi

    if command -v pacman &> /dev/null
    then
        sudo pacman -S the_silver_searcher python-pynvim
    fi

    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    pip3 install pynvim
    python ~/.config/nvim/plugged/vimspector/install_gadget.py --force-enable-csharp
}

InstallLitarvanLightDmTheme() {
    cd ~/packages
    mkdir litarvan
    cd litarvan
    wget https://github.com/Litarvan/lightdm-webkit-theme-litarvan/files/6858021/lightdm-webkit-theme-litarvan-3.2.0.tar.gz
    sudo rm -rf /usr/share/lightdm-webkit/themes/litarvan
    sudo mkdir -p /usr/share/lightdm-webkit/themes/litarvan
    sudo tar -xvzf lightdm-webkit-theme-litarvan-3.2.0.tar.gz --directory /usr/share/lightdm-webkit/themes/litarvan
    sudo rm ~/packages/litarvan/*
}

InstallRustDev() {
    sudo xbps-install -Sy rust rust-analyzer racer cargo
}

InstallXorg() {
    sudo xbps-install -Sy xorg xorg-server xorg-server-xephyr xorg-apps xorg-minimal xinit mesa-dri
}

InstallYubiKeyStuff() {
 sudo xbps-install -Sy yubikey-manager u2f-hidraw-policy ykpers ykpers-gui
}

InstallGrubTheme() {
    CloneOrUpdateGitRepoToPackages "grub2-themes" "https://github.com/vinceliuice/grub2-themes"
    cd ~/packages/grub2-themes
    sudo ./install.sh -t slaze $1
}

InstallWebGreeter() {
    CloneOrUpdateGitRepoToPackages "web-greeter" "https://github.com/JezerM/web-greeter.git" "--recursive"
    cd ~/packages/web-greeter
    sudo make install
}
