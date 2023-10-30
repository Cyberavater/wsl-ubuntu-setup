#!/bin/bash

echo -e "\e[94mFetching the URL of the latest version...\e[39m"
ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

echo -e "\e[94mDownload and installing $ARCHIVE_FILENAME...\e[39m"
#sudo wget --show-progress -O- "$ARCHIVE_URL" | sudo tar -xzf - -C /opt
sudo curl -L --progress-bar "$ARCHIVE_URL" | sudo tar -xzf - -C /opt

echo -e "\e[94mSetting Launcher Icon on Windows...\e[39m"
echo -e "[Desktop Entry]\nType=Application\nName=Jetbrains Toolbox\nExec=/opt/jetbrains-toolbox" | sudo tee /usr/share/applications/toolbox.desktop

