#!/bin/bash
set -e

echo "Starting ZRenderer setup..."

# Create necessary directories
mkdir -p /zren/container/output /zren/container/data-resources /zren/grf-source

# Download GRF files if URLs are provided
if [ -n "$DATA_GRF_URL" ]; then
    echo "Downloading data.grf from $DATA_GRF_URL..."
    curl -L -o /zren/grf-source/data.grf "$DATA_GRF_URL"
fi

if [ -n "$ROVERSE_GRF_URL" ]; then
    echo "Downloading roverse.grf from $ROVERSE_GRF_URL..."
    curl -L -o /zren/grf-source/roverse.grf "$ROVERSE_GRF_URL"
fi

# Process GRF files if they exist
if [ -f "/zren/grf-source/data.grf" ] || [ -f "/zren/grf-source/roverse.grf" ]; then
    echo "Processing GRF files..."
    
    # Create a temporary directory for zextractor
    mkdir -p /tmp/zext/input
    cp /zren/filters.txt /tmp/zext/input/
    
    # Build GRF file list
    GRF_FILES=""
    if [ -f "/zren/grf-source/data.grf" ]; then
        GRF_FILES="/zren/grf-source/data.grf"
    fi
    if [ -f "/zren/grf-source/roverse.grf" ]; then
        if [ -n "$GRF_FILES" ]; then
            GRF_FILES="$GRF_FILES,/zren/grf-source/roverse.grf"
        else
            GRF_FILES="/zren/grf-source/roverse.grf"
        fi
    fi
    
    # Run zextractor if available
    if command -v zextractor &> /dev/null; then
        echo "Running zextractor with files: $GRF_FILES"
        zextractor --outdir=/zren/container/data-resources --grf="$GRF_FILES" --filtersfile=/tmp/zext/input/filters.txt --verbose
    else
        echo "Warning: zextractor not found, skipping GRF processing"
    fi
else
    echo "No GRF files found, skipping processing"
fi

# Set proper permissions
chown -R zren:zren /zren

echo "Setup complete, starting zrenderer-server..."
exec ./zrenderer-server 