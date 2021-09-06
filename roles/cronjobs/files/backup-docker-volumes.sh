#!/bin/sh

CONTAINERS=(
    baikal
    ghost
    traefik
    turtl-db
    turtl-server
    vaultwarden
)

VOLUMES=(
    baikal_config
    baikal_data
    ghost
    letsencrypt
    traefik
    turtl
    vaultwarden
    )

docker stop ${CONTAINERS[@]}

rsync -vargo ${VOLUMES[@]} /mnt/blockstorage/docker-volume-backups
cd docker-volume-backups
tar cvf docker_volumes_backups_$(date '+%d-%m-%Y').tar *

docker start ${CONTAINERS[@]}
