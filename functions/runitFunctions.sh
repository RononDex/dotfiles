#!/bin/sh

DisableService() {
    sudo rm /var/service/$1
}

EnableService() {
    sudo ln -s /etc/sv/$1 /var/service/
}

StartService() {
    sudo sv up $1
}

DiableService() {
    sudo sv down $1
}
