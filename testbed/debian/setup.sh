#!/bin/bash

echo -----------------------------------------------------------------------------
echo --- check environment ---

echo - check distro to be debian version 13
OS_REL=`cat /etc/os-release | grep PRETTY_NAME`
if [[ "$OS_REL" != 'PRETTY_NAME="Debian GNU/Linux 13 (trixie)"' ]]; then
  echo "Installed distribution isn't Debian 13: " $OS_REL
  exit -1
else
  echo "Seems to be Debian 13 -> GOOD"
fi

echo - TODO: Check user to be root

echo - check internet connection to deb.debian.org
# (check without the need of installing any apt packages or using ping, as ICMP is probably blocked)
# (see: https://www.baeldung.com/linux/internet-connection-bash-test)
DEBIAN_CHECK=`cat < /dev/null > /dev/tcp/deb.debian.org/80; echo $?`
if [[ "$DEBIAN_CHECK" == 0 ]]; then
  echo "deb.debian.org seems ok -> GOOD"
else
  echo "Can't connect to deb.debian.org: " $DEBIAN_CHECK
  exit -1
fi

echo -----------------------------------------------------------------------------
echo --- apt install / update programs ---

echo - apt update: update package lists
apt update
echo "TODO: check update result"
# (hint: checking for the return value is not good enough. It returns ok even if the download failed!)

echo - apt upgrade: upgrade all packages
apt upgrade -y
echo "TODO: check upgrade result"

echo - apt install wireshark
# hint: avoid being asked how to install wireshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
apt install -y wireshark
WHICH_WIRESHARK=`which wireshark`
if [[ "$WHICH_WIRESHARK" != '/usr/bin/wireshark' ]]; then
  echo "Installed Wireshark looks unexpected: " $WHICH_WIRESHARK
  exit -1
else
  echo "Wireshark found -> GOOD"
fi

echo -----------------------------------------------------------------------------
echo --- install docker ---

./helper/debian-install-docker.sh
if [[ "$?" != 0 ]]; then
  echo "Failed to install docker"
  exit -1
else
  echo "Docker installed -> GOOD"
fi

echo -----------------------------------------------------------------------------
echo --- start the container ---

echo - remove all existing container
CONTAINER=`docker ps -a -q`
#echo CONTAINER: $CONTAINER
if [[ "$CONTAINER" != '' ]]; then
  docker rm -f $(docker ps -a -q)
else
  echo "No Containers to delete"
fi

# TODO: throw away all old container stuff (images, networks, ...)?
# docker system prune -a

echo - start all container from docker-compose.yml
cd /root/ipv6
docker compose up -d

echo - check container are started
ALICE_CONTAINER=`docker ps | grep alice`
if [[ "$ALICE_CONTAINER" == '' ]]; then
  echo "Container 'alice' not found -> seems something is wrong with the container setup"
  exit -1
else
  echo "Container 'alice' is running -> GOOD"
fi

BOB_CONTAINER=`docker ps | grep bob`
if [[ "$BOB_CONTAINER" == '' ]]; then
  echo "Container 'bob' not found -> seems something is wrong with the container setup"
  exit -1
else
  echo "Container 'bob' is running -> GOOD"
fi

ROUTER_CONTAINER=`docker ps | grep router`
if [[ "$ROUTER_CONTAINER" == '' ]]; then
  echo "Container 'router' not found -> seems something is wrong with the container setup"
  exit -1
else
  echo "Container 'router' is running -> GOOD"
fi

echo -----------------------------------------------------------------------------
echo --- prepare bash ---

# Use .bashrc with more comfort (e.g. coloring)
# --update only copies if source is newer or target doesn't exist
cp --update ./helper/.bashrc ~/.bashrc
source ~/.bashrc

echo -----------------------------------------------------------------------------
echo --- check container ---

echo "- execute iperf3 'alice is calling bob'"
# docker exec -it alice iperf3 -6 -c 2001:db8::bb
docker exec -it alice iperf3 -6 -c fd9f:7fa1:4256::bb

# echo "- execute chargen 'alice is calling bob'"
# docker exec -it alice nc -6 fd9f:7fa1:4256::bb 19
