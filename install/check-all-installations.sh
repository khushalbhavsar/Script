#!/bin/bash

#############################################
#  Check All Tool Installations Script
#  For EC2 Amazon Linux
#  Updated for Tool-wise Folder Structure
#############################################

echo ""
echo "============================================"
echo "   🔍 Checking All Tool Installations"
echo "============================================"
echo ""

PASS=0
FAIL=0

# Function to check CLI tools
check_tool() {
    local cmd=$1
    local name=$2
    if command -v $cmd &> /dev/null; then
        version=$($cmd --version 2>&1 | head -1)
        echo "✅ $name is installed"
        echo "   Version: $version"
        ((PASS++))
    else
        echo "❌ $name is NOT installed"
        echo "   Install: cd $(echo $3) && sudo ./$(echo $4)"
        ((FAIL++))
    fi
    echo ""
}

# Function to check services
check_service() {
    local service=$1
    local name=$2
    local folder=$3
    local script=$4
    if systemctl is-active --quiet $service 2>/dev/null; then
        echo "✅ $name service is RUNNING"
        ((PASS++))
    elif systemctl is-enabled --quiet $service 2>/dev/null; then
        echo "⚠️  $name is installed but NOT running"
        echo "   Start with: sudo systemctl start $service"
        ((FAIL++))
    else
        echo "❌ $name service is NOT installed"
        echo "   Install: cd $folder && sudo ./$script"
        ((FAIL++))
    fi
    echo ""
}

# Function to check Docker containers
check_docker_container() {
    local container=$1
    local name=$2
    local folder=$3
    local script=$4
    if docker ps 2>/dev/null | grep -q $container; then
        echo "✅ $name is running (Docker container)"
        ((PASS++))
    elif docker ps -a 2>/dev/null | grep -q $container; then
        echo "⚠️  $name container exists but NOT running"
        echo "   Start with: docker start $container"
        ((FAIL++))
    else
        echo "❌ $name container is NOT found"
        echo "   Install: cd $folder && sudo ./$script"
        ((FAIL++))
    fi
    echo ""
}

echo "------- CLI Tools -------"
echo ""

# Check AWS CLI
check_tool "aws" "AWS CLI" "aws" "install-awscli.sh"

# Check Docker
check_tool "docker" "Docker" "docker" "install-docker.sh"

# Check Kubectl
check_tool "kubectl" "Kubectl" "kubernetes" "install-kubectl.sh"

# Check Helm
check_tool "helm" "Helm" "helm" "install-helm.sh"

# Check Terraform
check_tool "terraform" "Terraform" "terraform" "install-terraform.sh"

echo "------- Services -------"
echo ""

# Check Docker Service
check_service "docker" "Docker" "docker" "install-docker.sh"

# Check Jenkins
check_service "jenkins" "Jenkins" "jenkins" "install-jenkins.sh"

# Check Grafana
check_service "grafana-server" "Grafana" "monitoring" "install-grafana-prometheus.sh"

# Check Prometheus
check_service "prometheus" "Prometheus" "monitoring" "install-grafana-prometheus.sh"

echo "------- Docker Containers -------"
echo ""

# Check if Docker is running first
if command -v docker &> /dev/null && docker info &> /dev/null; then
    check_docker_container "sonarqube" "SonarQube" "sonarqube" "install-sonarqube.sh"
else
    echo "⚠️  Docker is not running, skipping container checks"
    echo ""
fi

echo "============================================"
echo "   📊 Installation Summary"
echo "============================================"
echo ""
echo "   ✅ Passed: $PASS"
echo "   ❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "   🎉 All tools are installed correctly!"
else
    echo "   ⚠️  Some tools need to be installed"
    echo ""
    echo "   Run install-all.sh to install missing tools:"
    echo "   cd install && sudo ./install-all.sh"
fi

echo ""
echo "============================================"
echo "   🌐 Service Access URLs"
echo "============================================"
echo ""

# Get EC2 Public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo "<EC2-PUBLIC-IP>")

echo "   Jenkins:    http://$PUBLIC_IP:8080"
echo "   SonarQube:  http://$PUBLIC_IP:9000"
echo "   Grafana:    http://$PUBLIC_IP:3000"
echo "   Prometheus: http://$PUBLIC_IP:9090"
echo ""
echo "============================================"
echo ""
echo "   📁 Folder Structure:"
echo "   ├── aws/           - AWS CLI"
echo "   ├── docker/        - Docker"
echo "   ├── kubernetes/    - Kubectl"
echo "   ├── helm/          - Helm"
echo "   ├── terraform/     - Terraform"
echo "   ├── jenkins/       - Jenkins"
echo "   ├── sonarqube/     - SonarQube"
echo "   └── monitoring/    - Grafana & Prometheus"
echo ""
echo "============================================"
echo ""
