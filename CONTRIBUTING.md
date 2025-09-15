# Contributing to Dockyard

Welcome to **Dockyard** ⚓! Thank you for your interest in contributing to this Docker image repository. This document outlines the guidelines and standards for contributing new Docker images and maintaining existing ones.

## Getting Started

1. Fork the repository
2. Create a feature branch for your Docker image
3. Follow the directory structure guidelines below
4. Submit a pull request

## Directory Structure

Each Docker image should follow this standard structure:

```
image-name/
├── Dockerfile              # Main Docker image definition
├── config/                 # Configuration files
│   └── [config-files]     # Any configuration files needed
├── docs/                  # Documentation
│   └── README.md          # Image-specific documentation
├── scripts/               # Scripts and utilities
│   └── entrypoint.sh      # Container entrypoint script
└── tests/                 # Testing
    └── test.sh            # Test script for the image
```

## Docker Image Guidelines

### Dockerfile Standards
- Use official base images when possible
- Include proper labels (maintainer, version, description)
- Minimize layers by combining RUN commands
- Use specific version tags rather than `latest`
- Clean up package caches and temporary files

### Documentation Requirements
- Each image must have a `docs/README.md` file
- Include usage examples and configuration options
- Document any exposed ports, volumes, and environment variables
- Provide build and run instructions

### Testing Requirements
- Include a `tests/test.sh` script that validates the image
- Test basic functionality and expected behavior
- Ensure tests can run in CI/CD environments

### Security Considerations
- Use non-root users when possible
- Keep base images and packages up to date
- Scan images for vulnerabilities
- Follow Docker security best practices

## Commit Message Format

Use descriptive commit messages following this format:

```
[component]: Brief description

Detailed description of changes if needed
- List specific changes
- Include any breaking changes
- Reference issues if applicable
```

Examples:
- `ubuntu-base: Add initial Ubuntu base image with security updates`
- `nginx-proxy: Update to nginx 1.21 with SSL configuration`

## Pull Request Process

1. Ensure your image follows the directory structure
2. Include comprehensive documentation
3. Add or update tests as needed
4. Verify the image builds successfully
5. Test the image functionality
6. Update any relevant documentation

## Code of Conduct

- Be respectful and constructive in discussions
- Focus on technical merits of contributions
- Help maintain a welcoming environment for all contributors

## Questions or Issues?

Feel free to open an issue if you have questions about contributing or need help with your Docker image implementation.

Happy sailing! 🏴‍☠️