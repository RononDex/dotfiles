#!/bin/sh

InstallAurPackage() {
	packageName=$1
	buildParams=${2:-}
	yay -Sy $1 --needed --answerclean None --answerdiff A --answeredit None --answerupgrade None
}

BasicVimInstall() {
	sudo pacman -Sy the_silver_searcher --noconfirm --needed
	InstallAurPackage "neovim-plug"
	pip3 install pynvim
	python ~/.config/nvim/plugged/vimspector/install_gadget.py --force-enable-csharp
}

InstallAurScanner() {
	CloneOrUpdateGitRepoToPackages aurscan https://github.com/manticore-projects/aurscan
	cd ~/packages/aurscan
	bash ./install.sh
}

InstallYay() {
	sudo pacman -S --needed --noconfirm git base-devel
	CloneOrUpdateGitRepoToPackages yay https://aur.archlinux.org/yay.git
	cd ~/packages/yay
	makepkg -sic --noconfirm --needed
}
