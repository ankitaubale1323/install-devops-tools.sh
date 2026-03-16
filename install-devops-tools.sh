#!/bin/bash
set -e

echo "================================================"
echo " Installing DevOps Tools on Ubuntu"
echo "================================================"

# ── Update system ──────────────────────────────────
echo "→ Updating system..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget unzip gnupg \
  software-properties-common apt-transport-https \
  ca-certificates lsb-release git

# ── AWS CLI ────────────────────────────────────────
echo "→ Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
echo "✅ AWS CLI: $(aws --version)"

# ── kubectl ────────────────────────────────────────
echo "→ Installing kubectl..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
echo "✅ kubectl: $(kubectl version --client --short 2>/dev/null)"

# ── Helm ───────────────────────────────────────────
echo "→ Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "✅ Helm: $(helm version --short)"

# ── Terraform ──────────────────────────────────────
echo "→ Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt update && sudo apt install -y terraform
echo "✅ Terraform: $(terraform --version | head -1)"

# ── Docker ─────────────────────────────────────────
echo "→ Installing Docker..."
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
echo "✅ Docker: $(docker --version)"

# ── Final verification ─────────────────────────────
echo ""
echo "================================================"
echo " All tools installed successfully!"
echo "================================================"
echo "AWS CLI:   $(aws --version)"
echo "kubectl:   $(kubectl version --client --short 2>/dev/null)"
echo "Helm:      $(helm version --short)"
echo "Terraform: $(terraform --version | head -1)"
echo "Docker:    $(docker --version)"
echo ""
echo "NEXT STEPS:"
echo "  1. Run: aws configure"
echo "  2. Log out and back in (for Docker permissions)"
echo "  3. Run: aws sts get-caller-identity"
echo "================================================"
