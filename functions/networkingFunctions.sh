#!/bin/bash

# $1: Name of share / server
# $2: shares to mount (command)
SetupAutofsForSmbShare() {

    if [ ! -d /shares ]
    then
        sudo mkdir /shares
    fi

    if ! grep -q "$1" "/etc/autofs/auto.master"; then
        sudo mkdir -p /shares/$1 
        echo "/shares/$1 /etc/autofs/auto.$1 --timeout=600 --ghost" | sudo tee -a /etc/autofs/auto.master

        for ((i=2; i<=$#; i+=2)); do
            j=$((i+1))
            echo "${!i} -fstype=cifs,rw,noperm,uid=1000,credentials=/etc/autofs/$1-credentials ${!j}" | sudo tee -a /etc/autofs/auto.$1 
        done

        echo "Username for $1 share: "
        read username

        echo "Password for $1 share: "
        stty_orig=`stty -g` # save original terminal setting.
        stty -echo          # turn-off echoing.
        read passwd         # read the password
        printf "username=$username\npassword=$passwd" | sudo tee /etc/autofs/$1-credentials > /dev/null
        stty $stty_orig     # restore terminal setting.

        sudo chmod 700 /etc/autofs/$1-credentials

        sudo systemctl restart autofs
    fi
}

# $1: interface name
# $2: hotspot name
# $3: 5GHz (true) or 2.4GHz (false)
SetupHotspot() {
    if [ ! -f  ~/.scripts/networking/startHotspot$2 ]; then
        BAND="a"
        if $3 -eq true; then BAND="a"; else BAND="bg"; fi

        passwd="test"
        confirmedPasswd="asdf"
        while [ $passwd != $confirmedPasswd ]
        do
            echo "Enter password for hotspot ${2}:"
            stty_orig=`stty -g`         # save original terminal setting.
            stty -echo                  # turn-off echoing.
            read passwd                 # read the password
            stty $stty_orig             # restore terminal setting.
            echo "Confirm password:"
            stty_orig=`stty -g`         # save original terminal setting.
            stty -echo                  # turn-off echoing.
            read confirmedPasswd        # read the password
            stty $stty_orig             # restore terminal setting.
        done

        sh ~/.scripts/networking/setupHotspot $1 $2 $BAND $passwd
        echo "#!/bin/sh" > ~/.scripts/networking/startHotspot$2
        echo "nmcli con up \"${2}\"" >> ~/.scripts/networking/startHotspot$2
    fi
}