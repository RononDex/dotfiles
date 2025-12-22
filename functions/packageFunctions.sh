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
        sudo pacman -S vapoursynth mpv mkvtoolnix-cli --needed --noconfirm
    fi
}

InstallRifeAiAmd() {
    sudo pacman -S mesa base-devel cmake vulkan-icd-loader vulkan-tools --needed --noconfirm

    CloneOrUpdateGitRepoToPackages "rife-ncnn-vulkan" "https://github.com/nihui/rife-ncnn-vulkan.git"
	cd ~/packages/rife-ncnn-vulkan/
	git submodule update --init --recursive

	mkdir build 
	cd build
    cmake ../src -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release -DENABLE_10BIT=ON
	make -j$(nproc)
	sudo install -Dm755 rife-ncnn-vulkan /usr/local/bin/
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

		yes | sudo pacman -S hyprland nwg-displays nwg-look xdg-desktop-portal-hyprland hyprutils wlr-randr hyprlock hypridle libdisplay-info waybar hyprpolkitagent hyprland-protocols hyprsunset --needed --noconfirm
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

		sudo pacman -S wofi swaybg --needed --noconfirm
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
