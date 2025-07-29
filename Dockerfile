FROM zhade/zrenderer:latest

WORKDIR /zren

# Copy configuration files
COPY ./zren/zrenderer.conf /zren/zrenderer.conf
COPY ./zext/filters.txt /zren/filters.txt

# Create necessary directories
RUN mkdir -p /zren/container/output /zren/container/data-resources

# Set proper permissions
RUN chown -R zren:zren /zren

# Expose the service port
EXPOSE 11011

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:11011/health || exit 1

# Start the zrenderer server
CMD ["./zrenderer-server"] 