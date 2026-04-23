#!/bin/sh


InstallPowerLineFonts() {
    CloneOrUpdateGitRepoToPackages "powerline-fonts" "https://github.com/powerline/fonts.git"
    # install
    cd ~/packages/powerline-fonts
    sh ./install.sh
}

SetupPodman() {
    if  command -v pacman &> /dev/null
    then
        sudo pacman -S podman podman-compose --needed --noconfirm
    fi

	sudo mkdir -p /etc/containers/registries.conf.d
	sudo cp ~/.files/podman/10-unqualified-search-registries.conf /etc/containers/registries.conf.d/10-unqualified-search-registries.conf
	sudo usermod --add-subuids 10000-75535 $USER
	sudo usermod --add-subgids 10000-75535 $USER
}

SetupWinBoat() {
	SetupPodman

    if  command -v pacman &> /dev/null
    then
        sudo pacman -S freerdp --needed --noconfirm
		InstallAurPackage "winboat-bin" "https://aur.archlinux.org/winboat-bin.git"
    fi

}

SetupClamAV() {
	echo "Setting up ClamAV"

    if  command -v pacman &> /dev/null
    then
	sudo pacman -S clamav --needed --noconfirm
else
		sudo xbps-install -Sy clamav
	fi

	sudo mkdir -p /etc/clamav && sudo cp ~/.files/clamav/clamd.conf /etc/clamav/clamd.conf
	sudo mkdir -p /etc/clamav && sudo cp ~/.files/clamav/notify.sh /etc/clamav/notify.sh
	sudo cp ~/.files/clamav/sudoers-config /etc/sudoers.d/clamav
	sudo chmod +x /etc/clamav/notify.sh
	sudo mkdir -p /etc/systemd/system/clamav-clamonacc.service.d && sudo cp ~/.files/clamav/clamonacc.service-override /etc/systemd/system/clamav-clamonacc.service.d/override.conf

	echo "fs.inotify.max_user_watches = 524288" | sudo tee /etc/sysctl.d/90-inotify.conf
	sudo sysctl --system
	
	sudo mkdir -p /var/log/clamav
	sudo mkdir -p /root/quarantine
	sudo touch /var/log/clamav/freshclam.log
	sudo chmod 600 /var/log/clamav/freshclam.log
	sudo chown clamav /var/log/clamav/freshclam.log
	sudo chown -R clamav /etc/clamav/certs

	sudo systemctl enable clamav-clamonacc.service
	sudo systemctl restart clamav-clamonacc.service
	sudo systemctl enable clamav-daemon.service
	sudo systemctl restart clamav-daemon.service
	sudo systemctl enable clamav-freshclam.service
	sudo systemctl restart clamav-freshclam.service
}

MakePackage() {
    cd ~/packages/$1
    mkdir build
    cd build
    cmake ..
    make
}

InstallMpv() {
    # Arch
    if  command -v pacman &> /dev/null
    then
        sudo pacman -S vapoursynth mpv mkvtoolnix-cli --needed --noconfirm
    fi
}

InstallRustDev() {
    sudo xbps-install -Sy rust rust-analyzer racer cargo
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

InstallHyprland() {
    if  command -v pacman &> /dev/null
    then

		yes | sudo pacman -S hyprland waypipe nwg-displays nwg-look xdg-desktop-portal-hyprland hyprutils wlr-randr hyprlock hypridle libdisplay-info waybar hyprpolkitagent hyprland-protocols hyprsunset awww --needed --noconfirm
		# gpg --receive-keys 0FDE7BE0E88F5E48 # Adds needed key for AUR packages
		# InstallAurPackage "wlr-randr" "https://aur.archlinux.org/wlr-randr.git"
		# InstallAurPackage "hyprutils-git" "https://aur.archlinux.org/hyprutils-git.git"
		# InstallAurPackage "hyprland-git" "https://aur.archlinux.org/hyprland-git.git" "-f"
		# InstallAurPackage "hyprlock-git" "https://aur.archlinux.org/hyprlock-git.git"
		# InstallAurPackage "hypridle-git" "https://aur.archlinux.org/hypridle-git.git"
		# InstallAurPackage "nwg-displays" "https://aur.archlinux.org/nwg-displays.git"
		#
		# InstallAurPackage "hyprland-protocols" "https://aur.archlinux.org/hyprland-protocols.git"
		# InstallAurPackage "hyprsunset" "https://aur.archlinux.org/hyprsunset.git"

		sudo pacman -S wofi --needed --noconfirm
	fi
}

InstallWayland() {
    if  command -v pacman &> /dev/null
    then
		sudo pacman -S pipewire xorg-xwayland wireplumber qt5-wayland qt6-wayland slurp grim swappy wl-clipboard --needed --noconfirm
	fi
}

InstallSddm() {
    if  command -v pacman &> /dev/null
    then
		sudo pacman -S sddm --needed --noconfirm
		# InstallAurPackage "sddm-sugar-candy-git" "https://aur.archlinux.org/sddm-sugar-candy-git.git"
		InstallAurPackage "redhat-fonts" "https://aur.archlinux.org/redhat-fonts.git"
		InstallAurPackage "sddm-silent-theme" "https://aur.archlinux.org/sddm-silent-theme.git"

		sudo systemctl enable sddm

		sudo mkdir -p /usr/share/sddm/themes/silent/backgrounds
		if [ ! -f /usr/share/sddm/themes/silent/backgrounds/bing.jpg ]; then
				sudo touch /usr/share/sddm/themes/silent/backgrounds/bing.jpg
		fi
		sudo chown $USER:$USER /usr/share/sddm/themes/silent/backgrounds/bing.jpg
		sudo chmod 744 /usr/share/sddm/themes/silent/backgrounds/bing.jpg

		sudo bash /usr/share/sddm/themes/silent/change_avatar.sh $USER ~/.face

		ReplaceInFile "/usr/share/sddm/themes/silent/metadata.desktop" "^ConfigFile=.*" "ConfigFile=configs\/daily-image.conf"
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

CompileFixedUBootForRpi4() {
	CloneOrUpdateGitRepoToPackages "PKGBUILDs-archlinux-arm" "https://github.com/RononDex/PKGBUILDs-archlinux-arm.git" 
	cd ~/packages/PKGBUILDs-archlinux-arm/alarm/uboot-raspberrypi

	makepkg -sic
}
