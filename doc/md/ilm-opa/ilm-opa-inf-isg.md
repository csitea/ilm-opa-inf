# ilm-opa SYTEM GUIDE

## 1. Google Cloud Platform (GCP) Environment

- Compute Engine VM Instance
- Cloud DNS (commented out, but mentioned)
- Secret Manager
- Storage Bucket (for website)
- Firewall Rules

## 2. Local Environment

- Terraform Configuration
- Ansible Playbook
- SSH Key Management

## 3. External Services

- GitHub (for storing SSH key as a secret)

## 4. Main Components

### a. GCP Compute Instance
- Runs Debian 11
- Hosts WordPress

### b. Web Server
- Nginx
- Configured for PHP-FPM and WordPress

### c. Database
- MariaDB
- WordPress database and user

### d. PHP
- PHP 7.4-FPM
- Various PHP extensions for WordPress

### e. WordPress
- Latest version (6.4.3 as of the playbook)
- WP-CLI for management

### f. SSL/TLS
- Let's Encrypt via Certbot
- Configured for both staging and production

## 5. Networking

- Firewall allows HTTP (80) and HTTPS (443) traffic
- Nginx configured to redirect HTTP to HTTPS

## 6. Security

- SSH keys for instance access
- Passwords generated for database and WordPress admin
- SSL/TLS certificates for encrypted connections

## 7. DNS

- Manual DNS configuration mentioned (not managed by Terraform)
- DNS propagation check before SSL certificate issuance

## 8. Deployment Process

- Terraform creates infrastructure
- Ansible:
  - Installs and configures all software components
  - Sets up WordPress, database, and web server
  - Deploys custom themes and plugins
  - Configures SSL/TLS
  - Installs and uses WP-CLI for WordPress management

## 9. Custom Content

- WordPress themes (synced from local environment)
- WordPress plugins (synced from local environment)

## 10. Performance and Security Tuning

- Increased PHP upload limits
- Increased Nginx client max body size
- Proper file permissions and ownership

## 11.SYSTEM DIAGRAM
![System Diagram](../img/ilm-opa-system-dia-plant-uml.png)
