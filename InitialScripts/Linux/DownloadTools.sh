#!/bin/bash

if command -v apt >/dev/null 2>&1; then
    install_with_apt
elif command -v dnf >/dev/null 2>&1; then
    install_with_dnf
elif command -v yum >/dev/null 2>&1; then
    install_with_yum
elif command -v pacman >/dev/null 2>&1; then
    install_with_pacman
elif command -v zypper >/dev/null 2>&1; then
    install_with_zypper





install_with_apt() {
    echo "Package Manager is apt"
    
    echo "Installing nmap"
    sudo apt install nmap
    
    echo "Installing audit"


    echo "Installing ufw"
    sudo apt install ufw

    echo "Installing AppArmour"
    sudo apt install apparmour

}


install_with_dnf() {
    echo "Package Manager is dnf"
    
    echo "Installing nmap"
    sudo dnf install nmap
    
    echo "Installing audit"


    echo "Installing ufw"
    sudo dnf install ufw

    echo "Installing AppArmour"
    sudo dnf install apparmour-utils
}

install_with_yum() {
    echo "Package Manager is yum"
    
    echo "Installing nmap"
    sudo yum install nmap
    
    echo "Installing audit"


    echo "Installing ufw"
    sudo yum install ufw

    echo "Installing AppArmour"
    sudo yum install apparmour-utils
}

install_with_pacman() {
    echo "Package Manager is pacman"
    
    echo "Installing nmap"
    sudo pacman -S nmap
    
    echo "Installing audit"


    echo "Installing ufw"
    sudo pacman -S ufw

    echo "Installing AppArmour"
    sudo pacman -S apparmour-utils
}

install_with_zypper() {
    echo "Package Manager is zypper"
    
    echo "Installing nmap"
    sudo zypper install nmap
    
    echo "Installing audit"


    echo "Installing ufw"
    sudo zypper install ufw

    echo "Installing AppArmour"
    sudo zypper install apparmour
}
