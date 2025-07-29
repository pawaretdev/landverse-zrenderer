# ZRenderer

## Overview

ZRenderer is a service that processes and renders Ragnarok Landverse sprites

## Features

- 🚀 Auto-deployment on Railway
- 🐳 Docker containerization with runtime GRF processing
- 🔄 Health checks and monitoring
- 📊 Game resource rendering
- ⚡ Automatic GRF file download and processing

## Railway Deployment

### Prerequisites

1. A Railway account
2. GitHub repository connected to Railway
3. Environment variables configured

### Environment Variables

Configure these environment variables in your Railway project:

```bash
# Required: URLs for game resource files
DATA_GRF_URL=https://your-cdn.com/data.grf
ROVERSE_GRF_URL=https://your-cdn.com/roverse.grf

# Optional: Custom port (default: 11011)
PORT=11011
```

### Auto-Deploy Setup

1. **Connect Repository**: Link your GitHub repository to Railway
2. **Configure Environments**:
   - Production: Auto-deploys from `main` branch
   - Staging: Auto-deploys from `develop` branch
3. **Set Environment Variables**: Configure the required variables
4. **Deploy**: Railway will automatically build and deploy on code pushes

### Manual Deployment

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Link to your Railway project
railway link

# Deploy
railway up
```

## Local Development

### Using Docker Compose

```bash
# Set environment variables
export DATA_GRF_URL=https://your-cdn.com/data.grf
export ROVERSE_GRF_URL=https://your-cdn.com/roverse.grf

# Start the service
docker-compose up --build
```

### Using Docker

```bash
# Build the image
docker build -t zrenderer .

# Run the container
docker run -p 11011:11011 \
  -e DATA_GRF_URL=https://your-cdn.com/data.grf \
  -e ROVERSE_GRF_URL=https://your-cdn.com/roverse.grf \
  zrenderer
```

## How It Works

### Startup Process

1. **Container Starts**: The `start.sh` script runs automatically
2. **GRF Download**: Downloads GRF files from configured URLs
3. **Resource Processing**: Runs zextractor to process game resources
4. **Service Start**: Launches the zrenderer-server

### Configuration

#### ZRenderer Configuration (`zren/zrenderer.conf`)

```ini
outdir=container/output
resourcepath=container/data-resources
enableUniqueFilenames=true
tokenfile=container/accesstokens.conf
hosts=0.0.0.0
```

#### Filters Configuration (`zext/filters.txt`)

The filters file contains rules for processing game resources. See the file for current configuration.

## Health Check

The service includes a health check endpoint at `/health` that returns:

- **200 OK**: Service is healthy
- **503 Service Unavailable**: Service is unhealthy

**Note**: Health checks start after 120 seconds to allow for GRF processing.

## Monitoring

Railway provides built-in monitoring for:

- Application logs
- Resource usage
- Deployment status
- Health check results

## Troubleshooting

### Common Issues

1. **Build Failures**:

   - Check that all environment variables are set
   - Verify GRF URLs are accessible
   - Check build logs for specific errors

2. **Service Unavailable**:

   - Verify the health check endpoint
   - Check if port 11011 is available
   - Review application logs for GRF processing errors

3. **GRF Processing Failures**:

   - Verify GRF URLs are valid and accessible
   - Check if zextractor is available in the container
   - Review startup logs for download/processing errors

4. **Slow Startup**:
   - GRF file downloads may take time depending on file size
   - Processing large GRF files can take several minutes
   - Health checks are delayed to account for processing time

### Logs

View logs in Railway dashboard or using CLI:

```bash
railway logs
```

### Debug Commands

```bash
# Check service status
railway status

# View logs
railway logs

# Connect to running container
railway shell

# Check environment variables
railway variables
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
