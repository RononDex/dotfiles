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
InstallLitarvanLightDmTheme() {
    sudo rm -rf ~/packages/lightdm-webkit-theme-litarvan
    CloneOrUpdateGitRepoToPackages "lightdm-webkit-theme-litarvan" "https://github.com/Litarvan/lightdm-webkit-theme-litarvan"
    cd ~/packages/lightdm-webkit-theme-litarvan
    bash ./build.sh
    sudo rm -rf /usr/share/web-greeter/themes/litarvan
    sudo mkdir /usr/share/web-greeter/themes/litarvan
    sudo tar -xvzf lightdm-webkit-theme-litarvan-3.2.0.tar.gz --directory /usr/share/web-greeter/themes/litarvan
}

InstallMpv() {
    # Arch
    if  command -v pacman &> /dev/null
    then
        sudo pacman -Sy vapoursynth mpv mkvtoolnix-cli --needed --noconfirm
    fi
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
    sudo ./install.sh -b -t tela $1

    if  command -v os-prober &> /dev/null
    then
			sudo os-prober
			sudo grub-mkconfig -o /boot/grub/grub.cfg
	fi
}

InstallWebGreeter() {
    # Install prerequisites
    # Arch
    if  command -v pacman &> /dev/null
    then
        sudo pacman -Sy rsync npm python-gobject python-pyqt5 python-pyqt5-webengine python-ruamel-yaml python-pyinotify qt5-webengine gobject-introspection libxcb libx11 --needed --noconfirm
        sudo npm i -g typescript
    fi

    # Void
    if  command -v xbps-install &> /dev/null
    then
        sudo xbps-install -Sy rsync python3-gobject python3-PyQt5 python3-PyQt5-webengine python3-ruamel.yaml python3-inotify qt5-webengine gobject-introspection libxcb libX11 python3-PyQt5-devel-tools
        sudo npm i -g typescript
    fi

    CloneOrUpdateGitRepoToPackages "web-greeter" "https://github.com/JezerM/web-greeter.git" "--recursive"
    cd ~/packages/web-greeter
    sudo make install
}

InstallHyprland() {
    if  command -v pacman &> /dev/null
    then
		gpg --receive-keys 0FDE7BE0E88F5E48 # Adds needed key for AUR packages

		yes | sudo pacman -Sy nwg-look xdg-desktop-portal-hyprland libdisplay-info waybar --needed --noconfirm
		InstallAurPackage "wlr-randr" "https://aur.archlinux.org/wlr-randr.git"
		InstallAurPackage "hyprland-git" "https://aur.archlinux.org/hyprland-git.git" "-f"
		InstallAurPackage "hyprlock-git" "https://aur.archlinux.org/hyprlock-git.git" "-f"
		InstallAurPackage "hypridle-git" "https://aur.archlinux.org/hypridle-git.git" "-f"
		InstallAurPackage "nwg-displays" "https://aur.archlinux.org/nwg-displays.git"

		sudo pacman -Sy wofi swaybg --needed --noconfirm
	fi
}

InstallWayland() {
    if  command -v pacman &> /dev/null
    then
		sudo pacman -Sy pipewire polkit-kde-agent xorg-xwayland wireplumber qt5-wayland qt6-wayland slurp grim swappy wl-clipboard --needed --noconfirm
		InstallAurPackage "wlsunset" "https://aur.archlinux.org/wlsunset.git"
	fi
}

InstallSddm() {
    if  command -v pacman &> /dev/null
    then
		sudo pacman -Sy sddm --needed --noconfirm
		InstallAurPackage "sddm-sugar-candy-git" "https://aur.archlinux.org/sddm-sugar-candy-git.git"

		sudo systemctl enable sddm
	fi
}

InstallEruption() {
    if  command -v pacman &> /dev/null
    then
		InstallAurPackage "eruption" "https://aur.archlinux.org/eruption.git"

		systemctl --user enable --now eruption-fx-proxy.service
		systemctl --user enable --now eruption-audio-proxy.service
		systemctl --user enable --now eruption-process-monitor.service

		sudo systemctl enable --now eruption.service
	fi
}
