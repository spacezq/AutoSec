# Auto_scanweb

Auto_scanweb is an automated web domain enumeration and vulnerability scanning script. It performs passive reconnaissance, subdomain enumeration, live domain detection, vulnerability scanning, and sends data to Burp Suite for further manual testing.

## Table of Contents
- [Installation](#installation)
- [Setup](#setup)
- [Usage](#usage)
- [Tools Used](#tools-used)
- [Contribution](#contribution)
- [License](#license)

## Installation

To get started with Auto_scanweb, clone the repository and navigate to the project directory:

```bash
git clone https://github.com/spacezq/Auto_scanweb.git
cd Auto_scanweb
```
Automated Setup
Alternatively, you can use the provided setup.sh script to automate the installation process for the required tools:

```bash
chmod +x setup.sh
./setup.sh
```
This script will install the necessary tools on a Kali Linux or Ubuntu system.

Usage
To run the Auto_scanweb script, use the following command:

```bash
Copy code
./auto.sh <domain>
```
Replace <domain> with the target domain you want to scan. The script will perform the following actions:

Passive Enumeration: Subdomain enumeration using multiple tools.
Vulnerability Scanning: Scan live domains and identified parameters using Nuclei.
Data Export to Burp Suite: Sends all discovered URLs to Burp Suite for further manual testing.
Example:
```bash
./auto.sh example.com
```
The results will be saved in the respective folders created under the domain's directory.
