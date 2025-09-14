#!/bin/sh

InstallXbpsMiniBuilder() {
    mkdir -p ~/packages/xbps-mini-builder
    cd ~/packages/xbps-mini-builder
    wget https://raw.githubusercontent.com/the-maldridge/xbps-mini-builder/master/xbps-mini-builder
    chmod +x ./xbps-mini-builder
    echo "XBPS_ALLOW_RESTRICTED=yes" > xbps-src.conf
}

UpdateRestrictedPackages() {
    cd ~/packages/xbps-mini-builder
    ./xbps-mini-builder
}

InstallRestrictedPackageFromCache() {
    cd ~/packages/xbps-mini-builder/void-packages
    sudo xbps-install -y --repository $1 $2 
}
