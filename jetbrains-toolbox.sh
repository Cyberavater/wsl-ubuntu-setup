#!/bin/bash

set -e
set -o pipefail

INSTALL_DIR="/opt"
#SYMLINK_DIR="$HOME/.local/bin"

echo -e "\e[94mFetching the URL of the latest version...\e[39m"
ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

echo -e "\e[94mDownload and installing $ARCHIVE_FILENAME...\e[39m"
sudo wget --show-progress -O- "$ARCHIVE_URL" | sudo tar -xzf - -C "/opt"


echo -e "\e[94mInstall dependencies...\e[39m"
sudo apt update
sudo apt install -y libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin tar

#echo -e "\e[94mSymlinking to $SYMLINK_DIR/jetbrains-toolbox...\e[39m"
#mkdir -p "$SYMLINK_DIR"
#rm "$SYMLINK_DIR/jetbrains-toolbox" 2>/dev/null || true
#ln -s "$INSTALL_DIR/jetbrains-toolbox" "$SYMLINK_DIR/jetbrains-toolbox"

#
#echo -e "\e[94mAdding to Environment and Setting Launcher Icon on Windows...\e[39m"
#echo -e "[Desktop Entry]\nType=Application\nName=Jetbrains Toolbox\nExec=/opt/jetbrains-toolbox" | sudo tee /usr/share/applications/toolbox.desktop
