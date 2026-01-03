# Installation Scripts for EC2 Amazon Linux

This folder contains installation scripts for setting up a DevOps environment on EC2 Amazon Linux.

## Prerequisites

- EC2 Amazon Linux 2 or Amazon Linux 2023 instance
- Root or sudo access
- Internet connectivity

---

## Quick Start - Clone Repository

```bash
# Update system packages
sudo yum update -y

# Install git if not installed
sudo yum install -y git

# Clone the repository
git clone https://github.com/YOUR_USERNAME/AWS-Project-HostGithub.git

# Navigate to install scripts folder
cd AWS-Project-HostGithub/scripts/Script-s-/install

# Make all scripts executable
chmod +x *.sh
```

---

## Install All Tools

### Option 1: Install All at Once

```bash
# Run all install scripts
./install-awscli.sh
./install-docker.sh
./install-kubectl.sh
./install-helm.sh
./install-terraform.sh
./install-jenkins.sh
./install-sonarqube.sh
./install-grafana-prometheus.sh
```

### Option 2: One-Liner Install All

```bash
# Install all tools with one command
for script in install-*.sh; do
    echo "========================================"
    echo "Running: $script"
    echo "========================================"
    sudo bash "$script"
done
```

---

## Individual Installation Commands

| Tool | Install Command |
|------|-----------------|
| AWS CLI | `sudo bash install-awscli.sh` |
| Docker | `sudo bash install-docker.sh` |
| Kubectl | `sudo bash install-kubectl.sh` |
| Helm | `sudo bash install-helm.sh` |
| Terraform | `sudo bash install-terraform.sh` |
| Jenkins | `sudo bash install-jenkins.sh` |
| SonarQube | `sudo bash install-sonarqube.sh` |
| Grafana & Prometheus | `sudo bash install-grafana-prometheus.sh` |

---

## Verify All Installations

### Quick Check Script

Run this command to check if all tools are installed:

```bash
#!/bin/bash
echo "============================================"
echo "   Checking All Tool Installations"
echo "============================================"

# Function to check command
check_tool() {
    if command -v $1 &> /dev/null; then
        echo "✅ $2 is installed: $($1 --version 2>&1 | head -1)"
    else
        echo "❌ $2 is NOT installed"
    fi
}

# Check AWS CLI
check_tool "aws" "AWS CLI"

# Check Docker
check_tool "docker" "Docker"

# Check Kubectl
check_tool "kubectl" "Kubectl"

# Check Helm
check_tool "helm" "Helm"

# Check Terraform
check_tool "terraform" "Terraform"

# Check Jenkins (service)
if systemctl is-active --quiet jenkins 2>/dev/null; then
    echo "✅ Jenkins is installed and running"
else
    echo "❌ Jenkins is NOT running or not installed"
fi

# Check SonarQube (service/container)
if docker ps 2>/dev/null | grep -q sonarqube; then
    echo "✅ SonarQube is running (Docker)"
elif systemctl is-active --quiet sonarqube 2>/dev/null; then
    echo "✅ SonarQube is installed and running"
else
    echo "❌ SonarQube is NOT running"
fi

# Check Grafana
if systemctl is-active --quiet grafana-server 2>/dev/null; then
    echo "✅ Grafana is installed and running"
else
    echo "❌ Grafana is NOT running or not installed"
fi

# Check Prometheus
if systemctl is-active --quiet prometheus 2>/dev/null; then
    echo "✅ Prometheus is installed and running"
else
    echo "❌ Prometheus is NOT running or not installed"
fi

echo "============================================"
echo "   Installation Check Complete"
echo "============================================"
```

### Individual Verification Commands

```bash
# Check AWS CLI
aws --version

# Check Docker
docker --version
docker info
sudo systemctl status docker

# Check Kubectl
kubectl version --client

# Check Helm
helm version

# Check Terraform
terraform --version

# Check Jenkins
sudo systemctl status jenkins
# Access: http://<EC2-PUBLIC-IP>:8080

# Check SonarQube
sudo docker ps | grep sonarqube
# Access: http://<EC2-PUBLIC-IP>:9000

# Check Grafana
sudo systemctl status grafana-server
# Access: http://<EC2-PUBLIC-IP>:3000

# Check Prometheus
sudo systemctl status prometheus
# Access: http://<EC2-PUBLIC-IP>:9090
```

---

## Service Ports

| Service | Default Port | Access URL |
|---------|--------------|------------|
| Jenkins | 8080 | `http://<EC2-IP>:8080` |
| SonarQube | 9000 | `http://<EC2-IP>:9000` |
| Grafana | 3000 | `http://<EC2-IP>:3000` |
| Prometheus | 9090 | `http://<EC2-IP>:9090` |

---

## Troubleshooting

### Common Issues

```bash
# If permission denied
sudo chmod +x *.sh

# If script fails, check logs
sudo journalctl -xe

# Restart a service
sudo systemctl restart <service-name>

# Check service logs
sudo journalctl -u <service-name> -f

# Docker permission issue
sudo usermod -aG docker $USER
newgrp docker
```

### EC2 Security Group

Make sure your EC2 security group allows inbound traffic on these ports:
- 22 (SSH)
- 8080 (Jenkins)
- 9000 (SonarQube)
- 3000 (Grafana)
- 9090 (Prometheus)

---

## Uninstall Commands

```bash
# Remove AWS CLI
sudo rm -rf /usr/local/aws-cli
sudo rm /usr/local/bin/aws

# Remove Docker
sudo yum remove -y docker
sudo rm -rf /var/lib/docker

# Remove Kubectl
sudo rm /usr/local/bin/kubectl

# Remove Helm
sudo rm /usr/local/bin/helm

# Remove Terraform
sudo rm /usr/local/bin/terraform

# Stop and remove Jenkins
sudo systemctl stop jenkins
sudo yum remove -y jenkins

# Stop and remove SonarQube
sudo docker stop sonarqube
sudo docker rm sonarqube

# Remove Grafana
sudo systemctl stop grafana-server
sudo yum remove -y grafana

# Remove Prometheus
sudo systemctl stop prometheus
sudo yum remove -y prometheus
```

---

## Quick Reference Card

```bash
# Clone & Setup
git clone https://github.com/YOUR_USERNAME/AWS-Project-HostGithub.git
cd AWS-Project-HostGithub/scripts/Script-s-/install
chmod +x *.sh

# Install All
for script in install-*.sh; do sudo bash "$script"; done

# Check All
aws --version && docker --version && kubectl version --client && helm version && terraform --version

# Service Status
sudo systemctl status jenkins grafana-server prometheus docker
```

---

## Notes

- Replace `YOUR_USERNAME` with your actual GitHub username
- Some installations may require a system restart
- Default credentials for services:
  - **Jenkins**: Initial admin password at `/var/lib/jenkins/secrets/initialAdminPassword`
  - **SonarQube**: admin / admin
  - **Grafana**: admin / admin

