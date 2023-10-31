#!/bin/bash

set -e
set -o pipefail

echo -e "\e[94mFetching the URL of the latest version...\e[39m"
ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

echo -e "\e[94mDownload and installing $ARCHIVE_FILENAME...\e[39m"
sudo wget --show-progress -O- "$ARCHIVE_URL" | sudo tar -xzf - --strip-components=1 -C /opt

echo -e "\e[94mInstall dependencies...\e[39m"
sudo apt update
sudo apt install -y libfuse2 xterm

echo -e "\e[94mAdding to Environment and Setting Launcher Icon on Windows...\e[39m"
echo -e "[Desktop Entry]\nType=Application\nName=Jetbrains Toolbox\nExec=" | sudo tee /usr/share/applications/toolbox.desktop
