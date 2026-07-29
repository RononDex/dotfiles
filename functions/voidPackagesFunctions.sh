#!/bin/sh

InstallRustDev() {
	sudo xbps-install -Sy rust rust-analyzer racer cargo
}

InstallYubiKeyStuff() {
	sudo xbps-install -Sy yubikey-manager u2f-hidraw-policy ykpers ykpers-gui
}

InstallDucDynDnsUpdateClient() {
	cd ~/packages
	wget https://dmej8g5cpdyqd.cloudfront.net/downloads/noip-duc_3.3.0.tar.gz
	tar xf noip-duc_3.3.0.tar.gz
	cd noip-duc_3.3.0
	cargo build --release
	sudo cp target/release/noip-duc /usr/local/bin
}
