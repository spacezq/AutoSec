#!/bin/bash

# Update system
echo "[+] Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo "[+] Installing dependencies..."
sudo apt install -y git curl wget parallel

# Install Go (required for subfinder, assetfinder, and others)
sudo apt install gccgo-go -y
sudo apt install golang-go -y

# Install Subfinder
echo "[+] Installing Subfinder..."
sudo apt install subfinder

# Install Assetfinder
echo "[+] Installing Assetfinder..."
sudo apt install assetfinder

# Install Findomain
echo "[+] Installing Findomain..."
curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux.zip
unzip findomain-linux.zip
chmod +x findomain
sudo mv findomain /usr/bin/findomain

# Install Amass
echo "[+] Installing Amass..."
sudo apt install amass -y

# Install httpx
echo "[+] Installing httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
sudo cp ~/go/bin/httpx /usr/local/bin/

# Install Waymore
echo "[+] Installing Waymore..."
sudo apt install waymore

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
