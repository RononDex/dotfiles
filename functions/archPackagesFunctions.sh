#!/bin/sh

InstallAurPackage() {
    CloneOrUpdateGitRepoToPackages $1 $2 $3
    cd ~/packages/$1
    makepkg -sic $3 --noconfirm --needed
}

BasicVimInstall() {
    sudo pacman -Sy the_silver_searcher --noconfirm --needed
    InstallAurPackage "neovim-plug" "https://aur.archlinux.org/neovim-plug.git"
    pip3 install pynvim
    python ~/.config/nvim/plugged/vimspector/install_gadget.py --force-enable-csharp
}
