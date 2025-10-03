FROM debian:13-slim

RUN apt update && \
	apt install -y \
	iproute2 \
	iputils-ping \
	netcat-openbsd \
	socat \
	procps \
	nano \
	xxd \
	iperf3

# add chargen.sh (character generator)
ADD chargen.sh /
RUN chmod 755 /chargen.sh

# start init.sh at container start
ADD init.sh /
RUN chmod 755 /init.sh
CMD ["/init.sh"]

# don't wait for 10s at container stop, kill immediately
STOPSIGNAL SIGKILL
