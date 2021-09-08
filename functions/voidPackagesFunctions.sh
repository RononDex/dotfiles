#!/bin/sh

InstallRustDev() {
    sudo xbps-install -Sy rust rust-analyzer racer cargo
}

InstallXorg() {
    sudo xbps-install -Sy xorg xorg-server xorg-server-xephyr xorg-apps xorg-minimal xinit mesa-dri
}

InstallYubiKeyStuff() {
 sudo xbps-install -Sy yubikey-manager u2f-hidraw-policy ykpers ykpers-gui
}
