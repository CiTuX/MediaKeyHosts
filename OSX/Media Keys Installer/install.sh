#!/bin/sh

# Install the sway.fm media key handler native messaging client
binaryPath="/Library/Google/Chrome/NativeMessagingHosts/mediakeys"
manifestJson=`cat "$1/fm.sway.mediakeys.json-template"`
manifestJson=`echo $manifestJson | sed -e "s|%BINARY_PATH%|${binaryPath}|g"`
mkdir -p /Library/Google/Chrome/NativeMessagingHosts
echo $manifestJson | tee /Library/Google/Chrome/NativeMessagingHosts/fm.sway.mediakeys.json > /dev/null
cp "$1/mediakeys" ${binaryPath}
