#!/bin/bash

# Development Tools Setup Module

setup_tools() {
    log_info "Installing development tools..."
    
    apt update
    apt install -y \
        git \
        curl \
        wget \
        vim \
        htop \
        tree \
        tmux \
        build-essential \
        software-properties-common \
        net-tools \
        ufw
    
    log_info "Development tools installed successfully!"
}

setup_tools
