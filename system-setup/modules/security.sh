#!/bin/bash

# Security Hardening Module

setup_security() {
    log_info "Applying security hardening..."
    
    # Enable UFW firewall
    if command -v ufw &> /dev/null; then
        log_info "Configuring UFW firewall..."
        ufw --force enable
        ufw default deny incoming
        ufw default allow outgoing
        log_info "Firewall configured (default deny incoming)"
    fi
    
    # Install fail2ban
    log_info "Installing fail2ban..."
    apt install -y fail2ban
    systemctl enable fail2ban
    systemctl start fail2ban
    
    # Configure automatic security updates
    log_info "Setting up automatic security updates..."
    apt install -y unattended-upgrades
    dpkg-reconfigure -plow unattended-upgrades
    
    log_info "Security hardening complete!"
}

setup_security
