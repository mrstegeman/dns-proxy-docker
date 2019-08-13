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

## Architecture

Pretty simple.

1. [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) handles all requests.
2. If the request doesn't match any of the configured `address` directives and the response is not already cached, the requested is forwarded to Stubby.
3. [Stubby](https://dnsprivacy.org/wiki/x/JYAT) forwards the request to one of the configured upstream DNS-over-TLS providers.

```
┏━━━━━━━━┓   query   ┏━━━━━━━━━┓   forward   ┏━━━━━━━━┓   forward   ┏━━━━━━━━━━┓
┃ client ┃<━━━━━━━━━>┃ dnsmasq ┃<━━━━━━━━━━━>┃ stubby ┃<━━━━━━━━━━━>┃ upstream ┃
┗━━━━━━━━┛   (DNS)   ┗━━━━━━━━━┛   (local)   ┗━━━━━━━━┛    (DoT)    ┗━━━━━━━━━━┛
```
