#!/bin/sh

InstallAurPackage() {
    CloneOrUpdateGitRepoToPackages $1 $2
    cd ~/packages/$1
    makepkg -sic --noconfirm --needed
}

BasicVimInstall() {
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi

    sudo pacman -Sy the_silver_searcher --noconfirm --needed
    InstallAurPackage "neovim-plug" "https://aur.archlinux.org/neovim-plug.git"
    pip3 install pynvim
    python ~/.config/nvim/plugged/vimspector/install_gadget.py --force-enable-csharp
}
