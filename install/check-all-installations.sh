#!/bin/bash

#############################################
#  Check All Tool Installations Script
#  For EC2 Amazon Linux
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
        ((FAIL++))
    fi
    echo ""
}

# Function to check services
check_service() {
    local service=$1
    local name=$2
    if systemctl is-active --quiet $service 2>/dev/null; then
        echo "✅ $name service is RUNNING"
        ((PASS++))
    elif systemctl is-enabled --quiet $service 2>/dev/null; then
        echo "⚠️  $name is installed but NOT running"
        echo "   Start with: sudo systemctl start $service"
        ((FAIL++))
    else
        echo "❌ $name service is NOT installed"
        ((FAIL++))
    fi
    echo ""
}

# Function to check Docker containers
check_docker_container() {
    local container=$1
    local name=$2
    if docker ps 2>/dev/null | grep -q $container; then
        echo "✅ $name is running (Docker container)"
        ((PASS++))
    elif docker ps -a 2>/dev/null | grep -q $container; then
        echo "⚠️  $name container exists but NOT running"
        ((FAIL++))
    else
        echo "❌ $name container is NOT found"
        ((FAIL++))
    fi
    echo ""
}

echo "------- CLI Tools -------"
echo ""

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

echo "------- Services -------"
echo ""

# Check Docker Service
check_service "docker" "Docker"

# Check Jenkins
check_service "jenkins" "Jenkins"

# Check Grafana
check_service "grafana-server" "Grafana"

# Check Prometheus
check_service "prometheus" "Prometheus"

echo "------- Docker Containers -------"
echo ""

# Check if Docker is running first
if command -v docker &> /dev/null && docker info &> /dev/null; then
    check_docker_container "sonarqube" "SonarQube"
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
