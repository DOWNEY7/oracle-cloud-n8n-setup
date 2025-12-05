#!/bin/bash

# Oracle Cloud n8n Automated Installer (OAuth Ready)
# Author: Your Name
# License: MIT

set -e

echo "--- 🚀 Starting Smart n8n Setup ---"

# 1. Detect Public IP (The Magic Step)
echo "[1/6] Detecting Public IP..."
PUBLIC_IP=$(curl -s ifconfig.me)
echo "Detected IP: $PUBLIC_IP"

# 2. System Updates
echo "[2/6] Updating System..."
sudo apt update -q && sudo apt upgrade -y -q

# 3. Swap Configuration
echo "[3/6] Checking for Swap Space..."
if [ -f /swapfile ]; then
    echo "Swap file exists."
else
    echo "Creating 2GB Swap file..."
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# 4. Install Docker
echo "[4/6] Installing Docker..."
if ! command -v docker &> /dev/null; then
    sudo apt install docker.io -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed."
fi

# 5. Firewall
echo "[5/6] Configuring Firewall..."
sudo ufw allow ssh
sudo ufw allow 5678/tcp

# 6. Deploy n8n with nip.io Domain
echo "[6/6] Deploying n8n Container..."
mkdir -p ~/.n8n
sudo chown -R 1000:1000 ~/.n8n

# Stop old container if running
docker stop n8n 2>/dev/null || true
docker rm n8n 2>/dev/null || true

# Run new container with Dynamic Domain
docker run -d \
  --restart unless-stopped \
  --name n8n \
  -p 5678:5678 \
  -e N8N_SECURE_COOKIE=false \
  -e WEBHOOK_URL=http://${PUBLIC_IP}.nip.io:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n

echo "--- ✅ Setup Complete! ---"
echo "Your server is ready at: http://${PUBLIC_IP}.nip.io:5678"
echo "This URL supports Google OAuth and Webhooks!"