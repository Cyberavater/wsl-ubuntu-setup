#!/bin/bash

set -e
set -o pipefail

echo -e "\e[94mAdding Repositories...\e[39m"
sudo apt install -y gpg-agent wget
wget -y --show-progress -O- https://repositories.intel.com/graphics/intel-graphics.key |
  sudo gpg --dearmor --force --output /usr/share/keyrings/intel-graphics.gpg
echo 'deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu jammy arc' | sudo tee /etc/apt/sources.list.d/intel.gpu.jammy.list

echo -e "\e[94mInstalling GPU Runtime...\e[39m"
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
  intel-opencl-icd intel-level-zero-gpu level-zero \
  intel-media-va-driver-non-free libmfx1 libmfxgen1 libvpl2 \
  libegl-mesa0 libegl1-mesa libegl1-mesa-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri \
  libglapi-mesa libgles2-mesa-dev libglx-mesa0 libigdgmm12 libxatracker2 mesa-va-drivers \
  mesa-vdpau-drivers mesa-vulkan-drivers va-driver-all

echo -e "\e[94mInstalling development packages...\e[39m"
sudo apt install -y \
  libigc-dev \
  intel-igc-cm \
  libigdfcl-dev \
  libigfxcmrt-dev \
  level-zero-dev

echo -e "\e[94mVerifying installation...\e[39m"
sudo apt install clinfo
clinfo