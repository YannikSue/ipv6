FROM debian:13-slim

RUN apt update && \
	apt install -y \
	iproute2 \
	iputils-ping \
	netcat-openbsd \
	procps \
	nano \
	radvd \
	isc-dhcp-server

# init router services
ADD init.sh /
RUN chmod 755 /init.sh
CMD ["/init.sh"]

# don't wait for 10s at container stop, kill immediately
STOPSIGNAL SIGKILL
