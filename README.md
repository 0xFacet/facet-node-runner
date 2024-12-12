# Facet Node Runner

A Docker container that runs a Facet node and Geth instance using `docker-compose`. It automatically fetches the latest compose configuration and manages the services.

## Build the Image

```bash
docker build -t facet-node-runner .
```

## Run with environment variables

```bash
docker run -it \
    --env-file .env \
    -v /var/run/docker.sock:/var/run/docker.sock \
    facet-node-runner
```

# Required Variables
```
JWT_SECRET=0x081a0b7a3a0cf1dee15ba5d851d4330e1549af20e56eec7bce5f1ad0cc4332ae  # Or generate with: openssl rand -hex 32. The authenticated API port isn't exposed externally as an added layer of security.
GENESIS_FILE=facet-sepolia.json                    # Genesis file name
L1_NETWORK=sepolia                                 # Network name (sepolia/mainnet)
L1_RPC_URL=https://l1_rpc   # L1 RPC endpoint
L1_GENESIS_BLOCK=7109800                          # Genesis block number
```