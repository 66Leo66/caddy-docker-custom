FROM caddy:2.11.1-builder-alpine AS builder
# FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2


# FROM caddy:alpine
FROM caddy:2.11.1-alpine

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY root-ca.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
