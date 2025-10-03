# User Container

A docker container intended to provide various IPv6 related interactive tools and service daemons.

* [Dockerfile](Dockerfile): configuration of the docker container
* [init.sh](init.sh): bash script to prepare and start the daemons
* [chargen.sh](chargen.sh) helper script to generate chargen ASCII data

## Interactive Tools

* ip: get local IP address infos
* ping6: ping for IPv6
* nc: netcat "network swiss army knife"
* iperf3: performance test

TODO: relevant tools missing?

## Service Daemons

The running service daemons (echo, discard, chargen and iperf3) are described at the [debian](..) page.
