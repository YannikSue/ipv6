#!/bin/bash

# Discard service: Silently discards all incoming traffic
# https://en.wikipedia.org/wiki/Discard_Protocol
# service on well-known port 9 using IPv6 (runs in background)
nc -6 -l 9 &
nc -6 -l -u 9 &

# Echo service: Echos traffic send to it
# https://en.wikipedia.org/wiki/Echo_Protocol
# service on well-known port 7 using IPv6 (runs in background)
socat -v tcp6-l:7,fork exec:'/bin/cat' &
socat -v udp6-l:7,fork exec:'/bin/cat' &

# Chargen service: Creates a series of ASCII characters
# https://en.wikipedia.org/wiki/Character_Generator_Protocol
# service on well-known port 19 using IPv6 (runs in background)
socat -v tcp6-l:19,fork exec:'/chargen.sh' &
socat -v udp6-l:19,fork exec:'/chargen.sh' &

# iperf3 service
iperf3 -s > /iperf3.log &


# if we would exit here the container would stop, so wait until doomsday
sleep infinity
