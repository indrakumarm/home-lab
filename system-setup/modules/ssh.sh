#!/bin/bash

# SSH Server Setup Module

setup_ssh() {
    log_info "Installing OpenSSH Server..."
    
    apt update
    apt install -y openssh-server
    
    log_info "Enabling SSH service..."
    systemctl enable ssh
    systemctl start ssh
    
    # Backup original config
    if [ ! -f /etc/ssh/sshd_config.backup ]; then
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
        log_info "Created backup: /etc/ssh/sshd_config.backup"
    fi
    
    # Apply custom config if exists
    if [ -f "$CONFIGS_DIR/sshd_config" ]; then
        log_info "Applying custom SSH configuration..."
        cp "$CONFIGS_DIR/sshd_config" /etc/ssh/sshd_config
        systemctl restart ssh
    fi
    
    # Configure firewall
    if command -v ufw &> /dev/null; then
        log_info "Configuring firewall..."
        ufw allow ssh
    fi
    
    # Display server IP
    log_info "SSH Server is running!"
    echo -e "  IP Address: $(hostname -I | awk '{print $1}')"
    echo -e "  Connect with: ssh $(whoami)@$(hostname -I | awk '{print $1}')"
}

# Run the setup
setup_ssh
