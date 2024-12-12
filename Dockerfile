FROM docker/compose:alpine-1.29.2

# Install dependencies in a single layer and clean up cache
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=20 \
    CMD curl -f http://localhost:8545 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
