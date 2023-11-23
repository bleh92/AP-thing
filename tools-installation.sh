#!/bin/bash

# Function to check and handle errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if running as root
if [ "$(whoami)" != "root" ]; then
    echo "This script must be run as root."
    exit 1
else
    echo "Script is running as root."
fi

# Check if Go is installed
if command -v go &> /dev/null; then
    echo "Go is already installed."
else
    echo "Go is not installed. Installing Go..."
    
    # Download and install Go
    wget "https://go.dev/dl/go1.21.4.linux-amd64.tar.gz"
    check_error "Failed to download Go"
    
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz
    check_error "Failed to install Go"

        # Check and update/export PATH
    if grep -q "export PATH=\$PATH:/usr/local/go/bin" ~/.bashrc; then
        sed -i 's/export PATH=\$PATH:\/usr\/local\/go\/bin/export PATH=\$PATH:\/usr\/local\/go\/bin/' ~/.bashrc
        echo "Updated export PATH statement in .bashrc"
    else
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        echo "Added export PATH statement to .bashrc"
    fi
    # Check and update/export GOBIN
    if grep -q "export GOBIN=/usr/local/go/bin" ~/.bashrc; then
        sed -i 's/export GOBIN=\/usr\/local\/go\/bin/export GOBIN=\/usr\/local\/go\/bin/' ~/.bashrc
        echo "Updated export GOBIN statement in .bashrc"
    else
        echo 'export GOBIN=/usr/local/go/bin' >> ~/.bashrc
        echo "Added export GOBIN statement to .bashrc"
    fi

    
    # Verify if Go is installed
    if command -v go &> /dev/null; then
        echo "Go has been successfully installed."
    else
        echo "Failed to install Go. Please check the installation process."
    fi
fi

source ~/.bashrc
# Install dnsmorph
echo "Installing dnsmorph..."
wget https://github.com/netevert/dnsmorph/releases/download/v1.2.8/dnsmorph_1.2.8_linux_64-bit.tar.gz
check_error "Failed to download dnsmorph"
tar -xzf dnsmorph_1.2.8_linux_64-bit.tar.gz
check_error "Failed to install dnsmorph"

# Verify if dnsmorph is installed
if command -v dnsmorph &> /dev/null; then
    echo "dnsmorph has been successfully installed."
else
    echo "Failed to install dnsmorph. Please check the installation process."
fi
chmod +x dnsmorph
mv dnsmorph /usr/local/go/bin

# Install googler
echo "Installing googler..."
wget https://github.com/jarun/googler/releases/download/v4.3.2/googler_4.3.2-1_ubuntu20.04.amd64.deb
check_error "Failed to download googler"

# Unpack and install the .deb package
dpkg -i googler_4.3.2-1_ubuntu20.04.amd64.deb
check_error "Failed to install googler"

apt-get install -f  # Install any dependencies
check_error "Failed to install googler dependencies"

# Verify if googler is installed
if command -v googler &> /dev/null; then
    echo "googler has been successfully installed."
else
    echo "Failed to install googler. Please check the installation process."
fi
#Installing dnsx 
echo "Installing dnsx.."
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest

#Installing subdomainfinder
echo "Installing subfinder"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest


# Clean up
rm googler_4.3.2-1_ubuntu20.04.amd64.deb
rm dnsmorph_1.2.8_linux_64-bit.tar.gz
rm go1.21.4.linux-amd64.tar.gz
 

