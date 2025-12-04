#!/bin/bash

# Oracle Cloud n8n Automated Installer
# Author: Your Name
# License: MIT

set -e # Stop script on error

echo "--- 🚀 Starting n8n Setup for Oracle Cloud ---"

# 1. System Updates
echo "[1/5] Updating System..."
sudo apt update -q && sudo apt upgrade -y -q

# 2. Swap Configuration
echo "[2/5] Checking for Swap Space..."
if [ -f /swapfile ]; then
    echo "Swap file already exists. Skipping."
else
    echo "Creating 2GB Swap file..."
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# 3. Install Docker
echo "[3/5] Installing Docker..."
if ! command -v docker &> /dev/null; then
    sudo apt install docker.io -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    echo "Docker installed."
else
    echo "Docker is already installed."
fi

# 4. Firewall Setup
echo "[4/5] Configuring Firewall..."
sudo ufw allow ssh
sudo ufw allow 5678/tcp
# We don't force 'ufw enable' here to avoid locking the user out if SSH isn't allowed yet.
echo "Firewall rules updated. Please manually run 'sudo ufw enable' if not active."

# 5. n8n Deployment
echo "[5/5] Deploying n8n Container..."
mkdir -p ~/.n8n
sudo chown -R 1000:1000 ~/.n8n

# Check if n8n is already running
if [ "$(docker ps -q -f name=n8n)" ]; then
    echo "n8n is already running."
else
    docker run -d \
      --restart unless-stopped \
      --name n8n \
      -p 5678:5678 \
      -e N8N_SECURE_COOKIE=false \
      -v ~/.n8n:/home/node/.n8n \
      n8nio/n8n
    echo "n8n started!"
fi

echo "--- ✅ Setup Complete! ---"
echo "Access your server at: http://$(curl -s ifconfig.me):5678"
echo "IMPORTANT: You may need to log out and log back in for Docker permissions to apply."
