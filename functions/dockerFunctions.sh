#!/bin/bash

SetupJellyFin() {
    sudo docker pull jellyfin/jellyfin
    sudo useradd -r jellyfin-docker
    sudo usermod -a -G basicfilesharing jellyfin-docker
    sudo docker run -d \
        --name jellyfin \
        --user 916:1003 \
        --net=host \
        --volume /data/containers/docker/volumes/jellyfin-config:/config \
        --volume /data/containers/docker/volumes/jellyfin-cache:/cache \
        --volume /data/containers/docker/volumes/jellyfin-config/web-config.json:/jellyfin/jellyfin-web/config.json \
        --mount type=bind,source=/data/Downloads,target=/media,ro=true \
        --restart=unless-stopped \
        --device /dev/dri/renderD128:/dev/dri/renderD128 \
        --device /dev/dri:/dev/dri \
        --device /dev/dri/card0:/dev/dri/card0 \
        -e DOCKER_MODS=linuxserver/mods:jellyfin-amd \
        jellyfin/jellyfin
}
