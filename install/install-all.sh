#!/bin/bash

#############################################
#  Install All DevOps Tools Script
#  For EC2 Amazon Linux
#############################################

set -e  # Exit on error

echo ""
echo "============================================"
echo "   🚀 Installing All DevOps Tools"
echo "============================================"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List of install scripts in order
SCRIPTS=(
    "install-awscli.sh"
    "install-docker.sh"
    "install-kubectl.sh"
    "install-helm.sh"
    "install-terraform.sh"
    "install-jenkins.sh"
    "install-sonarqube.sh"
    "install-grafana-prometheus.sh"
)

# Counter
TOTAL=${#SCRIPTS[@]}
CURRENT=0
SUCCESS=0
FAILED=0

# Make all scripts executable
chmod +x "$SCRIPT_DIR"/*.sh

echo "Found $TOTAL installation scripts to run"
echo ""

for script in "${SCRIPTS[@]}"; do
    ((CURRENT++))
    
    if [ -f "$SCRIPT_DIR/$script" ]; then
        echo "============================================"
        echo "[$CURRENT/$TOTAL] Running: $script"
        echo "============================================"
        echo ""
        
        if bash "$SCRIPT_DIR/$script"; then
            echo ""
            echo "✅ $script completed successfully"
            ((SUCCESS++))
        else
            echo ""
            echo "❌ $script failed"
            ((FAILED++))
        fi
        echo ""
    else
        echo "⚠️  Script not found: $script"
        ((FAILED++))
    fi
done

echo ""
echo "============================================"
echo "   📊 Installation Summary"
echo "============================================"
echo ""
echo "   Total Scripts:  $TOTAL"
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
