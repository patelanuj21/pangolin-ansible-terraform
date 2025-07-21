# Ansible Pangolin Deployment

This Ansible playbook provides a simple, idempotent, and configuration-driven way to deploy [Pangolin](https://github.com/fosrl/pangolin) and its components using Docker Compose.

It follows Ansible best practices, separating configuration from logic, to make deployment easy and repeatable.

## Prerequisites

- Ansible 2.10+ installed on your local machine.
- A target server running a recent version of Ubuntu or Debian.
- SSH access to the target server (preferably with key-based authentication).
- A domain name (e.g., `example.com`) and a subdomain (e.g., `pangolin.example.com`) pointing to your server's IP address.

## Quick Start

Getting started is designed to be as simple as possible.

### 1. Clone the Repository

```bash
git clone https://github.com/patelanuj21/pangolin-ansible-terraform.git
cd pangolin-ansible-terraform
```

### 2. Configure Your Deployment

All user-configurable variables are managed in a single location.

First, copy the example variables file:

```bash
cd ansible
cp group_vars/all/main.yml.example group_vars/all/main.yml
```

Next, edit `ansible/group_vars/all/main.yml` and fill in the **mandatory** variables with your own details.

```yaml
# group_vars/all/main.yml

# MANDATORY: You must set these for every deployment
pangolin_dashboard_url: "https://pangolin.your-domain.com"
pangolin_base_domain: "your-domain.com"
pangolin_secret: "your-super-secret-key"
pangolin_admin_email: "your-email@example.com"
```

> **Tip:** You can use the included helper script from within the `ansible` directory:
> ```bash
> ./generate-secret.sh
> ```

### 3. Update Your Inventory

Edit `ansible/inventory/hosts.ini` and add your server's connection details. It's recommended to use a friendly name for your server:

```ini
[pangolin]
my-pangolin-server ansible_host=your-server-ip ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem
```

### 4. Run the Playbook

From within the `ansible` directory, execute the playbook:

```bash
cd ansible
ansible-playbook -i inventory/hosts.ini playbook.yml
```

The playbook will handle everything, and in a few minutes, your Pangolin instance will be live.

## Configuration Explained

This project uses Ansible's `group_vars` to manage all settings, providing a clean separation between the playbook's logic and your specific configuration.

- **`group_vars/all/main.yml.example`**: This is the master reference for all available variables. It is well-documented and separates mandatory from optional settings.
- **`group_vars/all/main.yml`**: This is your actual configuration file, which you create by copying the example. **This file should not be committed to version control** if it contains sensitive information.

## What the Playbook Does

1.  **Common Setup (`common` role):**
    -   Installs essential packages (`curl`, `vim`, `htop`, `net-tools`, etc.).
    -   Ensures the system is up-to-date.

2.  **Docker Installation (`docker` role):**
    -   Installs Docker and Docker Compose.
    -   Adds the specified `ansible_user` to the `docker` group to allow running Docker commands without `sudo`.

3.  **Pangolin Deployment (`pangolin` role):**
    -   Creates the necessary directories on the server (e.g., `/home/ubuntu/pangolin`).
    -   Templates the configuration files for Pangolin and Traefik based on your variables.
    -   Uses Docker Compose to start (or update) the `pangolin`, `gerbil`, and `traefik` containers. The deployment is idempotent and will only restart services if the configuration has changed.

## Post-Installation

Once the playbook finishes, you can access your Pangolin dashboard at the URL you configured (`pangolin_dashboard_url`).

## Troubleshooting

- **Check Docker Container Logs:** If something isn't working, the first place to check is the container logs. SSH into your server and run:
  ```bash
  docker logs pangolin
  docker logs traefik
  docker logs gerbil
  ```
- **Verify Configuration:** Double-check that all mandatory variables in `ansible/group_vars/all/main.yml` are set correctly.

## Security

- Always use a strong, unique `pangolin_secret`.
- Ensure your server's firewall is properly configured, although the roles handle basic package needs.

## Support

For issues with Pangolin itself, please refer to the official resources:
- [Pangolin Documentation](https://docs.fossorial.io/)
- [Pangolin GitHub](https://github.com/fosrl/pangolin)
- [Pangolin Discord](https://discord.gg/pangolin) 