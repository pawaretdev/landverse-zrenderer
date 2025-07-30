# ZRenderer

A Docker-based service for rendering Ragnarok Online sprites using [zextractor](https://github.com/zhad3/zextractor) and [zrenderer](https://github.com/zhad3/zrenderer).

## Overview

This project combines zextractor (for extracting game resources) and zrenderer (for sprite rendering) in a containerized environment, supporting both local development and production deployments.

## Quick Start

### Prerequisites

- Docker and Docker Compose
- GRF files (data.grf and roverse.grf)

### Environment Setup

Create a `.env` file:

```env
DATA_GRF_URL=https://your-server.com/data.grf
ROVERSE_GRF_URL=https://your-server.com/roverse.grf
```

### Running

**Local Development:**

```bash
docker-compose -f docker-compose.dev.yml up --build
```

**Production:**

```bash
docker-compose up --build
```

The service will be available at `http://localhost:11011`

## Configuration

### Docker Compose Files

- `docker-compose.yml` - Production configuration
- `docker-compose.dev.yml` - Development configuration (includes platform specification for Apple Silicon)

### Volume Mounts

- `./zren/output:/zren/output` - Rendered sprite output
- `./zren:/zren/container` - Container data (production only)

## API Usage

Once running, you can render sprites via HTTP requests:

```bash
# Render a monster (Scorpion, ID 1001)
curl "http://localhost:11011/render?job=1001"

# Render character with equipment
curl "http://localhost:11011/render?job=1&headgear=4,125&weapon=2&gender=female&action=32"

# Render specific frame
curl "http://localhost:11011/render?job=1870&action=16&frame=10"
```

## Project Structure

```
zrenderer/
├── Dockerfile              # Multi-stage build with zextractor + zrenderer
├── docker-compose.yml      # Production configuration
├── docker-compose.dev.yml  # Development configuration
├── zext/                   # Zextractor configuration
│   ├── filters.txt         # Resource filters
│   └── zextractor.conf     # Extractor settings
└── zren/                   # Zrenderer configuration
    ├── zrenderer.conf      # Renderer settings
    └── output/             # Rendered sprite output
```

## Features

- **Multi-stage Docker build** - Extracts resources and serves them
- **Environment-based configuration** - Separate dev/prod setups
- **Volume persistence** - Output directory mounted to host
- **Platform compatibility** - Works on both AMD64 and ARM64

## Troubleshooting

### Platform Issues

If you encounter platform mismatch errors on Apple Silicon, use the dev compose file which includes `platform: linux/amd64`.

### Access Tokens

The server auto-generates access tokens on first run. Check the container logs for the token.

## References

- [ZRenderer GitHub](https://github.com/zhad3/zrenderer)
- [ZExtractor GitHub](https://github.com/zhad3/zextractor)
- [API Documentation](https://z0q.neocities.org/ragnarok-online-tools/zrenderer/api/)

## License

MIT License - see the original zrenderer project for details.
