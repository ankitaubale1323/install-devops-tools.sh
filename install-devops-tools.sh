#!/bin/bash

set -e

echo "🚀 Starting DevOps Setup..."

# -----------------------------
# 1. Update System
# -----------------------------
echo "📦 Updating system..."
sudo apt update && sudo apt upgrade -y

# -----------------------------
# 2. Install Dependencies
# -----------------------------
echo "🔧 Installing dependencies..."
sudo apt install -y ca-certificates curl gnupg lsb-release unzip software-properties-common

# -----------------------------
# 3. Install Docker
# -----------------------------
echo "🐳 Installing Docker..."
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ubuntu 
newgrp docker

echo "✅ Docker Installed"

# -----------------------------
# 4. Install kubectl
# -----------------------------
echo "☸️ Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "✅ kubectl Installed"

# -----------------------------
# 5. Install Helm
# -----------------------------
echo "📦 Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "✅ Helm Installed"

# -----------------------------
# 6. Install AWS CLI
# -----------------------------
echo "☁️ Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip
sudo ./aws/install

echo "✅ AWS CLI Installed"

# -----------------------------
# 7. Install Nginx
# -----------------------------
echo "🌐 Installing Nginx..."
sudo apt install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

echo "✅ Nginx Installed"

# -----------------------------
# 8. Cleanup
# -----------------------------
rm -rf aws awscliv2.zip

# -----------------------------
# 9. Verification
# -----------------------------
echo "🔍 Verifying installations..."

docker --version
kubectl version --client
helm version
aws --version
nginx -v

echo "🎉 DevOps Setup Completed!"

echo "⚠️ IMPORTANT: Logout and login again to use Docker without sudo"

# -----------------------------
# 10. AWS Configure Reminder
# -----------------------------
echo ""
echo "👉 Run this command to configure AWS:"
echo "aws configure"
echo ""
