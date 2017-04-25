#!/bin/bash

# selenium:3.0.2  geckodriver:v0.13.0 
# selenium:3.4.0  geckodriver:v0.16.0 (when i test ,show error info :selenium.common.exceptions.WebDriverException: Message: Unable to find a matching set of capabilities)
# firefox >=47
# https://github.com/mozilla/geckodriver/releases
GECKOD_VERSION=${GECKOD_VERSION:-"v0.13.0"}

set -e

echo "***** Start to Install Firefox and Geckodriver *****"

apt-get update

echo "***** To install Firefox *****"
apt-get -y install wget curl unzip

wget -q -O - http://mozilla.debian.net/archive.asc | apt-key add -

cat << EOF | tee /etc/apt/sources.list.d/mozilla-firefox.list
deb http://mozilla.debian.net/ jessie-backports firefox-release
EOF

cat << EOF | tee /etc/apt/preferences.d/mozilla-firefox
Package: *
Pin: origin mozilla.debian.net
Pin-Priority: 501
EOF

apt-get update
apt-get -y install firefox

showstatus=$(apt-cache policy firefox)
echo "***** Installed firefox of : *****"
echo "$showstatus"

echo "***** To install display *****"
apt-get -y install xvfb
pip install pyvirtualdisplay

echo "***** To install geckodriver *****"
cd /tmp/
curl -SL -k https://github.com/mozilla/geckodriver/releases/download/$GECKOD_VERSION/geckodriver-$GECKOD_VERSION-linux64.tar.gz -O
tar -zxvf geckodriver-$GECKOD_VERSION-linux64.tar.gz
mv ./geckodriver /usr/local/bin/
chmod a+x /usr/local/bin/geckodriver
apt-get -y remove wget curl unzip
rm -rf /tmp/* /var/lib/apt/lists/*
echo "***** Installed geckodriver *****"

echo "***** All Installed OK *****"