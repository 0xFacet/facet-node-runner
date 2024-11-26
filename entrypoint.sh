#!/bin/bash
set -eo pipefail

# Configuration
COMPOSE_URL="https://raw.githubusercontent.com/0xFacet/facet-node/v1.0.0/docker-compose/docker-compose.yml"
COMPOSE_FILE="docker-compose.yml"

# Pull latest docker-compose.yml from node repo
echo "Fetching docker-compose.yml..."
if ! curl -L -f -S "${COMPOSE_URL}" -o "${COMPOSE_FILE}"; then
    echo "Error: Failed to download docker-compose.yml"
    exit 1
fi

# Display the downloaded file for debugging
echo "Downloaded docker-compose.yml contents:"
cat "${COMPOSE_FILE}"

# Start the services
echo "Starting services..."
exec docker-compose up
