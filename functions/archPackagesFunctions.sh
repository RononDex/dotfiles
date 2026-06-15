#!/bin/sh

InstallAurPackage() {
	packageName=$1
	buildParams=${2:-}
	CloneOrUpdateGitRepoToPackages $packageName https://aur.archlinux.org/$packageName.git
	cd ~/packages/$packageName
	aurscan $packageName
	makepkg -sic $buildParams --noconfirm --needed
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
	bash ./install.sh
}
