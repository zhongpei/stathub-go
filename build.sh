#!/bin/bash

echo '+ building stathub start'
[ ! -d stathub ] && mkdir stathub
rm -rf tmp && mkdir tmp 
cd tmp && mkdir static
cd ..


echo 'building the client'
cd client
go get
go build
cd ..
mv client/client tmp


cp CHANGS.md tmp
cp CHANGS-ZH.md tmp
cp LICENSE.md tmp
cp README.md tmp
cp README-ZH.md tmp
cp VERSION tmp


echo 'building the server'
cd server
go get
go build
cd ..
mv server/server tmp
cp server/service tmp


command_exists() {
    type "$1" &> /dev/null
}

echo 'goupxing binary files'
cd tmp
if command_exists goupx; then
    goupx server client >/dev/null 2>&1
fi

echo 'packaging the client'
tar zcf client_$(uname -m).tar.gz client VERSION *.md

cp client_$(uname -m).tar.gz static

echo 'packaging the server'
tar zcf server_$(uname -m).tar.gz server service static VERSION *.md


cd ..
#cp tmp/server_$(uname -m).tar.gz tmp/client_$(uname -m).tar.gz stathub
#rm -rf tmp

cp tmp/server_$(uname -m).tar.gz /opt/stathub
cp tmp/client_$(uname -m).tar.gz /opt/stathub
echo '+ building stathub done'
