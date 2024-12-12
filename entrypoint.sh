#!/bin/bash
set -eo pipefail

# Configuration
DEFAULT_COMPOSE_URL="https://raw.githubusercontent.com/0xFacet/facet-node/main/docker-compose/docker-compose.yml"
COMPOSE_URL="${COMPOSE_URL:-$DEFAULT_COMPOSE_URL}"
COMPOSE_FILE="docker-compose.yml"

if [ -n "$COMPOSE_VERSION" ]; then
    echo "Using user-specified version: ${COMPOSE_VERSION}"
    COMPOSE_URL="https://raw.githubusercontent.com/0xFacet/facet-node/${COMPOSE_VERSION}/docker-compose/docker-compose.yml"
fi

echo "Using compose file from: ${COMPOSE_URL}"

# Pull docker-compose.yml from repo
echo "Fetching docker-compose.yml..."
if ! curl -L -f -S "${COMPOSE_URL}" -o "${COMPOSE_FILE}"; then
    echo "Error: Failed to download docker-compose.yml from ${COMPOSE_URL}"
    exit 1
fi

# Display the downloaded file for debugging
echo "Downloaded docker-compose.yml contents:"
cat "${COMPOSE_FILE}"

# Start the services
echo "Starting services..."
exec docker-compose up
