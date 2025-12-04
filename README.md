# Free Self-Hosted n8n on Oracle Cloud

This project documents the complete setup of a perpetually free automation server using n8n on Oracle Cloud Infrastructure (OCI) Free Tier.

## 📋 Project Specs
- **Cloud Provider:** Oracle Cloud Infrastructure (Always Free Tier)
- **Region:** UK London (or your specific region)
- **Instance Shape:** VM.Standard.E2.1.Micro (AMD) or VM.Standard.A1.Flex (Ampere)
- **OS:** Ubuntu 22.04 LTS
- **Software:** Docker, n8n
- **Cost:** $0.00/month

---

## 🛠️ Step 1: Infrastructure Setup (Oracle Cloud)

### 1. Instance Creation
* **Placement:** Used **Availability Domain 2 (AD-2)** (or whichever AD had capacity).
* **Image:** Canonical Ubuntu 22.04.
* **Shape:** * *Preferred:* VM.Standard.A1.Flex (4 OCPU, 24GB RAM)
  * *Fallback:* VM.Standard.E2.1.Micro (1 OCPU, 1GB RAM) - *Used in this deployment.*

### 2. Networking
* **VCN:** Created new Virtual Cloud Network.
* **Subnet:** Created new **Public Subnet**.
* **Public IP:** Enabled "Automatically assign public IPv4 address".
* **SSH Keys:** Generated and saved the `.key` file locally.

---

## ⚙️ Step 2: Server Configuration

### 1. Connect via SSH
```bash
# Replace key path and IP with actual values
ssh -i "path/to/your/private.key" ubuntu@YOUR_IP_ADDRESS