#!/bin/bash

# Nginx Setup Module

setup_nginx() {
    log_info "Installing Nginx..."
    
    apt update
    apt install -y nginx
    
    # Enable and start Nginx
    systemctl enable nginx
    systemctl start nginx
    
    # Apply custom nginx config if exists
    if [ -f "$CONFIGS_DIR/nginx.conf" ]; then
        log_info "Applying custom Nginx configuration..."
        cp "$CONFIGS_DIR/nginx.conf" /etc/nginx/nginx.conf
    fi
    
    # Apply custom site config if exists
    if [ -f "$CONFIGS_DIR/default-site.conf" ]; then
        log_info "Applying custom site configuration..."
        cp "$CONFIGS_DIR/default-site.conf" /etc/nginx/sites-available/default
        ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
    fi
    
    # Test nginx config
    nginx -t
    
    # Reload nginx to apply changes
    systemctl reload nginx
    
    # Configure firewall
    if command -v ufw &> /dev/null; then
        log_info "Configuring firewall for Nginx..."
        ufw allow 'Nginx Full'
    fi
    
    log_info "Nginx installed successfully!"
    echo -e "  Server IP: $(hostname -I | awk '{print $1}')"
    echo -e "  Access at: http://$(hostname -I | awk '{print $1}')"
}

setup_nginx
