#!/bin/sh

DisableService() {
    sudo systemctl disable $1
}

EnableService() {
    sudo systemctl enable $1
}

StartService() {
    sudo systemctl start $1
}

DiableService() {
    sudo systemctl stop $1
}
