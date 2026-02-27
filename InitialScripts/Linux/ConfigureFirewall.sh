#!/bin/bash

flush_rules() {
    echo "Flushing iptables rules..."

    sudo iptables -P INPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT
    sudo iptables -P OUTPUT ACCEPT
    sudo iptables -t nat -F
    sudo iptables -t mangle -F
    sudo iptables -F
    sudo iptables -X

    echo "iptables rules flushed."
}

configure_iptables() {

# Flush existing rules
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X

# Allow loopback
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Stateful tracking
iptables -A INPUT  -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

#Ask User about allowing SSH
echo "Do you want to allow SSH (Y/N)?"
read -r answer

if [[ "${answer,,}" == "y" ]]; then
    echo "yes"
    sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
else
    echo "You chose NO. IF YOU MEANT TO SAY YES ADD PORT 22 ON REQUESTED PORTS!!!!"
fi

# Ask the user which ports to open
echo "Enter the ports you want to open (space-separated):"
read -r ports

for port in $ports; do
    echo "Allowing traffic on port $port..."
    sudo iptables -A INPUT -p tcp --dport $port -m conntrack --ctstate NEW -j ACCEPT
done

# Outbound DNS
iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

# Outbound web (HTTP/HTTPS)
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW -j ACCEPT

# Optional: outbound ping
iptables -A OUTPUT -p icmp --icmp-type echo-request -m conntrack --ctstate NEW -j ACCEPT

#Default Deny
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

echo "iptables configuration complete."
}

# --------------------
# Main Menu
# --------------------

echo "What would you like to do?"
echo "1. Flush iptables rules"
echo "2. Disable firewalld"
echo "3. Configure IP tables"
read -rp "Enter choice (1-3): " choice

case "$choice" in
    1)
        flush_rules
        ;;
    2)
        echo "Disabling firewalld..."
        sudo systemctl disable --now firewalld
        echo "firewalld disabled."
        ;;
    3)
        configure_iptables
        ;;
    *)
        echo "Invalid option."
        exit 1
        ;;
esac
