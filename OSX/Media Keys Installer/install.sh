#!/bin/sh

# Install the sway.fm media key handler native messaging client
syslog -s -l error "1"
# Point to the executable in the extension so it can be updated without requiring a reinstall every time.
binaryPath="/Library/Google/Chrome/NativeMessagingHosts/mediakeys"
syslog -s -l error "2"
manifestJson=`cat "$1/fm.sway.mediakeys.json-template"`
manifestJson=`echo $manifestJson | sed -e "s|%BINARY_PATH%|${binaryPath}|g"`
mkdir -p /Library/Google/Chrome/NativeMessagingHosts
syslog -s -l error "3"
echo $manifestJson | sudo tee /Library/Google/Chrome/NativeMessagingHosts/fm.sway.mediakeys.json > /dev/null
syslog -s -l error "4"
sudo cp "$1/mediakeys" ${binaryPath}
syslog -s -l error "$1/mediakeys"
syslog -s -l error ${binaryPath}
