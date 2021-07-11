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

    sudo xbps-install -Sy the_silver_searcher
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    pip3 install pynvim
    python ~/.config/nvim/plugged/vimspector/install_gadget.py --force-enable-csharp
}

InstallLitarvanLightDmTheme() {
    cd ~/packages
    mkdir litarvan
    cd litarvan
    wget https://github.com/Litarvan/lightdm-webkit-theme-litarvan/releases/download/v3.2.0/lightdm-webkit-theme-litarvan-3.2.0.tar.gz
    sudo rm -rf /usr/share/lightdm-webkit/themes/litarvan
    sudo mkdir -p /usr/share/lightdm-webkit/themes/litarvan
    sudo tar -xvzf lightdm-webkit-theme-litarvan-3.2.0.tar.gz --directory /usr/share/lightdm-webkit/themes/litarvan
}

InstallLatestDotnet() {
    cd ~/packages
    mkdir dotnet
    cd dotnet
    wget https://dot.net/v1/dotnet-install.sh
    chmod +x ./dotnet-install.sh
    ./dotnet-install.sh -c Current
}

InstallRustDev() {
    sudo xbps-install -Sy rust rust-analyzer racer cargo
}

InstallXorg() {
    sudo xbps-install -Sy xorg-server xorg-server-xephyr xorg-apps xorg-minimal xinit
}
