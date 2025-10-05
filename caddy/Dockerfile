FROM caddy:2-builder AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  xcaddy build \
  --with github.com/caddyserver/nginx-adapter \
  --with github.com/hairyhenderson/caddy-teapot-module@v0.0.3-0 \
  --with github.com/caddy-dns/cloudflare

FROM caddy:2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
