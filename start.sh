#!/bin/bash

#Update package list
sudo apt-get update

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    sudo apt-get install -y docker
    echo "Docker installed successfully."
else
    echo "Docker is already installed."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    sudo apt-get install -y docker-compose
    echo "Docker Compose installed successfully."
else
    echo "Docker Compose is already installed."
fi

#Install go

# URL of the file to be downloaded
go_url="https://go.dev/dl/go1.22.0.linux-amd64.tar.gz"

# Name of the file to be downloaded
file_name="go1.22.0.linux-amd64.tar.gz"


# Full path to the file in the home directory
full_path="$HOME/$file_name"


# Check if the file already exists
if [ -e "$full_path" ]; then
    echo "File already exists: $full_path"
    echo "No need to download again."
else
    # Use wget to download the file
    wget "$go_url"
    echo "Download complete."
fi


# Check if Go is already installed in /usr/local
go_install_dir="/usr/local/go"



sudo tar -C /usr/local -xzf "$full_path"
echo "Go extracted to $go_install_dir"


export GOPATH="$HOME/go"

# Check if Go is installed in /usr/local
if [ -d "$go_install_dir" ]; then
    # Add Go binary directory to PATH
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc


    # Source the updated profile
    source ~/.bashrc

    echo "Go environment variables added to ~/.bashrc"
else
    echo "Go is not installed properly. Exiting script with an error."
    exit 1
fi

#Install libdevmapper-dev
libdevmapper_package="libdevmapper-dev"

# Check if the package is installed
if dpkg -l | grep -q $libdevmapper_package; then
    echo "$libdevmapper_package is already installed."
else
    # Install the package
    sudo apt-get install -y $libdevmapper_package
    echo "$libdevmapper_package installed successfully."
fi

pkg_config_file="/usr/lib/x86_64-linux-gnu/pkgconfig/devmapper.pc"

if [[ -z "$PKG_CONFIG_PATH" || ! "$PKG_CONFIG_PATH" =~ .*"$pkg_config_file".* ]]; then
    export PKG_CONFIG_PATH="$pkg_config_file:$PKG_CONFIG_PATH"
    echo "Exported $env_variable: $PKG_CONFIG_PATH"
    source ~/.bashrc
else
    echo "$env_variable is already set with $pkg_config_file."
fi

# Install libbtrfs-dev
libbtrfs_package="libbtrfs-dev"

# Check if the package is installed
if dpkg -l | grep -q $libbtrfs_package; then
    echo "$libbtrfs_package is already installed."
else
    # Install the package
    sudo apt-get install -y $libbtrfs_package
    echo "$libbtrfs_package installed successfully."
fi


#Install pkg-config
pkg_config_package="pkg-config"

# Check if the package is installed
if dpkg -l | grep -q $pkg_config_package; then
    echo "$pkg_config_package is already installed."
else
    # Install the package
    sudo apt-get install -y $pkg_config_package
    echo "$pkg_config_package installed successfully."
fi


# Check if s2i command is available
if command -v s2i &> /dev/null; then
    echo "s2i is already installed."
else
    # Install s2i using go install
    go install github.com/openshift/source-to-image/cmd/s2i@latest
fi


# Check if jq is installed
if command -v jq &> /dev/null; then
    echo "jq is already installed."
else
    # Install jq
    sudo apt-get install -y jq
    echo "jq installed successfully."
fi

# Check if ngrok is installed
if command -v ngrok &> /dev/null; then
    echo "ngrok is already installed."
else
    # Install ngrok
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
    sudo apt update
    sudo apt install ngrok
    echo "ngrok installed successfully."
fi


# Set the default username to 'ubuntu' or use the provided argument
username=${1:-ubuntu}

# Add the user to the 'docker' group
sudo usermod -aG docker $username

echo "User '$username' added to the 'docker' group."


#Add s2i to visudo file

s2i_location=$(which s2i)

if [ -z "$s2i_location" ]; then
    echo "s2i is not installed or not in the PATH. There is some error"
    exit 1    
else
    echo "s2i is installed at: $s2i_location"
    echo "Run sudo visudo command. And add the location in secure path after adding : to the final path"
fi

