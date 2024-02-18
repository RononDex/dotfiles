#!/bin/bash

SetupDotnet() {
    mkdir -p ~/Downloads
    cd ~/Downloads
    rm dotnet-install.sh*
    wget https://dot.net/v1/dotnet-install.sh
    sudo bash dotnet-install.sh -c Current -InstallDir /usr/share/dotnet
    sudo bash dotnet-install.sh -c STS -InstallDir /usr/share/dotnet
    dotnet new install BenchmarkDotNet.Templates

    if command -v xbps-install &> /dev/null
    then
        sudo xbps-install -y graphviz
    fi

    if command -v pacman &> /dev/null
    then
        sudo pacman -Sy graphviz --needed --noconfirm
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

SetupLatex() {
		
    if command -v pacman &> /dev/null
    then
        sudo pacman -Sy texlive texlive-langgerman --needed --noconfirm
    fi
}

SetupMariaMySqlDb() {
    sudo xbps-install -y mariadb
    EnableService mysqld
}

SetupJavaDevEnv() {
    if command -v xbps-install &> /dev/null
    then
        sudo xbps-install -y openjdk11 openjdk intellij-idea-community-edition apache-maven gradle
    fi

    if command -v pacman &> /dev/null
    then
        sudo pacman -Sy jdk11-openjdk jdk-openjdk intellij-idea-community-edition maven gradle --needed --noconfirm
    fi

	mkdir -p ~/.local/share/jdtls/extensions/lombok
	wget -O ~/.local/share/jdtls/extensions/lombok/lombok.jar https://projectlombok.org/downloads/lombok.jar
}

SetupJavaScriptDevEnv() {
    if command -v xbps-install &> /dev/null
    then
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
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi

    if command -v xbps-install &> /dev/null
    then
        sudo xbps-install -Sy the_silver_searcher python3-neovim tree-sitter
    fi

    if command -v pacman &> /dev/null
    then
        sudo pacman -S the_silver_searcher python-pynvim tree-sitter --noconfirm --needed
    fi

    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    pip3 install pynvim
    python ~/.config/nvim/plugged/vimspector/install_gadget.py --force-enable-csharp

    vim +PlugUpdate +qa > /dev/null 2&>1

    vim +CocUpdate +qa > /dev/null 2&>1
}

BasicNvimInstall() {
    if command -v pacman &> /dev/null
    then
        sudo pacman -S ripgrep lazygit tree-sitter tree-sitter-cli fd --noconfirm --needed
    fi
}
