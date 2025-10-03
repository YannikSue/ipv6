#!/bin/bash

### radvd ###
# Router Advertisement Daemon (radvd): https://en.wikipedia.org/wiki/Radvd

# see docker-compose.yml comment why we have to do hacks here
cp /radvd.conf /etc/radvd.conf
chmod 754 /etc/radvd.conf

# start Daemon
/usr/sbin/radvd -C /etc/radvd.conf -p /run/radvd.pid -n -m logfile -l /radvd.log -u radvd &



### ISC DHCP server ###
# Dynamic Host Configuration Protocol Daemon (DHCPD): https://en.wikipedia.org/wiki/DHCPD
# BEWARE: ISC DHCPD is EOL since 2022! (what else to use instead? KEA?)

# see docker-compose.yml comment why we have to do hacks here
cp /dhcpd6.conf /etc/dhcp/dhcpd6.conf
chmod 754 /etc/dhcp/dhcpd6.conf

# create an empty leases file, otherwise dhcpd won't start
touch /var/lib/dhcp/dhcpd6.leases

# start Daemon
/usr/sbin/dhcpd -6 -cf /etc/dhcp/dhcpd6.conf -pf /run/dhcpd6.pid -tf /dhcpd6.log



### Sleep endlessly, otherwise container would stop ###
sleep infinity
