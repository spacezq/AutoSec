#!/bin/bash

domain=$1

if [ -z "$domain" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# 1 - Passive Enumeration
domain_enum() {
    echo "[+] Starting domain enumeration for: $domain"

    mkdir -p "$domain/sources" "$domain/Recon" "$domain/Recon/nuclei/"
    
    # Subdomain enumeration using multiple tools
    echo "[+] Running subfinder..."
    subfinder -d "$domain" -o "$domain/sources/subfinder.txt"
    
    echo "[+] Running assetfinder..."
    assetfinder --subs-only "$domain" | tee "$domain/sources/assetfinder.txt"
    
    echo "[+] Running findomain..."
    findomain -t "$domain" -q | tee "$domain/sources/find-domain.txt"
    
    echo "[+] Running amass..."
    amass enum -d "$domain" -o "$domain/sources/amass.txt"
    
    # Combine and de-duplicate results
    echo "[+] Merging results and removing duplicates..."
    cat "$domain/sources/"*.txt | sort -u > "$domain/sources/all.txt"
    
    # Find live domains
    echo "[+] Running httpx to find live domains..."
    cat "$domain/sources/all.txt" | httpx -silent -o "$domain/sources/live_domains.txt"
    
    # Crawling with waymore and katana
    echo "[+] Running waymore..."
    waymore -i "$domain" -mode U -oU "$domain/sources/waymore.txt"
    
    echo "[+] Running katana..."
    cat "$domain/sources/live_domains.txt" | katana -f qurl -silent -kf all -jc -aff -d 5 -o "$domain/sources/katana-param.txt"
    
    # Extract interesting files and parameters
    echo "[+] Extracting interesting files..."
    grep -E -i -o '\S+\.(bak|backup|swp|old|db|sql|asp|aspx|py|rb|php|cache|cgi|conf|csv|html|inc|jar|js|json|jsp|lock|log|tar\.gz|bz2|zip|txt|wadl|xml)' \
        "$domain/sources/waymore.txt" "$domain/sources/katana-param.txt" | sort -u > "$domain/sources/interesting_files.txt"
    
    echo "[+] Extracting parameters with equal signs..."
    cat "$domain/sources/waymore.txt" "$domain/sources/katana-param.txt" | sort -u | grep "=" | qsreplace 'FUZZ' | \
        egrep -v '(.css|.png|blog|utm_source|utm_medium|utm_campaign)' > "$domain/sources/waymore-katana-unfilter-urls.txt"
    
    # Filter live URLs with parameters
    echo "[+] Filtering live URLs with parameters..."
    cat "$domain/sources/waymore-katana-unfilter-urls.txt" | httpx -silent -t 150 -rl 150 -o "$domain/sources/waymore-katana-filter-urls.txt"
    grep '=' "$domain/sources/waymore-katana-filter-urls.txt" > "$domain/sources/parameters_with_equal.txt"
}

domain_enum

# 2 - Scanning with Nuclei and other tools
scanner() {
    echo "[+] Starting nuclei scan for: $domain"
    
    # Use multiple template sources
    echo "[+] Running nuclei for fuzzing templates..."
    nuclei -t /home/kali/fuzzing-templates/ -l "$domain/sources/parameters_with_equal.txt" -c 50 -o "$domain/Recon/nuclei/fuzzing-results.txt"
    
    echo "[+] Running nuclei for live domains..."
    nuclei -l "$domain/sources/live_domains.txt" -c 50 -o "$domain/sources/vulnerability.txt"
    
    # Optional: Add ffuf or dirsearch for directory fuzzing
    echo "[+] Running directory fuzzing with ffuf..."
    ffuf -w "$domain/sources/parameters_with_equal.txt" -u "https://$domain/FUZZ" -o "$domain/Recon/ffuf-results.txt"
}

scanner

# 3 - Send data to Burp Suite for further testing
send_to_burp() {
    echo "[+] Sending data to Burp Suite for further testing..."
    
    cat "$domain/sources/parameters_with_equal.txt" | parallel -j 10 'curl --proxy http://127.0.0.1:8080 -sk {}' >> /dev/null
    cat "$domain/sources/waymore-katana-unfilter-urls.txt" | parallel -j 10 'curl --proxy http://127.0.0.1:8080 -sk {}' >> /dev/null
    cat "$domain/sources/waymore-katana-filter-urls.txt" | parallel -j 10 'curl --proxy http://127.0.0.1:8080 -sk {}' >> /dev/null
}

send_to_burp

echo "[+] Recon and scanning completed for: $domain"

