FROM zhade/zrenderer:latest

WORKDIR /zren

# Copy configuration files
COPY ./zren/zrenderer.conf /zren/zrenderer.conf
COPY ./zext/filters.txt /zren/filters.txt

# Copy startup script
COPY ./start.sh /zren/start.sh
RUN chmod +x /zren/start.sh

# Install curl for downloading GRF files
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /zren/container/output /zren/container/data-resources /zren/grf-source

# Set proper permissions
RUN chown -R zren:zren /zren

# Expose the service port
EXPOSE 11011

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
  CMD curl -f http://localhost:11011/health || exit 1

# Start the zrenderer server with setup script
CMD ["/zren/start.sh"] 