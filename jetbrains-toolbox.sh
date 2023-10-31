#!/bin/bash

set -e
set -o pipefail

INSTALL_DIR="$HOME/.local/share/JetBrains/Toolbox/bin"

SYMLINK_DIR="$HOME/.local/bin"
TMP_DIR="/tmp"

echo -e "\e[94mFetching the URL of the latest version...\e[39m"
ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

echo -e "\e[94mDownload and installing $ARCHIVE_FILENAME...\e[39m"
sudo wget --show-progress -O- "$ARCHIVE_URL" | sudo tar -xzf - --strip-components=1 -C "$TMP_DIR"


echo -e "\e[94mInstall dependencies...\e[39m"
sudo apt update
sudo apt install -y libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin tar


echo -e "\e[94mSetup and Symlinking to $SYMLINK_DIR/jetbrains-toolbox...\e[39m"
echo -e "\e[94mRunning for the first time to set-up...\e[39m"
( "$INSTALL_DIR/jetbrains-toolbox" & )
mkdir -p "$SYMLINK_DIR"
rm "$SYMLINK_DIR/jetbrains-toolbox" 2>/dev/null || true
ln -s "$INSTALL_DIR/jetbrains-toolbox" "$SYMLINK_DIR/jetbrains-toolbox"
echo -e "\n\e[32mDone! JetBrains Toolbox should now be running, in your application list, and you can run it in terminal as jetbrains-toolbox (ensure that $SYMLINK_DIR is on your PATH)\e[39m\n"


echo -e "\e[94mAdding to Environment and Setting Launcher Icon on Windows...\e[39m"
echo -e "[Desktop Entry]\nType=Application\nName=Jetbrains Toolbox\nExec=$INSTALL_DIR" | tee /usr/share/applications/toolbox.desktop
