#!/bin/bash

VERSION="0.13.2"

[ $(id -u) -ne 0 ] && sudo="sudo" || sudo=""
id -u nobody >/dev/null 2>&1
if [ $? -ne 0 ]; then
    $sudo groupadd nogroup
    useradd -g nogroup nobody -s /bin/false
fi

$sudo mkdir -p /var/stathub
$sudo chown -R $(id -u -n):$(id -g -n) /var/stathub
if [ ! -d /var/stathub ]; then
    echo "Unable to create dir /var/stathub and chown to current user, Please manual do it"
    exit 1
fi
cd /var/stathub
cp /opt/stathub/*.gz /var/stathub
command_exists() {
    type "$1" &> /dev/null
}

if [ ! -f server_$(uname -m).tar.gz ]; then
    echo "Unable to get server file, Please manual download it"
    echo server_$(uname -m).tar.gz
    exit 1
fi
tar zxf server_$(uname -m).tar.gz
rm -rf server_$(uname -m).tar.gz

if [ -z "$(grep stathub /etc/rc.local)" ]; then
    $sudo sh -c 'echo "cd /var/stathub; rm -f data/stathub.pid; ./service start >/var/stathub/data/stathub.log 2>&1" >> /etc/rc.local'
fi

echo "----------------------------------------------------"
echo "| Server install sucessful, Please start it using  |"
echo "| ./service {start|stop|restart}                   |"
echo "| Now it will automatic start                      |"
echo "|                                                  |"
echo "| Feedback: https://github.com/likexian/stathub-go |"
echo "| Thank you for your using, By Li Kexian           |"
echo "| StatHub, Apache License, Version 2.0             |"
echo "----------------------------------------------------"

#$sudo ./service start
#sleep 1

#KEY=$(grep key server.json | cut -d \" -f 4)
#STATHUB_CLIENT_URL=https://127.0.0.1:15944/node?key=$KEY
#if command_exists wget; then
#    wget --no-check-certificate -O - $STATHUB_CLIENT_URL | sh
#elif command_exists curl; then
#    curl --insecure $STATHUB_CLIENT_URL | sh
#else
#    echo "Unable to find curl or wget, Please install and try again."
#    exit 1
#fi
