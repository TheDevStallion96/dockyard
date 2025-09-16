# Ubuntu Base Docker Image

A security-hardened, minimal Ubuntu 22.04 LTS base image designed for containerized applications in home lab environments.

## Features

- **Base**: Ubuntu 22.04 LTS (Jammy Jellyfish)
- **Security**: Regular security updates and non-root user setup
- **Minimal**: Only essential packages included to reduce attack surface
- **Utilities**: Common tools for debugging and system administration
- **Configurable**: Custom package sources and entrypoint script

## Included Packages

- `ca-certificates` - SSL/TLS certificates
- `curl` & `wget` - HTTP clients
- `gnupg` - GPG encryption tools
- `nano` & `vim-tiny` - Text editors
- `htop` & `procps` - System monitoring
- `net-tools` - Network utilities
- `sudo` - Privilege escalation

## Quick Start

### Building the Image

```bash
cd ubuntu-base/
docker build -t dockyard/ubuntu-base:latest .
```

### Running the Container

```bash
# Interactive bash session
docker run -it --rm dockyard/ubuntu-base:latest

# Run as daemon with custom command
docker run -d --name my-ubuntu dockyard/ubuntu-base:latest sleep infinity

# Execute commands in running container
docker exec -it my-ubuntu bash
```

## Configuration

### Environment Variables

- `DEBIAN_FRONTEND=noninteractive` - Prevents interactive prompts during package installation
- `LANG=C.UTF-8` - Sets UTF-8 locale
- `TZ=UTC` - Sets timezone to UTC

### Users and Security

- **Non-root user**: `appuser` (UID varies)
- **Working directory**: `/app`
- **Sudo access**: Enabled for `appuser` (can be disabled by modifying Dockerfile)

### Custom Configuration

#### Package Sources
The image uses a custom `sources.list` file located at `config/sources.list`. This ensures:
- Security updates are prioritized
- Official Ubuntu repositories are used
- Backports are available but stable packages are preferred

#### Entrypoint Script
The `scripts/entrypoint.sh` script handles container initialization and can be customized for specific use cases.

## Usage Examples

### As a Base for Other Images

```dockerfile
FROM dockyard/ubuntu-base:latest

# Install additional packages
USER root
RUN apt-get update && apt-get install -y python3 python3-pip
USER appuser

# Copy application files
COPY --chown=appuser:appuser . /app/

# Set custom entrypoint
CMD ["python3", "app.py"]
```

### Development Environment

```bash
# Mount local directory for development
docker run -it --rm \
  -v $(pwd):/app/workspace \
  dockyard/ubuntu-base:latest \
  bash
```

### Long-running Service

```bash
# Run container with custom entrypoint
docker run -d \
  --name ubuntu-service \
  --restart unless-stopped \
  dockyard/ubuntu-base:latest \
  /app/my-service.sh
```

## Health Check

The image includes a basic health check that runs every 30 seconds:
```bash
docker inspect --format='{{.State.Health.Status}}' container-name
```

## Security Considerations

- Container runs as non-root user `appuser`
- Minimal package installation reduces attack surface
- Regular security updates through official Ubuntu repositories
- No unnecessary services or daemons running

## Customization

### Removing Sudo Access
To remove sudo access for enhanced security, comment out this line in the Dockerfile:
```dockerfile
# RUN echo 'appuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
```

### Adding Custom Packages
Add packages to the `apt-get install` command in the Dockerfile:
```dockerfile
RUN apt-get install -y --no-install-recommends \
    your-package \
    another-package
```

## Troubleshooting

### Container Won't Start
- Check the entrypoint script has execute permissions
- Verify all COPY commands reference existing files
- Check Docker logs: `docker logs container-name`

### Package Installation Issues
- Verify the sources.list file is correct
- Run `apt-get update` before installing packages
- Check for typos in package names

### Permission Issues
- Ensure files are owned by `appuser` when copying to `/app/`
- Use `USER root` temporarily if root access is needed during build

## Contributing

See the main repository [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines on contributing to this Docker image.

## License

This Docker image configuration is released under the MIT License. See [LICENSE](../../LICENSE) for details.