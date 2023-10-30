#!/bin/bash

set -e
set -o pipefail

echo -e "\e[94mFetching the URL of the latest version...\e[39m"
ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")
INSTALL_DIR="/opt"

echo -e "\e[94mDownload and installing $ARCHIVE_FILENAME...\e[39m"
sudo wget --show-progress -O- "$ARCHIVE_URL" | sudo tar -xzf - --strip-components=1 -C /opt
#sudo curl -L --progress-bar "$ARCHIVE_URL" | sudo tar -xzf - --strip-components=1 -C /opt

#echo -e "\e[94mSetting Launcher Icon on Windows...\e[39m"
#echo -e "[Desktop Entry]\nType=Application\nName=Jetbrains Toolbox\nExec=/opt/jetbrains-toolbox" | sudo tee /usr/share/applications/toolbox.desktop

sudo apt install -y libgtk-3-dev

if [ -z "$CI" ]; then
	echo -e "\e[94mRunning for the first time to set-up...\e[39m"
	( "$INSTALL_DIR/jetbrains-toolbox" & )
	echo -e "\n\e[32mDone! JetBrains Toolbox should now be running, in your application list, and you can run it in terminal as jetbrains-toolbox (ensure that $SYMLINK_DIR is on your PATH)\e[39m\n"
else
	echo -e "\n\e[32mDone! Running in a CI -- skipped launching the AppImage.\e[39m\n"
fi