#!/bin/sh

CloneOrUpdateGitRepoToPackages() {
	echo "Cloning / updating " $2
	if [ ! -d ~/packages ]; then
		mkdir -p ~/packages
	fi

	if [ ! -d ~/packages/$1 ]; then
		cd ~/packages
		git clone $3 $2 $1
	else
		cd ~/packages/$1
		git stash
		git pull
		git stash pop
	fi
}

SetupBackgroundsFolderForBing() {
	if [ ! -d /usr/share/backgrounds/currentBingImage ]; then
		currentUser=$(whoami)
		sudo chown -R $currentUser:$currentUser /usr/share/backgrounds/
	fi
}

UpdatePipPackages() {
	pip3 install --upgrade pip
	pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
}

# $1: Theme number from gnome-looks
DownloadAndInstallGtkTheme() {
	cd ~/packages
	mkdir Gtk-Themes-$1
	cd Gtk-Themes-$1
	rm -rf ./*

	curl -Lfs https://www.gnome-look.org/p/$1/loadFiles | jq -r '.files | first.version as $v | .[] | select(.version == $v).url' | perl -pe 's/\%(\w\w)/chr hex $1/ge' | xargs wget

	for f in ./*.tar.xz; do
		fullFileName="${f##*/}"
		fileName="${fullFileName%.*}"
		fileName="${fileName%.*}"
		sudo rm -rf "/usr/share/themes/${fileName}"
		sudo mkdir "/usr/share/themes/${fileName}"
		sudo tar -xf "$f" -C "/usr/share/themes/"
	done

}

# $1: filePath
# $2: regex to search for
# $3: replacement string
ReplaceInFile() {
	sed -i "s/$2/$3" $1
}
