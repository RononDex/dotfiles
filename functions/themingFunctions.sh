#!/bin/sh

SetupQTTheming() {
	ReplaceInFile "~/.config/qt6ct/qt6ct.conf" "^style=.*" "style=kvantum"
	InstallAurPackage "kvantum-theme-catppuccin-git" "https://aur.archlinux.org/kvantum-theme-catppuccin-git.git"
	InstallAurPackage "kvantum-theme-gruvbox-git" "https://aur.archlinux.org/kvantum-theme-gruvbox-git.git"
}
