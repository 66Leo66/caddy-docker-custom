ARG CADDY_VERSION=2.9.1

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder
# FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/greenpau/caddy-security@latest \
    --with github.com/greenpau/caddy-security-secrets-aws-secrets-manager@latest \
    --with github.com/greenpau/caddy-trace@latest 


# FROM caddy:alpine
FROM caddy:${CADDY_VERSION}-alpine

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY root-ca.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
