#!/bin/sh

thisScriptDir=$(dirname $0)
echo $thisScriptDir
. $thisScriptDir/../../functions/basicFunctions.sh

versionMajor="5.13"
CloneOrUpdateGitRepoToPackages "void-packages" "https://github.com/void-linux/void-packages"
CloneOrUpdateGitRepoToPackages "linux-surface" "https://github.com/linux-surface/linux-surface.git"
cd ~/packages/void-packages/srcpkgs
cp -r linux$versionMajor linux$versionMajor-surface
ln -sf linux$versionMajor-surface linux$versionMajor-surface-headers
cp ~/packages/linux-surface/patches/$versionMajor/*.patch linux$versionMajor-surface/patches/
cat /proc/config.gz | gunzip > linux$versionMajor-surface/files/x86_64-dotconfig

sed -i -e "s/linux$versionMajor/linux$versionMajor-surface/g" linux$versionMajor-surface/template
sed -i "/maintainer=/c\maintainer=\"Tino Heuberger <tinoheuberger@protonmail.com>\"" linux$versionMajor-surface/template
sed -i "/short_desc=/c\short_desc=\"Linux kernel and modules containing patches and drivers for Microsoft Surface series devices (${version%.*} series)\"" linux$versionMajor-surface/template
sed -i "/homepage=/c\homepage=\"https://github.com/linux-surface/linux-surface\"" linux$versionMajor-surface/template

sh $thisScriptDir/merge_kernel_configs.sh linux$versionMajor-surface/files/x86_64-dotconfig ~/packages/linux-surface/configs/surface-$versionMajor.config

cd ..
./xbps-src pkg -j$(nproc) linux$versionMajor-surface
