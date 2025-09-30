# Dockyard Development Container

This directory contains the VS Code devcontainer configuration for the Dockyard project.

## What is a Dev Container?

A development container (devcontainer) is a fully-featured development environment running inside a Docker container. It provides a consistent, reproducible development environment for all contributors.

## Features

This devcontainer includes:

- **Base Image**: Ubuntu 22.04 LTS
- **Docker-in-Docker**: Build and test Docker images inside the container
- **Git**: Version control with the latest Git
- **Zsh + Oh My Zsh**: Enhanced shell experience
- **VS Code Extensions**:
  - Docker extension for managing containers and images
  - Hadolint for Dockerfile linting
  - ShellCheck for bash script validation
  - Shell formatting tools
  - YAML support
  - Markdown linting

## Getting Started

### Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code

### Opening the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/TheDevStallion96/dockyard.git
   cd dockyard
   ```

2. Open in VS Code:
   ```bash
   code .
   ```

3. When prompted, click **"Reopen in Container"**, or:
   - Press `F1` or `Ctrl+Shift+P` (Windows/Linux) / `Cmd+Shift+P` (Mac)
   - Type "Dev Containers: Reopen in Container"
   - Press Enter

4. Wait for the container to build (first time may take a few minutes)

5. Once ready, you'll have a fully configured development environment! 🚀

## Building Docker Images

Inside the devcontainer, you can build and test Docker images:

```bash
# Build the ubuntu-base image
cd ubuntu-base
docker build -t dockyard/ubuntu-base:latest .

# Run tests
./tests/test.sh dockyard/ubuntu-base:latest

# Run the container
docker run -it --rm dockyard/ubuntu-base:latest
```

## Customization

You can customize the devcontainer by editing `.devcontainer/devcontainer.json`:

- Add more VS Code extensions
- Install additional packages
- Configure environment variables
- Adjust settings

After making changes, rebuild the container:
- Press `F1` / `Ctrl+Shift+P` / `Cmd+Shift+P`
- Type "Dev Containers: Rebuild Container"
- Press Enter

## Troubleshooting

### Container won't start

1. Ensure Docker is running on your host machine
2. Check Docker daemon is accessible
3. Try rebuilding: "Dev Containers: Rebuild Container"

### Docker-in-Docker not working

1. Ensure the Docker socket is mounted correctly
2. Check Docker daemon status: `docker version`
3. Verify you have permissions to access Docker

### Extensions not loading

1. Rebuild the container
2. Check your internet connection (extensions are downloaded on first build)
3. Manually install extensions if needed

## Benefits for Dockyard Development

- **Consistency**: Everyone uses the same development environment
- **No local setup**: No need to install Docker tools locally
- **Isolation**: Keep your host system clean
- **Quick onboarding**: New contributors can start immediately
- **Docker-in-Docker**: Build and test images without conflicts

## Learn More

- [VS Code Dev Containers Documentation](https://code.visualstudio.com/docs/devcontainers/containers)
- [Dev Container Specification](https://containers.dev/)
- [Docker-in-Docker Feature](https://github.com/devcontainers/features/tree/main/src/docker-in-docker)

---

Happy sailing! ⚓🐳
