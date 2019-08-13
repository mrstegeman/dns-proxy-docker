FROM debian:buster

RUN apt update && \
    apt dist-upgrade -y && \
    apt install -y \
        ca-certificates \
        dnsmasq \
        runit \
        stubby && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    touch /etc/inittab

ADD init /
ADD etc/dnsmasq.conf /etc/dnsmasq.conf
ADD etc/service /etc/service
ADD etc/stubby/stubby.yml /etc/stubby/stubby.yml

ENTRYPOINT ["/init"]
