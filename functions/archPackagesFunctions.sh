#!/bin/sh

InstallAurPackage() {
	CloneOrUpdateGitRepoToPackages $1 https://aur.archlinux.org/$1.git $2
	cd ~/packages/$1
	aurscan $1
	makepkg -sic $2 --noconfirm --needed
}

BasicVimInstall() {
	sudo pacman -Sy the_silver_searcher --noconfirm --needed
	InstallAurPackage "neovim-plug" "https://aur.archlinux.org/neovim-plug.git"
	pip3 install pynvim
	python ~/.config/nvim/plugged/vimspector/install_gadget.py --force-enable-csharp
}

InstallAurScanner() {
	CloneOrUpdateGitRepoToPackages aurscan https://github.com/manticore-projects/aurscan
	cd ~/packages/aurscan
	./install.sh
}
