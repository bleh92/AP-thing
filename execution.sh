#!/bin/bash

# Check if the script is running as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root."
    exit 1
fi

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if required tools are installed
required_tools=("go" "googler" "subfinder" "dnsx" "dnsmorph")

for tool in "${required_tools[@]}"; do
    if ! command_exists "$tool"; then
        echo "Error: $tool is not installed. Please install it before running this script."
        exit 1
    fi
done

# Take URL as input
read -p "Enter the target URL: " target_url

# Commands to run after confirming root and tool installation
echo "Running commands for $target_url:"

# dnsmorph
dnsmorph -d "$target_url" -w -r -g -json > "$target_url-dnsmorph-results.json"
dnsmorph -d "$target_url" > "$target_url-permutations.txt" 
# subfinder
echo "-----------Finding all subdomain-----------"
subfinder -d "$target_url" -all -oJ > "$target_url-subfinder-results.json"
echo "-----------Finding a records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -a -resp -j > "$target_url-(a)record-results.json"
echo "-----------Finding aaaa records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -aaaa -resp -j > "$target_url-(aaaa)record-results.json"
echo "-----------Finding cname records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -cname -resp -j > "$target_url-(cname)record-results.json"
echo "-----------Finding ns records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -ns -resp -j > "$target_url-(ns)record-results.json"
echo "-----------Finding txt records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -txt -resp -j > "$target_url-(txt)record-results.json"
echo "-----------Finding srv records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -srv -resp -j > "$target_url-(srv)record-results.json"
echo "-----------Finding ptr records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -ptr -resp -j > "$target_url-(ptr)record-results.json"
echo "-----------Finding mx records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -mx -resp -j > "$target_url-(mx)record-results.json"
echo "-----------Finding soa records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -soa -resp -j > "$target_url-(soa)record-results.json"
echo "-----------Finding axfr records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -axfr -resp -j > "$target_url-(axfr)record-results.json"
echo "-----------Finding caa records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -caa -resp -j > "$target_url-(caa)record-results.json"
echo "-----------Finding any records-----------"
subfinder -silent -d "$target_url" | dnsx -silent -any -resp -j > "$target_url-(any)record-results.json"

echo "Script completed."
