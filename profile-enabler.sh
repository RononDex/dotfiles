#!/bin/bash
set -uo pipefail

scriptDirRoot="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$scriptDirRoot"

# Ask for sudo once and keep the timestamp fresh until this script exits
sudo -v
while sleep 60; do sudo -n true; kill -0 $$ 2>/dev/null || exit; done &
. ./functions/basicFunctions.sh
. ./functions/packageFunctions.sh
. ./functions/networkingFunctions.sh
. ./functions/astroFunctions.sh
. ./functions/restrictedPackagesFunctions.sh
. ./functions/devEnvFunctions.sh
. ./functions/dockerFunctions.sh

# Pause Hyprland's config autoreload while files are being copied; the reload on exit restores it from the config
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
	hyprctl eval 'hl.config({ misc = { disable_autoreload = true } })' >/dev/null
	trap 'hyprctl reload >/dev/null' EXIT
fi

# --------------------------------------------
# Script to install / enable a profile
# --------------------------------------------

# Define some constants
RED='\033[0;31m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color
export MAKEFLAGS="-j $(nproc)"
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
profilesFolder="$scriptDir/profiles/"
profileName=${1:-}

# Welcome message
echo
echo "--------------------------------------------"
echo "   Tino's Profile enabler"
echo "--------------------------------------------"
echo

if [ -z "$profileName" ]; then
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
	profileName=$scriptDir/profiles/$profileName
fi

echo "ProfileName: ${profileName}"
distro=$(head -n 1 ${profileName}/distro)
echo "Distribution: ${distro}"

# Copy defaults
echo
echo "Copying default files...."
rm -rf ~/wallpapers
cp -ra ${scriptDir}/defaults/. ~/

# Copy profile files
echo
echo "Copying profile files..."
mkdir -p ~/.scripts

rm ~/.profile

cp -ra ${profileName}/. ~/.scripts/

ln -s ~/.zprofile ~/.profile

# Run default profile-installer
echo "------------------------------------------"
echo "Running default distro install"
echo "------------------------------------------"
. $scriptDir/default-profile-install-$distro.sh

ProfileInstallScriptPath=$profileName/profile-enabler.sh
if [ -f "$ProfileInstallScriptPath" ]; then
	echo "------------------------------------------"
	echo "Running profile install"
	echo "------------------------------------------"
	. $ProfileInstallScriptPath
fi

profileDirName=$(basename $profileName)
echo "$profileDirName"
echo "#!/bin/bash" >~/.scripts/updateDotFiles
echo "git -C \"$scriptDirRoot\" pull --ff-only && exec bash \"$scriptDirRoot/profile-enabler.sh\" \"$profileDirName\"" >>~/.scripts/updateDotFiles
chmod +x ~/.scripts/updateDotFiles

rm -rf ~/.files

echo
echo "DONE!"
