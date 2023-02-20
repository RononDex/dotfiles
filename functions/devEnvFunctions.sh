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
        sudo xbps-install -y openjdk11 openjdk intellij-idea-community-edition apache-maven
    fi

    if command -v pacman &> /dev/null
    then
        sudo pacman -Sy jdk11-openjdk jre-openjdk java-openjfx intellij-idea-community-edition maven --needed --noconfirm
    fi

    curl -s "https://get.sdkman.io" | bash
    curl -o ~/.config/nvim/lombok.jar https://projectlombok.org/downloads/lombok.jar
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
