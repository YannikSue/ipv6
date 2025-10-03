#!/bin/bash
# Start a Wireshark capture on the interface veth... that represents eth0 of the given docker container
#
# based on: https://superuser.com/questions/1183454/finding-out-the-veth-interface-of-a-docker-container
CONTAINER_NAME=$1
WIRESHARK_PARAMETERS=$2

# check if at least parameter $1 is set
if [ -z $1 ]; then
    echo "$0: missing first parameter, at least a container name must be specified"
    echo ""
    echo "$0"
    echo Start a Wireshark capture on the interface veth... that represents eth0 of the given docker container
    echo "Usage: $0 <containername> [<wireshark_parameters>]"
    echo "Hint: Use 'docker ps' to get a list of available container names"
    exit -1
fi

# find veth of container
iflink=`docker exec -it $CONTAINER_NAME bash -c 'cat /sys/class/net/eth0/iflink'`
iflink=`echo $iflink|tr -d '\r'`
veth=`grep -l $iflink /sys/class/net/veth*/ifindex`
veth=`echo $veth|sed -e 's;^.*net/\(.*\)/ifindex$;\1;'`

# start wireshark
# Parameter -k immediately starts capturing and setting the log level avoids clutter on the console
echo Starting Wireshark capture on container: "$CONTAINER_NAME" at interface: "$veth"
wireshark --interface $veth -k --log-level critical $WIRESHARK_PARAMETERS &
