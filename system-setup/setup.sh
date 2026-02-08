#!/bin/bash

# Main System Setup Script
# Usage: sudo ./setup.sh [module1] [module2] ...
# Example: sudo ./setup.sh ssh docker
# If no modules specified, runs all

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"
CONFIGS_DIR="$SCRIPT_DIR/configs"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_module() { echo -e "${BLUE}[MODULE]${NC} $1"; }

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root (use sudo)"
    exit 1
fi

# Available modules
declare -A MODULES=(
    [ssh]="SSH Server"
    [docker]="Docker & Docker Compose"
    [tools]="Development Tools"
    [security]="Security Hardening"
)

# Show available modules
show_modules() {
    log_info "Available modules:"
    for key in "${!MODULES[@]}"; do
        echo "  - $key: ${MODULES[$key]}"
    done
}

# Run a specific module
run_module() {
    local module=$1
    local module_file="$MODULES_DIR/${module}.sh"
    
    if [ -f "$module_file" ]; then
        log_module "Running module: ${MODULES[$module]}"
        source "$module_file"
    else
        log_error "Module not found: $module"
        return 1
    fi
}

# Main
main() {
    log_info "System Setup Starting..."
    echo ""
    
    # If no arguments, show available modules and prompt
    if [ $# -eq 0 ]; then
        show_modules
        echo ""
        read -p "Enter modules to install (space-separated, or 'all'): " -a selected_modules
        
        if [ "${selected_modules[0]}" == "all" ]; then
            selected_modules=("${!MODULES[@]}")
        fi
    else
        selected_modules=("$@")
    fi
    
    # Run selected modules
    for module in "${selected_modules[@]}"; do
        if [ -n "${MODULES[$module]}" ]; then
            run_module "$module"
        else
            log_error "Unknown module: $module"
        fi
    done
    
    log_info "Setup complete!"
}

main "$@"
