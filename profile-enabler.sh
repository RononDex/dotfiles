#!/bin/bash
scriptDirRoot="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$scriptDirRoot"
git pull
. ./functions/basicFunctions.sh
. ./functions/packageFunctions.sh
. ./functions/networkingFunctions.sh
. ./functions/astroFunctions.sh

# --------------------------------------------
# Script to install / enable a profile
# --------------------------------------------

# Define some constants
RED='\033[0;31m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
profilesFolder="$scriptDir/profiles/"

# Welcome message
echo
echo "--------------------------------------------"
echo "   Tino's Profile enabler"
echo "--------------------------------------------"
echo

if [ -z "$1" ]; then
    # List available profiles
    echo "Available profiles: "
    echo

    i=1
    for d in $profilesFolder*; do
        echo "      $i) $(basename $d)"
        profiles+=("$d")
        i=$((i + 1))
    done
    echo
    printf "Enter number: "

    # Let user select a profile
    read selectedProfile

    echo

    re='^[0-9]+$'
    if ! [[ $selectedProfile =~ $re ]]; then
        echo -n "$RED"
        echo "error: Not a number$NC" >&2
        exit -1
    fi

    # Run profile specific profile installer if it exists
    echo
    profileName=${profiles[$selectedProfile - 1]}
else
    profileName=$scriptDir/profiles/$1
fi

echo $profileName

# Copy defaults
echo
echo "Copying default files...."
rm -rf ~/wallpapers
cp -ra $scriptDir/defaults/. ~/

# Copy profile files
echo
echo "Copying profile files..."
mkdir -p ~/.scripts

rm ~/.profile
rm ~/.xinitrc

cp -ra ${profileName}/. ~/.scripts/

ln -s ~/.zprofile ~/.profile
ln -s ~/.config/.xinitrc ~/.xinitrc

# Run default profile-installer
echo
. ./default-profile-install.sh

ProfileInstallScriptPath=${profileName}/profile-enabler.sh
if [ -f "$ProfileInstallScriptPath" ]; then
    . $ProfileInstallScriptPath
fi

profileDirName=$(basename $profileName)
echo "$profileDirName"
echo "#!/bin/sh" > ~/.scripts/updateDotFiles
echo "sh $scriptDirRoot/profile-enabler.sh $profileDirName" >> ~/.scripts/updateDotFiles
chmod +x ~/.scripts/updateDotFiles

echo
echo "DONE!"
