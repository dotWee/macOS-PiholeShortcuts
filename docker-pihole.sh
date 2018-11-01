#!/bin/bash

#  docker-pihole.sh
#  Shortcuts for Pi-hole
#
#  Created by Lukas Wolfsteiner on 01.11.18.
#  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.

status() {
    # Lookups may not work for VPN / tun0
    IP_LOOKUP="$(ip route get 8.8.8.8 | awk '{for(i=1;i<=NF;i++) if ($i=="src") print $(i+1)}')"
    IPv6_LOOKUP="$(ip -6 route get 2001:4860:4860::8888 | awk '{for(i=1;i<=NF;i++) if ($i=="src") print $(i+1)}')"

    # Just hard code these to your docker server's LAN IP if lookups aren't working
    IP="${IP:-$IP_LOOKUP}"  # use $IP, if set, otherwise IP_LOOKUP
    IPv6="${IPv6:-$IPv6_LOOKUP}"  # use $IPv6, if set, otherwise IP_LOOKUP
    WEBPASSWORD="Test66SuperSecret"

    # Default of directory you run this from, update to where ever.
    DOCKER_CONFIGS="$(pwd)"
}

start() {
    stop
    status

    CONTAINER=`docker run -d --name pihole -p 53:53/tcp -p 53:53/udp -p 67:67/udp -p 80:80 -p 443:443 -v "${DOCKER_CONFIGS}/pihole/:/etc/pihole/" -v "${DOCKER_CONFIGS}/dnsmasq.d/:/etc/dnsmasq.d/" -e ServerIP="${IP}" -e ServerIPv6="${IPv6}" -e WEBPASSWORD="${WEBPASSWORD}" --restart=unless-stopped --cap-add=NET_ADMIN --dns=127.0.0.1 --dns=1.1.1.1 pihole/pihole:latest`
    echo "### Pi-hole is running as container ${CONTAINER} with IP ${IP}"
    echo "### Your password for http://127.0.0.1/admin/ is ${WEBPASSWORD}"

    APIKEY=`docker exec -it pihole cat /etc/pihole/setupVars.conf | grep WEBPASSWORD`
    echo "### Your API key is ${APIKEY/WEBPASSWORD=/}"
}

stop() {
    docker container stop pihole
    docker container rm pihole
}

logs() {
    docker container logs -f pihole
}

usage() {
    echo >&2 \
        "usage: $0  [start | stop | status | logs]"
}

if [ $# -eq 0 ]
then
    usage
    exit 1
fi
while [ $# -gt 0 ]
do
    case "$1" in
        status) status;;
        start)  start;;
        stop)  stop;;
        logs)  logs;;
        --)     shift; break;;
        *)
            usage
            exit 1;;
    esac
    shift
done
