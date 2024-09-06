#!/bin/bash

# Update system
echo "[+] Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo "[+] Installing dependencies..."
sudo apt install -y git curl wget parallel

# Install Go (required for subfinder, assetfinder, and others)
echo "[+] Installing Go..."
wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz
sudo tar -xvf go1.20.5.linux-amd64.tar.gz -C /usr/local
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc

# Install Subfinder
echo "[+] Installing Subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
sudo cp ~/go/bin/subfinder /usr/local/bin/

# Install Assetfinder
echo "[+] Installing Assetfinder..."
go install -v github.com/tomnomnom/assetfinder@latest
sudo cp ~/go/bin/assetfinder /usr/local/bin/

# Install Findomain
echo "[+] Installing Findomain..."
wget https://github.com/findomain/findomain/releases/download/8.2.1/findomain-linux
chmod +x findomain-linux
sudo mv findomain-linux /usr/local/bin/findomain

# Install Amass
echo "[+] Installing Amass..."
sudo apt install amass -y

# Install httpx
echo "[+] Installing httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
sudo cp ~/go/bin/httpx /usr/local/bin/

# Install Waymore
echo "[+] Installing Waymore..."
git clone https://github.com/xnl-h4ck3r/waymore.git
cd waymore
pip install -r requirements.txt
sudo cp waymore.py /usr/local/bin/waymore

# Install Katana
echo "[+] Installing Katana..."
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
sudo cp ~/go/bin/katana /usr/local/bin/

# Install Nuclei
echo "[+] Installing Nuclei..."
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
sudo cp ~/go/bin/nuclei /usr/local/bin/

# Install FFUF
echo "[+] Installing FFUF..."
go install -v github.com/ffuf/ffuf@latest
sudo cp ~/go/bin/ffuf /usr/local/bin/

# Install qsreplace (optional)
echo "[+] Installing qsreplace..."
go install -v github.com/tomnomnom/qsreplace@latest
sudo cp ~/go/bin/qsreplace /usr/local/bin/

echo "[+] All tools installed successfully!"
