# Router Container

A docker container intended to provide various IPv6 related infrastructure service daemons.

**:warning: WARNING: The following services are highly experimental!**

* [Dockerfile](Dockerfile): configuration of the docker container
* [init.sh](init.sh): bash script to prepare and start the daemons
* radvd.conf
* dhcpd6.conf

## Router Advertisement Daemon (radvd)

Used to provide the client with "Router Advertisement (RA)" packets. These especially informs the IPv6 client with some config flags (e.g. whether to use DHCPv6 or SLAAC).

https://en.wikipedia.org/wiki/Radvd

## ISC DHCP server

Used to provide the client with various "address configuration data".

Dynamic Host Configuration Protocol Daemon (DHCPD): https://en.wikipedia.org/wiki/DHCPD

**BEWARE: ISC DHCPD is EOL since 2022! (what else to use instead? KEA?)**

DHCPv6 daemon is started in IPv6 mode and won't server DHCPv4.
