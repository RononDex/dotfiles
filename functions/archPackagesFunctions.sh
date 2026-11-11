#!/bin/sh

InstallAurPackage() {
	packageName=$1
	buildParams=${2:-}
	yay -S "$packageName" --noconfirm --needed --answerclean None --answerdiff A --answeredit None --answerupgrade None
}

InstallAurScanner() (
	CloneOrUpdateGitRepoToPackages aurscan https://github.com/manticore-projects/aurscan
	cd ~/packages/aurscan
	bash ./install.sh
)

InstallYay() (
	sudo pacman -S --needed --noconfirm git base-devel
	CloneOrUpdateGitRepoToPackages yay https://aur.archlinux.org/yay.git
	cd ~/packages/yay
	makepkg -sic --noconfirm --needed
)
