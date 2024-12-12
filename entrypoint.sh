#!/bin/bash
set -eo pipefail

# Function to get latest release version
get_latest_version() {
    local response
    local latest_version
    
    echo "Fetching latest version from GitHub..." >&2
    response=$(curl -s https://api.github.com/repos/0xFacet/facet-node/releases/latest)
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to connect to GitHub API" >&2
        return 1
    fi
    
    latest_version=$(echo "$response" | jq -r '.tag_name')
    
    if [ "$latest_version" = "null" ] || [ -z "$latest_version" ]; then
        echo "Error: Could not parse version from GitHub response" >&2
        return 1
    fi
    
    echo "$latest_version"
}

# Get version: from user input or GitHub
if [ -n "$COMPOSE_VERSION" ]; then
    echo "Using user-specified version: ${COMPOSE_VERSION}"
    DEFAULT_VERSION="$COMPOSE_VERSION"
else
    echo "No version specified, attempting to fetch latest..."
    DEFAULT_VERSION=$(get_latest_version)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to get latest version and no version was specified"
        echo "Please either:"
        echo "1. Ensure GitHub API is accessible"
        echo "2. Specify COMPOSE_VERSION environment variable"
        echo "3. Provide complete COMPOSE_URL"
        exit 1
    fi
    echo "Successfully fetched latest version: ${DEFAULT_VERSION}"
fi

# Set up URLs
DEFAULT_COMPOSE_URL="https://raw.githubusercontent.com/0xFacet/facet-node/${DEFAULT_VERSION}/docker-compose/docker-compose.yml"
COMPOSE_URL="${COMPOSE_URL:-$DEFAULT_COMPOSE_URL}"
COMPOSE_FILE="docker-compose.yml"

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
