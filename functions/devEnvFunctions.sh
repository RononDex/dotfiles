#!/bin/bash

SetupDotnet() {
	mkdir -p ~/Downloads
	dotnet new install BenchmarkDotNet.Templates

	if command -v xbps-install &>/dev/null; then
		sudo xbps-install -y graphviz
	fi

	if command -v pacman &>/dev/null; then
		sudo pacman -S graphviz --needed --noconfirm
	fi

	echo "Installing netcoredbg"
	latest_netcoredbg_url=$(curl -sL https://api.github.com/repos/Samsung/netcoredbg/releases/latest | jq -r ".assets[].browser_download_url" | grep netcoredbg-linux-amd64.tar.gz)
	cd ~/Downloads
	wget $latest_netcoredbg_url
	sudo mkdir -p /usr/local/bin/netcoredbg
	sudo tar -xf netcoredbg-linux-amd64.tar.gz -C /usr/local/bin/
	sudo chmod -R 755 /usr/local/bin/netcoredbg/
	rm netcoredbg-linux-amd64.tar.gz
}

SetupMariaMySqlDb() {
	sudo xbps-install -y mariadb
	EnableService mysqld
}

SetupJavaDevEnv() {
	if command -v xbps-install &>/dev/null; then
		sudo xbps-install -y openjdk11 openjdk intellij-idea-community-edition apache-maven gradle
	fi

	if command -v pacman &>/dev/null; then
		sudo pacman -S jdk11-openjdk jdk-openjdk intellij-idea-community-edition maven gradle --needed --noconfirm
	fi

	mkdir -p ~/.local/share/jdtls/extensions/lombok
	wget -O ~/.local/share/jdtls/extensions/lombok/lombok.jar https://projectlombok.org/downloads/lombok.jar
}

SetupJavaScriptDevEnv() {
	if command -v xbps-install &>/dev/null; then
		sudo xbps-install -y nodejs
	fi

	npm i -g typescript
}

InstallJupyterNotebooks() {
	pip3 install jupyter
}

SetupPythonDev() {
	pip3 install matplotlib
	pip3 install pylint
	pip3 install autopep8
}

BasicVimInstall() {

	if command -v xbps-install &>/dev/null; then
		sudo xbps-install -Sy the_silver_searcher python3-neovim tree-sitter
	fi

	if command -v pacman &>/dev/null; then
		sudo pacman -S the_silver_searcher python-pynvim tree-sitter python-pynvim --noconfirm --needed
	fi
}

BasicNvimInstall() {
	if command -v pacman &>/dev/null; then
		sudo pacman -S ripgrep lazygit tree-sitter tree-sitter-cli python-pynvim fd --noconfirm --needed
	fi
}

SetupLanguageModelForLtex() {
	if [ ! -d ~/.cache/ngram-data/ ]; then
		mkdir -p ~/.cache/ngram-data
	fi

	if [ ! -d ~/.cache/ngram-data/de ]; then
		echo "Downloading german ngram data..."
		cd ~/Downloads/
		curl --output ngrams-de.zip https://languagetool.org/download/ngram-data/ngrams-de-20150819.zip
		unzip ngrams-de.zip
		mv de ~/.cache/ngram-data/
		rm ngrams-de.zip
	fi

	if [ ! -d ~/.cache/ngram-data/en ]; then
		echo "Downloading english ngram data..."
		cd ~/Downloads/
		curl --output ngrams-en.zip https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip
		unzip ngrams-en.zip
		mv en ~/.cache/ngram-data/
		rm ngrams-en.zip
	fi
}

SetupLatex() {

	if command -v pacman &>/dev/null; then
		sudo pacman -S texlive texlive-langgerman texlive-doc --needed --noconfirm
		InstallAurPackage "ltex-ls-bin" "https://aur.archlinux.org/ltex-ls-bin.git"
	fi

	SetupLanguageModelForLtex
}

InstallGoDev() {

	if command -v pacman &>/dev/null; then
		sudo pacman -S gopls --noconfirm --needed
		InstallAurPackage "golangci-lint" "https://aur.archlinux.org/golangci-lint.git"
	fi
}

SetupWordpressDev() {
	sudo npm -g install @wordpress/env
}
