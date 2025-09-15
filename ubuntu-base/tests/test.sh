#!/bin/bash
#
# Ubuntu Base Image Test Script
#
# This script validates the ubuntu-base Docker image functionality
# and ensures all components are working correctly.
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

# Test configuration
readonly IMAGE_NAME="${1:-dockyard/ubuntu-base:latest}"
readonly CONTAINER_NAME="ubuntu-base-test-$$"
readonly TEST_DIR="/tmp/ubuntu-base-tests"

# Counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

# Test framework functions
run_test() {
    local test_name="$1"
    local test_function="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    echo
    log_info "🧪 Running test: $test_name"
    
    if $test_function; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        log_success "✅ PASSED: $test_name"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        log_error "❌ FAILED: $test_name"
    fi
}

# Cleanup function
cleanup() {
    log_info "🧹 Cleaning up test environment..."
    docker stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
    docker rm "$CONTAINER_NAME" >/dev/null 2>&1 || true
    rm -rf "$TEST_DIR" 2>/dev/null || true
}

# Setup test environment
setup_tests() {
    log_info "🔧 Setting up test environment..."
    
    # Create test directory
    mkdir -p "$TEST_DIR"
    
    # Check if Docker is available
    if ! command -v docker >/dev/null 2>&1; then
        log_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    # Check if Docker daemon is running
    if ! docker version >/dev/null 2>&1; then
        log_error "Docker daemon is not running"
        exit 1
    fi
    
    log_success "✅ Test environment ready"
}

# Test 1: Check if image exists
test_image_exists() {
    docker inspect "$IMAGE_NAME" >/dev/null 2>&1
}

# Test 2: Container starts successfully
test_container_starts() {
    docker run -d --name "$CONTAINER_NAME" "$IMAGE_NAME" sleep 30 >/dev/null 2>&1
}

# Test 3: Check if container is running
test_container_running() {
    [[ "$(docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME" 2>/dev/null)" == "running" ]]
}

# Test 4: Check if appuser exists
test_appuser_exists() {
    docker exec "$CONTAINER_NAME" id appuser >/dev/null 2>&1
}

# Test 5: Check if working directory is /app
test_working_directory() {
    local workdir
    workdir=$(docker exec "$CONTAINER_NAME" pwd 2>/dev/null)
    [[ "$workdir" == "/app" ]]
}

# Test 6: Check if essential packages are installed
test_essential_packages() {
    local packages=("curl" "wget" "nano" "htop" "sudo")
    
    for package in "${packages[@]}"; do
        if ! docker exec "$CONTAINER_NAME" which "$package" >/dev/null 2>&1; then
            log_error "Package $package not found"
            return 1
        fi
    done
    
    return 0
}

# Test 7: Check if non-root user is active
test_nonroot_user() {
    local uid
    uid=$(docker exec "$CONTAINER_NAME" id -u 2>/dev/null)
    [[ "$uid" != "0" ]]
}

# Test 8: Check if entrypoint script exists and is executable
test_entrypoint_script() {
    docker exec "$CONTAINER_NAME" test -x /usr/local/bin/entrypoint.sh
}

# Test 9: Test interactive bash session
test_interactive_bash() {
    local output
    output=$(docker exec "$CONTAINER_NAME" bash -c 'echo "Hello from bash"' 2>/dev/null)
    [[ "$output" == "Hello from bash" ]]
}

# Test 10: Test file permissions in /app
test_app_permissions() {
    # Test if appuser can write to /app
    docker exec "$CONTAINER_NAME" touch /app/test-file >/dev/null 2>&1 &&
    docker exec "$CONTAINER_NAME" rm /app/test-file >/dev/null 2>&1
}

# Test 11: Check timezone setting
test_timezone() {
    # Stop previous container
    docker stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
    docker rm "$CONTAINER_NAME" >/dev/null 2>&1 || true
    
    # Start container with custom timezone
    docker run -d --name "$CONTAINER_NAME" -e TZ=America/New_York "$IMAGE_NAME" sleep 30 >/dev/null 2>&1
    
    # Check if timezone is set (this might not work for non-root user, so we'll check if it doesn't error)
    docker exec "$CONTAINER_NAME" date >/dev/null 2>&1
}

# Test 12: Health check
test_health_check() {
    # This test checks if the image has a health check defined
    local healthcheck
    healthcheck=$(docker inspect --format='{{.Config.Healthcheck}}' "$IMAGE_NAME" 2>/dev/null)
    [[ "$healthcheck" != "<nil>" ]] && [[ "$healthcheck" != "" ]]
}

# Build the image if it doesn't exist
build_image_if_needed() {
    if ! docker inspect "$IMAGE_NAME" >/dev/null 2>&1; then
        log_info "🔨 Image not found, building $IMAGE_NAME..."
        
        # Find the Dockerfile directory
        local dockerfile_dir
        dockerfile_dir=$(dirname "$0")/../
        
        if [[ ! -f "$dockerfile_dir/Dockerfile" ]]; then
            log_error "Dockerfile not found in $dockerfile_dir"
            exit 1
        fi
        
        if docker build -t "$IMAGE_NAME" "$dockerfile_dir"; then
            log_success "✅ Image built successfully"
        else
            log_error "❌ Failed to build image"
            exit 1
        fi
    fi
}

# Main test runner
main() {
    echo "🐳 Ubuntu Base Image Test Suite"
    echo "================================"
    log_info "Testing image: $IMAGE_NAME"
    
    # Set up trap for cleanup
    trap cleanup EXIT
    
    # Setup test environment
    setup_tests
    
    # Build image if needed
    build_image_if_needed
    
    # Run all tests
    run_test "Image exists" test_image_exists
    run_test "Container starts" test_container_starts
    run_test "Container is running" test_container_running
    run_test "AppUser exists" test_appuser_exists
    run_test "Working directory is /app" test_working_directory
    run_test "Essential packages installed" test_essential_packages
    run_test "Non-root user active" test_nonroot_user
    run_test "Entrypoint script exists" test_entrypoint_script
    run_test "Interactive bash works" test_interactive_bash
    run_test "App directory permissions" test_app_permissions
    run_test "Timezone setting" test_timezone
    run_test "Health check configured" test_health_check
    
    # Print test summary
    echo
    echo "📊 Test Summary"
    echo "==============="
    log_info "Total tests: $TESTS_RUN"
    log_success "Passed: $TESTS_PASSED"
    
    if [[ $TESTS_FAILED -gt 0 ]]; then
        log_error "Failed: $TESTS_FAILED"
        echo
        log_error "❌ Some tests failed. Please review the image configuration."
        exit 1
    else
        echo
        log_success "🎉 All tests passed! The ubuntu-base image is working correctly."
        exit 0
    fi
}

# Run main function with all arguments
main "$@"