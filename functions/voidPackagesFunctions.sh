#!/bin/sh

InstallRustDev() {
	sudo xbps-install -Sy rust rust-analyzer racer cargo
}

InstallYubiKeyStuff() {
	sudo xbps-install -Sy yubikey-manager u2f-hidraw-policy ykpers ykpers-gui
}
