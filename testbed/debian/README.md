# Installation Part 2/2: Debian

A general testbed introduction can be found at: [testbed](..)

The following expects a running Debian 13 installation and the files from this debian folder somewhere available in it. It shouldn't make a big difference, if Debian runs on bare metal, a VM or WSL. However, only WSL is currently used by me.

## Overview

![Testbed Overview](../../images/ipv6_testbed_debian.svg "Testbed Overview")

After the call of setup.sh (see below), all colored parts will be installed and prepared.

### Debian

The bash in Debian is the main place to interact with Wireshark and manipulate the docker container. You can us the aliases alice, bob or router to enter the bash in the corresponding container.

### Container

| Name | MAC Address | Link Local Address | Unique Local Address (ULA) | Content | Details |
| --- | --- | --- | --- | --- | --- |
| **alice** | 00:00:00:00:00:aa | fe80::200:ff:fe00:aa | fd9f:7fa1:4256::aa | interactive tools and running test services for IPv6 | [client_container](client_container) |
| **bob** | 00:00:00:00:00:bb | fe80::200:ff:fe00:bb | fd9f:7fa1:4256::bb | same as alice but with a different IPv6 address | [client_container](client_container) |
| **router** | 00:00:00:00:00:ee | fe80::200:ff:fe00:ee | fd9f:7fa1:4256::ee | radvd daemon (IPv6 router advertisement) | [router_container](router_container) |

The address suffixes aa, bb and ee become very handy when looking into Wireshark captures :smile:

The addresses are configured in the [docker-compose.yml](docker-compose.yml) file. The link local addresses are created automatically based on the MAC address using the SLAAC algorithm.


## Installation & First Start

The following expects the files from the debian folder somehow available in Debian. The WSL installation described in [wsl](../wsl) makes this available in the folder ~/ipv6

Call [setup.sh](setup.sh) to prepare Debian packages, start the container and all that:

```
root@delle:~/ipv6# ./setup.sh
-----------------------------------------------------------------------------
--- check environment ---
- check distro to be debian version 13
Seems to be Debian 13 -> GOOD
- TODO: Check user to be root
- check internet connection to deb.debian.org
deb.debian.org seems ok -> GOOD
-----------------------------------------------------------------------------
--- apt install / update programs ---
<<< SNIP >>>
...
<<< SNIP >>>
-----------------------------------------------------------------------------
--- check container ---
- execute iperf3 'alice is calling bob'
Connecting to host fd9f:7fa1:4256::bb, port 5201
[  5] local fd9f:7fa1:4256::aa port 38550 connected to fd9f:7fa1:4256::bb port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  4.47 GBytes  38.3 Gbits/sec  747    976 KBytes
[  5]   1.00-2.00   sec  4.24 GBytes  36.4 Gbits/sec    0   1019 KBytes
[  5]   2.00-3.00   sec  4.36 GBytes  37.4 Gbits/sec  452   1.04 MBytes
[  5]   3.00-4.00   sec  4.50 GBytes  38.7 Gbits/sec    0   1.04 MBytes
[  5]   4.00-5.00   sec  4.34 GBytes  37.3 Gbits/sec  386   1.04 MBytes
[  5]   5.00-6.00   sec  4.24 GBytes  36.4 Gbits/sec    0   1.04 MBytes
[  5]   6.00-7.00   sec  4.45 GBytes  38.3 Gbits/sec  477   1.04 MBytes
[  5]   7.00-8.00   sec  4.38 GBytes  37.6 Gbits/sec    0   1.05 MBytes
[  5]   8.00-9.00   sec  4.42 GBytes  38.0 Gbits/sec    0   1.05 MBytes
[  5]   9.00-10.01  sec  4.39 GBytes  37.4 Gbits/sec    0   1.08 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec  44.1 GBytes  37.8 Gbits/sec  2062            sender
[  5]   0.00-10.01  sec  44.1 GBytes  37.8 Gbits/sec                  receiver

iperf Done.
09:32:48 root@delle ~/ipv6 #
```

Running the script for the first time on a fresh Debian will take some time downloading and installing: apt package upgrades, docker and container images.

It should be safe to rerun [setup.sh](setup.sh) at anytime later again without damaging anything. Running it a second time will also be much faster.

## Check Services

### Start Wireshark

Start wireshark and capture on alice's container interface:

```
root@delle ~/ipv6 # ./helper/wiredock.sh alice
Starting Wireshark capture on container: alice at interface: veth6b0bf3e
root@delle ~/ipv6 #
```
Hint: The container eth0 interface is identical to the veth... interface of the Debian system. As the number in veth6b0bf3e changes every container start, the script finds the current veth number by the container name.

### Start Netcat on alice and call bob

Enter the bash in the container alice by entering `alice` (aliases were created for the container alice, bob and router). Then execute netcat `nc -6 fd9f:7fa1:4256::bb 19` to reach out for chargen over IPv6 which is running on bob:
```
root@delle:~/ipv6# alice
root@alice:/# nc -6 fd9f:7fa1:4256::bb 19
 !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefg
!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefgh
"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghi
#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghij
<<< SNIP >>>
```

In Wireshark you should see TCP Chargen packets running over IPv6 (beside many other IPv6 traffic).

## Available IPv6 Services

Ping IPv6 to localhost: `ping6 ::1` (should always work).

The following IPv6 services are available on both alice and bob:

| Service | Port| Remark | Wikipedia |
| --- | --- | --- | --- |
| echo | 7/tcp or 7/udp | Echoes traffic send to it | https://en.wikipedia.org/wiki/Echo_Protocol |
| discard | 9/tcp or 9/udp | Silently discards all incoming traffic | https://en.wikipedia.org/wiki/Discard_Protocol |
| chargen | 19/tcp or 19/udp | Creates an endless series of ASCII characters | https://en.wikipedia.org/wiki/Character_Generator_Protocol |
| iperf3 | 5201/tcp | TCP / UDP performance measurements | https://en.wikipedia.org/wiki/Iperf#iperf3 |

Tests from alice to bob:

| Service | Protocol | Command on alice | Remark | Wireshark Capture |
| --- | --- | --- | --- | --- |
| ping6 | ICMPv6 | `ping6 fd9f:7fa1:4256::bb` | bob's unique local address | ping6_alice_to_bob_fd9f.pcapng |
| ping6 | ICMPv6 | `ping6 fe80::200:ff:fe00:bb%eth0` | bob's link local address, **beware the %eth0 suffix!**) | TODO:  |
| echo | TCP | `nc -6 fd9f:7fa1:4256::bb 7` | enter some text, should be echoed | TODO: |
| echo | UDP | `nc -6 -u fd9f:7fa1:4256::bb 7` | enter some text, should be echoed | TODO: |
| discard | TCP | `nc -6 fd9f:7fa1:4256::bb 9` | enter some text, nothing happens | TODO: |
| discard | UDP | `nc -6 -u fd9f:7fa1:4256::bb 9` | enter some text, nothing happens | TODO: |
| chargen | TCP | `nc -6 fd9f:7fa1:4256::bb 19` | - | TODO: |
| chargen | UDP | `nc -6 -u fd9f:7fa1:4256::bb 19` | press enter once! | TODO: |
| iperf3 | TCP | `iperf3 -6 -c fd9f:7fa1:4256::bb` | - | TODO: |
| iperf3 | UDP | `iperf3 -6 -u -c fd9f:7fa1:4256::bb` | only 1 MBits/s?!? | TODO: |
