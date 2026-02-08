# System Setup Scripts

Modular setup scripts for Ubuntu systems.

## Structure

```
system-setup/
├── setup.sh              # Main script
├── modules/              # Individual setup modules
│   ├── ssh.sh
│   ├── docker.sh
│   ├── tools.sh
│   └── security.sh
└── configs/              # Configuration files
    └── sshd_config       # (optional) custom SSH config
```

## Usage

### Install all modules
```bash
sudo ./setup.sh all
```

### Install specific modules
```bash
sudo ./setup.sh ssh docker
```

### Interactive mode
```bash
sudo ./setup.sh
# Then select modules when prompted
```

## Available Modules

- **ssh**: Install and configure OpenSSH server
- **docker**: Install Docker and Docker Compose
- **tools**: Install common development tools (git, vim, htop, etc.)
- **security**: Basic security hardening (firewall, fail2ban, auto-updates)

## Adding New Modules

1. Create a new file in `modules/` directory (e.g., `modules/nginx.sh`)
2. Add setup function:
   ```bash
   #!/bin/bash
   
   setup_nginx() {
       log_info "Installing Nginx..."
       apt install -y nginx
       systemctl enable nginx
       log_info "Nginx installed!"
   }
   
   setup_nginx
   ```
3. Register the module in `setup.sh`:
   ```bash
   declare -A MODULES=(
       # ... existing modules ...
       [nginx]="Nginx Web Server"
   )
   ```

## Custom Configurations

Place custom config files in the `configs/` directory. They'll be automatically applied if they exist.

Example: `configs/sshd_config` for custom SSH configuration.

## Make Scripts Executable

```bash
chmod +x setup.sh
chmod +x modules/*.sh
```
