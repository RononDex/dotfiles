#!/bin/sh

thisScriptDir=$(dirname $0)
. $thisScriptDir/../../functions/basicFunctions.sh

versionMajor="5.13"
CloneOrUpdateGitRepoToPackages "void-packages" "git@github.com:RononDex/void-packages.git"
CloneOrUpdateGitRepoToPackages "linux-surface" "https://github.com/linux-surface/linux-surface.git"
cd ~/packages/void-packages
git remote add upstream git://github.com/void-linux/void-packages.git
cd ~/packages/void-packages/srcpkgs
rm -rf linux$versionMajor-surface
rm linux$versionMajor-surface-headers
rm linux$versionMajor-surface-dbg
cp linux$versionMajor linux$versionMajor-surface -R
ln -s linux$versionMajor-surface linux$versionMajor-surface-headers
ln -s linux$versionMajor-surface linux$versionMajor-surface-dbg
cp ~/packages/linux-surface/patches/$versionMajor/*.patch linux$versionMajor-surface/patches/

sed -i -e "s/linux$versionMajor/linux$versionMajor-surface/g" linux$versionMajor-surface/template
sed -i "/maintainer=/c\maintainer=\"Tino Heuberger <tinoheuberger@protonmail.com>\"" linux$versionMajor-surface/template
sed -i "/short_desc=/c\short_desc=\"Linux kernel and modules containing patches and drivers for Microsoft Surface series devices (${version%.*} series)\"" linux$versionMajor-surface/template
sed -i "/homepage=/c\homepage=\"https://github.com/linux-surface/linux-surface\"" linux$versionMajor-surface/template

sh $thisScriptDir/merge_config.sh -m ~/packages/void-packages/srcpkgs/linux$versionMajor-surface/files/x86_64-dotconfig ~/packages/linux-surface/configs/surface-$versionMajor.config
mv $PWD/.config linux$versionMajor-surface/files/x86_64-dotconfig

cd ~/packages/void-packages
./xbps-src binary-bootstrap
./xbps-src clean
./xbps-src pkg -j$(nproc) linux$versionMajor-surface
