#!/bin/bash

SetupDotnet() {
    mkdir -p ~/Downloads
    cd ~/Downloads
    rm dotnet-install.sh*
    wget https://dot.net/v1/dotnet-install.sh
    sudo bash dotnet-install.sh -c Current -InstallDir /usr/share/dotnet
    sudo bash dotnet-install.sh -c 3.1 -InstallDir /usr/share/dotnet
    dotnet tool install --global csharp-ls
    dotnet tool update --global csharp-ls
    dotnet new install BenchmarkDotNet.Templates

    if command -v xbps-install &> /dev/null
    then
        sudo xbps-install -y graphviz
    fi

    if command -v pacman &> /dev/null
    then
        sudo pacman -Sy graphviz --needed --noconfirm
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
        sudo pacman -Sy jdk11-openjdk jre-openjdk java-openjfx intellij-idea-community-edition maven gradle --needed --noconfirm
    fi

	mkdir -p ~/.config/coc/extensions/node_modules/coc-java/lombok/
	wget -O ~/.config/coc/extensions/node_modules/coc-java/lombok/lombok.jar https://projectlombok.org/downloads/lombok.jar
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
