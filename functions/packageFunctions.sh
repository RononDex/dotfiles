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
        InstallAurPackage "libdisplay-info" "https://aur.archlinux.org/libdisplay-info.git"
        InstallAurPackage "hyprland-bin" "https://aur.archlinux.org/hyprland-bin.git"
		InstallAurPackage "xdg-desktop-portal-hyprland-git" "https://aur.archlinux.org/xdg-desktop-portal-hyprland-git.git"
		InstallWaybarExperimentalHyprland
		InstallAurPackage "swaylock-effects-git" "https://aur.archlinux.org/swaylock-effects-git.git"
		InstallAurPackage "wlr-randr" "https://aur.archlinux.org/wlr-randr.git"
		InstallAurPackage "nwg-displays" "https://aur.archlinux.org/nwg-displays.git"

		sudo pacman -Sy wofi swaybg swayidle --needed --noconfirm
	fi
}

InstallWaybarExperimentalHyprland() {
		CloneOrUpdateGitRepoToPackages "Waybar" "https://github.com/Alexays/Waybar"
		cd ~/packages/Waybar
		sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
		meson --prefix=/usr --buildtype=plain --auto-features=enabled --wrap-mode=nodownload build
		meson configure -Dexperimental=true build
		sudo ninja -C build install
}

InstallWayland() {
    if  command -v pacman &> /dev/null
    then
		sudo pacman -Sy pipewire polkit-kde-agent xorg-xwayland wireplumber qt5-wayland qt6-wayland slurp grim wl-clipboard --needed --noconfirm
		InstallAurPackage "wlsunset" "https://aur.archlinux.org/wlsunset.git"
	fi
}

InstallSddm() {
    if  command -v pacman &> /dev/null
    then
		InstallAurPackage "sddm-git" "https://aur.archlinux.org/sddm-git.git"
		InstallAurPackage "sddm-sugar-candy-git" "https://aur.archlinux.org/sddm-sugar-candy-git.git"

		sudo systemctl enable sddm
	fi
}
