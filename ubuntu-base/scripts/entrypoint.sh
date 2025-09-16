#!/bin/bash
#
# Ubuntu Base Image Entrypoint Script
# 
# This script handles container initialization and provides a flexible
# entrypoint for various use cases in the ubuntu-base image.
#
# Author: Tristan Elliott
# Version: 1.0.0

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" >&2
}

# Print container information
print_container_info() {
    log_info "🐳 Ubuntu Base Container Starting..."
    log_info "User: $(whoami) (UID: $(id -u), GID: $(id -g))"
    log_info "Working Directory: $(pwd)"
    log_info "Hostname: $(hostname)"
    log_info "Ubuntu Version: $(lsb_release -ds 2>/dev/null || echo 'Unknown')"
    log_info "Container ID: ${HOSTNAME}"
    echo
}

# Check if running as root and warn
check_user() {
    if [[ $(id -u) -eq 0 ]]; then
        log_warn "⚠️  Running as root user. Consider using 'appuser' for security."
    else
        log_success "✅ Running as non-root user: $(whoami)"
    fi
}

# Validate environment
validate_environment() {
    # Check if /app directory exists and is writable
    if [[ ! -d "/app" ]]; then
        log_error "❌ /app directory does not exist"
        exit 1
    fi
    
    if [[ ! -w "/app" ]]; then
        log_warn "⚠️  /app directory is not writable"
    else
        log_success "✅ /app directory is accessible"
    fi
}

# Handle initialization tasks
initialize_container() {
    log_info "🔧 Initializing container..."
    
    # Create common directories if they don't exist
    mkdir -p /app/{logs,data,tmp} 2>/dev/null || true
    
    # Set proper timezone if specified
    if [[ -n "${TZ:-}" ]] && [[ -f "/usr/share/zoneinfo/${TZ}" ]]; then
        log_info "🕐 Setting timezone to: ${TZ}"
        if [[ $(id -u) -eq 0 ]]; then
            ln -sf "/usr/share/zoneinfo/${TZ}" /etc/localtime
            echo "${TZ}" > /etc/timezone
        else
            log_warn "⚠️  Cannot set system timezone as non-root user"
        fi
    fi
    
    log_success "✅ Container initialized successfully"
}

# Handle different execution modes
main() {
    # Print startup information
    print_container_info
    
    # Validate environment
    check_user
    validate_environment
    
    # Initialize container
    initialize_container
    
    # If no arguments provided, start interactive bash
    if [[ $# -eq 0 ]]; then
        log_info "🚀 Starting interactive bash session..."
        exec /bin/bash
    fi
    
    # If first argument is a flag/option, treat as bash command
    if [[ "${1#-}" != "$1" ]]; then
        log_info "🚀 Executing bash with arguments: $*"
        exec /bin/bash "$@"
    fi
    
    # Check if first argument is a command that exists
    if command -v "$1" >/dev/null 2>&1; then
        log_info "🚀 Executing command: $*"
        exec "$@"
    fi
    
    # If it's a script file in /app, execute it
    if [[ -f "/app/$1" ]]; then
        log_info "🚀 Executing script: /app/$1"
        shift
        exec "/app/$1" "$@"
    fi
    
    # If it's a shell script, execute with bash
    if [[ "$1" == *.sh ]] && [[ -f "$1" ]]; then
        log_info "🚀 Executing shell script: $1"
        exec /bin/bash "$@"
    fi
    
    # Default: treat as bash command
    log_info "🚀 Executing as bash command: $*"
    exec /bin/bash -c "$*"
}

# Trap signals for graceful shutdown
trap 'log_info "🛑 Received shutdown signal, exiting gracefully..."; exit 0' SIGTERM SIGINT

# Run main function with all arguments
main "$@"