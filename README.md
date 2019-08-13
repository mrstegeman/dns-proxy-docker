# dns-proxy

This is a simple DNS proxy which forwards everything out over DNS-over-TLS. It also allows you to specify custom dnsmasq address handlers, in case you'd like to handle some resolution locally, e.g. for your home network.

The default configuration uses Quad 9 and Cloudflare as the upstreams. This can be changed in `etc/stubby/stubby.yml`.

To add address handlers, you can set the `DNSMASQ_ADDRESSES` environment variable to a comma-separate listed of `address` directives. For the format, see the [documentation](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html).

## Running

```bash
docker build -t dns-proxy .
docker run \
    -d \
    --net host \
    --dns 127.0.0.1 \
    --name dns-proxy \
    --restart always \
    --env "DNSMASQ_ADDRESSES=/.mydomain.com/192.168.1.100,/.otherdomain.com/192.168.1.200" \
    dns-proxy
```
