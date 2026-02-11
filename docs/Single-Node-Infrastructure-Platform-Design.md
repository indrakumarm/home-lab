# Single Node Infrastructure Platform (SNIP) - High Level Design

## Version

v1.0

## Objective

Design a production-oriented, extensible, single-node infrastructure
platform capable of:

-   Hosting multiple client workloads
-   Providing automated VM provisioning
-   Enabling automated client onboarding
-   Supporting monitoring, alerting, and backup
-   Remaining scalable in architecture (even if hardware scales later)

------------------------------------------------------------------------

# 1. High-Level Architecture

## External Layer

Internet\
↓\
Static Public IP\
↓\
Host (Control Plane)

------------------------------------------------------------------------

## Logical Architecture

                       Internet
                           │
                    Static Public IP
                           │
                     ┌────────────┐
                     │   HOST     │  ← Control Plane
                     │ Ubuntu 24  │
                     └────────────┘
                           │
            ┌──────────────┼────────────────┐
            │              │                │
      Reverse Proxy   Monitoring Stack   Backup Engine
         (Nginx)       (Prometheus)        (Snapshots)
            │
       Internal Bridge (192.168.100.0/24)
            │
     ┌──────────────┬──────────────┬──────────────┐
     │ Client VM 1  │ Client VM 2  │ Client VM N  │
     │ (Docker)     │ (Docker)     │ (Docker)     │
     └──────────────┴──────────────┴──────────────┘

------------------------------------------------------------------------

# 2. Architectural Separation

## Control Plane (Host)

The host is responsible only for infrastructure control.

### Responsibilities

-   VM lifecycle management (create, delete, snapshot, resize)
-   Reverse proxy & SSL termination
-   Monitoring and alerting
-   Backup orchestration
-   Infrastructure-level access control

### Security Model

-   SSH key-only access
-   No password login
-   UFW default deny incoming
-   Only ports exposed: 22, 80, 443
-   Fail2ban enabled

------------------------------------------------------------------------

## Workload Plane (Client VMs)

Each client runs inside an isolated VM.

### VM Responsibilities

-   Base OS
-   Docker runtime
-   Application containers
-   Client-level SSH access (if required)

### Isolation Rules

-   No inter-VM communication unless explicitly required
-   Clients never access host directly
-   Reverse proxy is the only public entry point

------------------------------------------------------------------------

# 3. Network Design

## Network Topology

-   Host public interface: eth0 (Static Public IP)
-   Internal bridge network: 192.168.100.0/24
-   Host internal IP: 192.168.100.1
-   Client VMs: 192.168.100.x

## Traffic Flow

client1.com\
→ Public IP\
→ Host Nginx Reverse Proxy\
→ 192.168.100.10:AppPort

Only host is internet-facing.

------------------------------------------------------------------------

# 4. Client Onboarding Workflow

Automated onboarding process:

## Target Command

    ./create-client.sh client1 2CPU 4GB 50GB domain.com

------------------------------------------------------------------------

## Workflow Steps

### Phase 1 -- VM Creation

-   Terraform provisions VM via libvirt
-   Disk allocated
-   Cloud-init applied
-   Internal IP assigned
-   SSH key injected

Output: VM created with internal IP

------------------------------------------------------------------------

### Phase 2 -- Base Provisioning

Ansible runs:

-   Install Docker
-   Install node exporter
-   Configure SSH
-   Configure firewall
-   Install fail2ban
-   Apply base security

------------------------------------------------------------------------

### Phase 3 -- Application Deployment

-   Pull application repository
-   Configure environment variables
-   Deploy docker-compose stack
-   Perform health checks

------------------------------------------------------------------------

### Phase 4 -- Reverse Proxy Configuration

On host:

-   Generate Nginx configuration
-   Obtain Let's Encrypt SSL certificate
-   Enable HTTPS
-   Reload Nginx

------------------------------------------------------------------------

### Phase 5 -- Monitoring Registration

-   Add VM to Prometheus targets
-   Apply alert rules

------------------------------------------------------------------------

### Phase 6 -- Backup Registration

-   Add VM to nightly snapshot routine
-   Include in external backup schedule

------------------------------------------------------------------------

# 5. Folder Structure (Proposed)

    infra/
    ├── bootstrap/          # Host bootstrap scripts
    ├── terraform/          # VM lifecycle management
    │   ├── main.tf
    │   ├── modules/
    │   └── cloud-init/
    ├── ansible/            # VM configuration
    │   ├── inventory/
    │   ├── playbooks/
    │   └── roles/
    ├── reverse-proxy/      # Nginx templates and automation
    ├── monitoring/         # Prometheus, alerts
    ├── backup/             # Snapshot & restore logic
    └── scripts/            # Client lifecycle scripts

------------------------------------------------------------------------

# 6. Implementation Phases

## Phase 1 -- Infrastructure Foundation

-   Harden host
-   Install KVM
-   Configure networking
-   Setup reverse proxy
-   Enable firewall and security controls

## Phase 2 -- VM Automation

-   Create golden VM template
-   Implement Terraform libvirt provider
-   Cloud-init integration

## Phase 3 -- Configuration Automation

-   Build Ansible base roles
-   Docker role
-   Monitoring agent role
-   App deployment role

## Phase 4 -- Observability & Backup

-   Prometheus + Grafana
-   Alertmanager
-   Snapshot automation
-   External backup

## Phase 5 -- Client Management Layer

-   Client registry configuration
-   Automated onboarding CLI
-   Scaling workflow
-   Resource quota enforcement

------------------------------------------------------------------------

# 7. Future Scalability

Although single-node initially:

Architecture allows future migration to:

-   Multi-node cluster
-   Dedicated monitoring host
-   Proxmox or Kubernetes environment
-   Cloud-based infrastructure

Control plane and workload plane separation remains unchanged.

------------------------------------------------------------------------

# 8. Known Limitations

-   No high availability
-   Hardware failure results in downtime
-   Not suitable for enterprise-grade SLA without redundancy

------------------------------------------------------------------------

# Conclusion

This design provides:

-   Clean separation of responsibilities
-   Automated client onboarding
-   Infrastructure reproducibility
-   Security-focused architecture
-   Extensible growth path

It establishes a production-oriented foundation while remaining
manageable on a single node.
