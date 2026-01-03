# DevOps Scripts for EC2 Amazon Linux

A comprehensive collection of DevOps automation scripts organized by tools for EC2 Amazon Linux deployment.

---

## 📁 Folder Structure

```
scripts/
├── aws/                    # AWS CLI scripts
│   └── install-awscli.sh
├── build/                  # Build automation
│   ├── build.sh
│   └── build - Copy.sh
├── deploy/                 # Deployment & operations
│   ├── deploy.sh
│   ├── cleanup.sh
│   ├── rollback.sh
│   ├── push.sh
│   ├── smoke-test.sh
│   └── test.sh
├── docker/                 # Docker scripts
│   └── install-docker.sh
├── ec2/                    # EC2 bootstrap scripts
│   └── ec2-bootstrap.sh
├── helm/                   # Helm deployment scripts
│   ├── install-helm.sh
│   ├── helm-deploy.sh
│   └── helm-deploy.ps1
├── install/                # Master install scripts
│   ├── install-all.sh
│   └── check-all-installations.sh
├── jenkins/                # Jenkins CI/CD
│   ├── install-jenkins.sh
│   └── install-jenkins.ps1
├── kubernetes/             # Kubernetes scripts
│   └── install-kubectl.sh
├── monitoring/             # Monitoring tools
│   ├── install-grafana-prometheus.sh
│   └── install-monitoring.ps1
├── sonarqube/              # Code quality
│   └── install-sonarqube.sh
└── terraform/              # Infrastructure as Code
    ├── install-terraform.sh
    ├── terraform-init.sh
    ├── terraform-apply.sh
    └── terraform-destroy.sh
```

---

## 🚀 Quick Start on EC2 Amazon Linux

### 1️⃣ Clone Repository

```bash
# Update system
sudo yum update -y

# Install git
sudo yum install -y git

# Clone repository
git clone https://github.com/YOUR_USERNAME/AWS-Project-HostGithub.git
cd AWS-Project-HostGithub/scripts/Script-s-

# Make all scripts executable
find . -name "*.sh" -exec chmod +x {} \;
```

### 2️⃣ Install All Tools

```bash
cd install
sudo ./install-all.sh
```

### 3️⃣ Verify Installations

```bash
./check-all-installations.sh
```

---

## 📦 Individual Tool Installation

### AWS CLI
```bash
cd aws
sudo ./install-awscli.sh

# Verify
aws --version
```

### Docker
```bash
cd docker
sudo ./install-docker.sh

# Verify
docker --version
sudo systemctl status docker
```

### Kubernetes (kubectl)
```bash
cd kubernetes
sudo ./install-kubectl.sh

# Verify
kubectl version --client
```

### Helm
```bash
cd helm
sudo ./install-helm.sh

# Verify
helm version
```

### Terraform
```bash
cd terraform
sudo ./install-terraform.sh

# Verify
terraform --version
```

### Jenkins
```bash
cd jenkins
sudo ./install-jenkins.sh

# Verify
sudo systemctl status jenkins

# Get initial password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### SonarQube
```bash
cd sonarqube
sudo ./install-sonarqube.sh

# Verify
sudo docker ps | grep sonarqube
```

### Monitoring (Grafana & Prometheus)
```bash
cd monitoring
sudo ./install-grafana-prometheus.sh

# Verify
sudo systemctl status grafana-server
sudo systemctl status prometheus
```

---

## 🔧 Operations Scripts

### Build
```bash
cd build
./build.sh
```

### Deploy
```bash
cd deploy
./deploy.sh
```

### Rollback
```bash
cd deploy
./rollback.sh
```

### Cleanup
```bash
cd deploy
./cleanup.sh
```

### Smoke Test
```bash
cd deploy
./smoke-test.sh
```

---

## 🏗️ Terraform Commands

```bash
cd terraform

# Initialize Terraform
./terraform-init.sh

# Apply infrastructure
./terraform-apply.sh

# Destroy infrastructure
./terraform-destroy.sh
```

---

## ☸️ Helm Deployment

```bash
cd helm

# Deploy with Helm
./helm-deploy.sh

# PowerShell (Windows)
./helm-deploy.ps1
```

---

## 🌐 Service Access URLs

| Service | Port | URL |
|---------|------|-----|
| Jenkins | 8080 | `http://<EC2-IP>:8080` |
| SonarQube | 9000 | `http://<EC2-IP>:9000` |
| Grafana | 3000 | `http://<EC2-IP>:3000` |
| Prometheus | 9090 | `http://<EC2-IP>:9090` |

---

## ✅ Verify All Installations

Run the check script to verify all tools:

```bash
cd install
./check-all-installations.sh
```

**Manual verification:**

```bash
# CLI Tools
aws --version
docker --version
kubectl version --client
helm version
terraform --version

# Services
sudo systemctl status docker jenkins grafana-server prometheus
```

---

## 🔒 EC2 Security Group Ports

Ensure your EC2 security group allows:

| Port | Service |
|------|---------|
| 22 | SSH |
| 80 | HTTP |
| 443 | HTTPS |
| 8080 | Jenkins |
| 9000 | SonarQube |
| 3000 | Grafana |
| 9090 | Prometheus |

---

## 📝 Default Credentials

| Service | Username | Password |
|---------|----------|----------|
| Jenkins | admin | `/var/lib/jenkins/secrets/initialAdminPassword` |
| SonarQube | admin | admin |
| Grafana | admin | admin |

---

## 🛠️ Troubleshooting

```bash
# Permission denied
chmod +x script.sh

# Service not starting
sudo journalctl -u <service-name> -f

# Docker permission issue
sudo usermod -aG docker $USER
newgrp docker

# Restart service
sudo systemctl restart <service-name>
```

---

## 📄 License

MIT License

