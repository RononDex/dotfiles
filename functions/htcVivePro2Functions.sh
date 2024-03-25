#!/bin/sh
. ./basicFunctions.sh

# Instructions are from 
#     https://github.com/santeri3700/vive-pro-2-on-linux?tab=readme-ov-file
#
# How to use:
# 1. execute PreSteamSetupVivePro2
# 2. Reboot and ensure system is booted with new kernel (uname -a)
# 3. Open Steam and install Steam VR: steam steam://install/250820
# 4. Completely exit steam
# 5. execute PostSteamSetupVivePro

PreSteamSetupVivePro2() {
		SetupGitRepo
		BuildAndInstallKernel
		InstallPolkitRule
}

SetupGitRepo() {
		CloneOrUpdateGitRepoToPackages "vive-pro-2-on-linux" "https://github.com/santeri3700/vive-pro-2-on-linux"
}

BuildAndInstallKernel() {
		cd ~/packages/vive-pro-2-on-linux/kernel

		# Import gpg keys
		for key in ./keys/pgp/*.asc; do gpg --import $key; done

		# Build kernel
		export MAKEFLAGS="-j $(nproc)"
		makepkg -sc

		# Install kernel
		makepkg -si --noconfirm --needed
		sudo grub-mkconfig -o /boot/grub/grub.cfg
}

InstallPolkitRule() {
		cd ~/packages/vive-pro-2-on-linux/
		sudo cp ./polkit-vr-setcap-nice.rules /etc/polkit-1/rules.d/90-vr-setcap-nice.rules

		sudo systemctl restart polkit.service
}

PostSteamSetupVivePro2() {
		SetupDriver
}

SetupDriver() {
		sudo pacman -Sy git rsync rustup --needed --noconfirm
		sudo pacman -Sy mingw-w64-binutils mingw-w64-crt mingw-w64-gcc mingw-w64-headers mingw-w64-winpthreads --needed --noconfirm
		rustup toolchain install nightly
		rustup +nightly target add x86_64-pc-windows-gnu

		# Clone the driver repository
		CloneOrUpdateGitRepoToPackages "VivePro2-Linux-Driver" "https://github.com/CertainLach/VivePro2-Linux-Driver.git"

		cd ~/packages/VivePro2-Linux-Driver/
		export VIVEPRO2DRVDIR="$(pwd)"


		# Clone and build the sewer tool repository
		CloneOrUpdateGitRepoToPackages "VivePro2-Linux-Driver/sewer" "https://github.com/CertainLach/sewer.git"
		cd ~/packages/VivePro2-Linux-Driver/sewer
		cargo +nightly build --release --all-features --verbose

		# Build driver-proxy
		cd $VIVEPRO2DRVDIR/bin/driver-proxy
		cargo +nightly build --release --all-features --verbose

		# Build lens-server
		cd $VIVEPRO2DRVDIR/bin/lens-server
		cargo +nightly build --release --target x86_64-pc-windows-gnu --all-features --verbose

		# Copy the compiled objects to the dist-proxy directory
		cd $VIVEPRO2DRVDIR/dist-proxy/
		mkdir bin
		cp $VIVEPRO2DRVDIR/sewer/target/release/sewer ./bin
		cp $VIVEPRO2DRVDIR/target/x86_64-pc-windows-gnu/release/lens-server.exe ./lens-server/
		cp $VIVEPRO2DRVDIR/target/release/libdriver_proxy.so ./driver_lighthouse.so


		bash ./install.sh
}
