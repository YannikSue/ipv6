#!/bin/bash
# Install docker packages from docker repositories into debian

# As debian's native docker packages are often pretty old, install the packages directly from docker:
# https://docs.docker.com/engine/install/debian/
# https://linuxiac.com/how-to-install-docker-on-debian-13-trixie/
# Tested on debian 13 "trixie", may work on other versions or debian based distros.


echo "- uninstall potentially conflicting 'e.g. native debian' packages"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove -y $pkg; done


echo "- Add Docker's official GPG key"
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "- Add the repository to the Apt sources"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "- install the latest version"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


echo "- check docker is installed"
DOCKER_VERSION=`docker --version | grep "Docker version"`
if [[ "$DOCKER_VERSION" != '' ]]; then
  echo "Docker seems to be installed: '$DOCKER_VERSION' -> GOOD"
else
  echo "Seems docker failed to install"
  exit -1
fi

# TODO: Make this even more robust:
# TODO: Check correct installation of the other installed docker programs?
# TODO: Check docker version to be higher than x?
