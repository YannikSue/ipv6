# IPv6 testbed

Testbed for IPv6 (container based) experiments.

It can be used to play around with netcat, iperf3, Wireshark and such tools using IPv6 on a docker network.

The whole testbed can be set up by simply running three scripts with a minimum of manual interaction.

## Overview

At its heart, the testbed uses Debian with a docker network and some docker containers for the IPv6 experiments.

![Testbed Overview](../images/ipv6_testbed.svg "Testbed Overview")

The setup contains several layers:

* Windows machine with WSL (optional, see below)
* Debian with docker and wireshark
* docker containers with IPv6 tools (netcat, iperf3, radvd, ...)

I'm using WSL with Debian 13 as described below. A Debian 13 installed in a VM or on bare metal could also work (haven't tried it). Just clone/copy the repository files into it and directly jump to the [debian](debian) page.

---

## Installation

The installation is easily done by running three scripts that installs and configures all necessary parts:

wsl

* `wsl-install.bat`: prepare WSL with a running Debian distro (only needed to run once)
* `wsl-start.bat`: start wsl with the right settings (everyday use)

**Follow the instructions on [wsl](wsl) to install Debian 13 (including the required WSL settings) into WSL.**

debian

* `setup.sh`: prepare Wireshark, docker and the containers

**Follow the instructions on [debian](debian) to install tools and settings into Debian for the actual IPv6 experiments.**

---

## Known Limitations

Each testbed container uses an IPv6 Unique Local Address (ULA) that is hard coded in the *docker-compose.yml* and that address can only be changed in that file. The containers can't be configured to use addresses from a DHCPv6 server or SLAAC (which is a know docker limitation, as of 2025.08).
