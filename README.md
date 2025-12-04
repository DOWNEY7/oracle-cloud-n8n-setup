# 🚀 Free Self-Hosted n8n on Oracle Cloud

![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Oracle Cloud](https://img.shields.io/badge/Oracle_Cloud-Free_Tier-red) ![Docker](https://img.shields.io/badge/Docker-Enabled-blue)

A complete guide and automation script to host [n8n](https://n8n.io/) perpetually free on Oracle Cloud Infrastructure (OCI) "Always Free" tier.

## 📋 Infrastructure Specs
* **Cloud Provider:** Oracle Cloud Infrastructure (OCI)
* **Region:** UK London (Adaptable to any region)
* **Cost:** $0.00/month (Always Free Tier)
* **OS:** Ubuntu 22.04 LTS
* **Hardware:**
    * *Preferred:* VM.Standard.A1.Flex (Ampere, 4 OCPU, 24GB RAM)
    * *Minimum:* VM.Standard.E2.1.Micro (AMD, 1 OCPU, 1GB RAM)

---

## 🛠️ Installation

### Option A: Quick Start (Automated)
If you have just created a fresh Ubuntu server, you can use the included script to set up everything automatically.

1.  **SSH into your server:**
    ```bash
    ssh -i /path/to/key.key ubuntu@YOUR_SERVER_IP
    ```

2.  **Download and Run the Script:**
    ```bash
    curl -O [https://raw.githubusercontent.com/YOUR_USERNAME/oracle-cloud-n8n-setup/main/install.sh](https://raw.githubusercontent.com/YOUR_USERNAME/oracle-cloud-n8n-setup/main/install.sh)
    chmod +x install.sh
    ./install.sh
    ```

### Option B: Manual Setup
If you prefer to run commands step-by-step, follow the sections below.

#### 1. Configure Swap (Crucial for Micro Instances)
Prevent crashes on low-RAM instances by adding a 2GB Swap file.
```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
````

#### 2. Install Docker Engine

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

*(Note: Log out and log back in for group changes to take effect)*

#### 3. Security & Firewall

Open port `5678` for the n8n web interface.

```bash
sudo ufw allow ssh
sudo ufw allow 5678/tcp
sudo ufw enable
```

#### 4. Deploy n8n Container

The following command disables the secure cookie requirement (needed for IP-based access) and sets permission ownership.

```bash
mkdir -p ~/.n8n
sudo chown -R 1000:1000 ~/.n8n

docker run -d \
  --restart unless-stopped \
  --name n8n \
  -p 5678:5678 \
  -e N8N_SECURE_COOKIE=false \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

-----

## 🧹 Maintenance

  * **Access n8n:** Open `http://YOUR_IP:5678` in your browser.
  * **View Logs:** `docker logs n8n --tail 20`
  * **Restart Server:** `docker restart n8n`
  * **Prevent Idle Shutdown:** Set up a scheduled workflow inside n8n to ping an external site (like Google) once per hour to keep the instance active.

<!-- end list -->
