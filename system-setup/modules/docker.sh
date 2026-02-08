#!/bin/bash

# Docker Setup Module

setup_docker() {
    log_info "Installing Docker..."
    
    # Remove old versions
    apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
    
    # Install prerequisites
    apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Add Docker's official GPG key
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Set up repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker Engine
    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Enable Docker service
    systemctl enable docker
    systemctl start docker
    
    # Add current user to docker group (if not root)
    if [ -n "$SUDO_USER" ]; then
        usermod -aG docker "$SUDO_USER"
        log_info "Added $SUDO_USER to docker group (logout/login required)"
    fi
    
    log_info "Docker installed successfully!"
    docker --version
}

setup_docker
