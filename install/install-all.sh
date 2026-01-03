#!/bin/bash

#############################################
#  Install All DevOps Tools Script
#  For EC2 Amazon Linux
#  Updated for Tool-wise Folder Structure
#############################################

set -e  # Exit on error

echo ""
echo "============================================"
echo "   🚀 Installing All DevOps Tools"
echo "============================================"
echo ""

# Get the base directory (parent of install folder)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

echo "Base Directory: $BASE_DIR"
echo ""

# Define install scripts with their folder paths
declare -A INSTALL_SCRIPTS=(
    ["AWS CLI"]="aws/install-awscli.sh"
    ["Docker"]="docker/install-docker.sh"
    ["Kubectl"]="kubernetes/install-kubectl.sh"
    ["Helm"]="helm/install-helm.sh"
    ["Terraform"]="terraform/install-terraform.sh"
    ["Jenkins"]="jenkins/install-jenkins.sh"
    ["SonarQube"]="sonarqube/install-sonarqube.sh"
    ["Grafana & Prometheus"]="monitoring/install-grafana-prometheus.sh"
)

# Order of installation
INSTALL_ORDER=(
    "AWS CLI"
    "Docker"
    "Kubectl"
    "Helm"
    "Terraform"
    "Jenkins"
    "SonarQube"
    "Grafana & Prometheus"
)

# Counter
TOTAL=${#INSTALL_ORDER[@]}
CURRENT=0
SUCCESS=0
FAILED=0

# Make all scripts executable
find "$BASE_DIR" -name "*.sh" -exec chmod +x {} \;

echo "Found $TOTAL tools to install"
echo ""

for tool in "${INSTALL_ORDER[@]}"; do
    ((CURRENT++))
    script_path="${INSTALL_SCRIPTS[$tool]}"
    full_path="$BASE_DIR/$script_path"
    
    if [ -f "$full_path" ]; then
        echo "============================================"
        echo "[$CURRENT/$TOTAL] Installing: $tool"
        echo "Script: $script_path"
        echo "============================================"
        echo ""
        
        if bash "$full_path"; then
            echo ""
            echo "✅ $tool installed successfully"
            ((SUCCESS++))
        else
            echo ""
            echo "❌ $tool installation failed"
            ((FAILED++))
        fi
        echo ""
    else
        echo "⚠️  Script not found: $script_path"
        ((FAILED++))
    fi
done

echo ""
echo "============================================"
echo "   📊 Installation Summary"
echo "============================================"
echo ""
echo "   Total Tools:    $TOTAL"
echo "   ✅ Successful:  $SUCCESS"
echo "   ❌ Failed:      $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "   🎉 All installations completed successfully!"
else
    echo "   ⚠️  Some installations failed. Check the logs above."
fi

echo ""
echo "============================================"
echo "   📋 Next Steps"
echo "============================================"
echo ""
echo "   1. Run the check script to verify installations:"
echo "      ./check-all-installations.sh"
echo ""
echo "   2. Access your services:"

# Get EC2 Public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo "<EC2-PUBLIC-IP>")

echo "      Jenkins:    http://$PUBLIC_IP:8080"
echo "      SonarQube:  http://$PUBLIC_IP:9000"
echo "      Grafana:    http://$PUBLIC_IP:3000"
echo "      Prometheus: http://$PUBLIC_IP:9090"
echo ""
echo "   3. Get Jenkins initial password:"
echo "      sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo "============================================"
echo ""
