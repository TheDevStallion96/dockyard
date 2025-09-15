# Ubuntu Base Image
# 
# A minimal, security-focused Ubuntu base image for containerized applications
# Includes essential utilities and security updates
#
# Maintainer: Tristan Elliott
# Version: 1.0.0

FROM ubuntu:22.04

# Set labels for metadata
LABEL maintainer="Tristan Elliott" \
      version="1.0.0" \
      description="Security-hardened Ubuntu base image with essential utilities" \
      org.opencontainers.image.source="https://github.com/TheDevStallion96/dockyard" \
      org.opencontainers.image.title="Ubuntu Base" \
      org.opencontainers.image.description="Minimal Ubuntu base image for containerized applications"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser -s /bin/bash -d /home/appuser appuser

# Copy custom sources.list for package management
COPY config/sources.list /etc/apt/sources.list

# Update system and install essential packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        gnupg \
        lsb-release \
        tzdata \
        sudo \
        nano \
        vim-tiny \
        htop \
        procps \
        net-tools && \
    # Clean up package cache
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up sudo access for appuser (optional, remove if not needed)
RUN echo 'appuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create application directory
RUN mkdir -p /app && chown -R appuser:appuser /app

# Copy entrypoint script
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch to non-root user
USER appuser
WORKDIR /app

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD echo "Ubuntu base container is healthy"