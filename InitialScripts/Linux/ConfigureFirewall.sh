#!/bin/bash

# Check if ufw is installed
if command -v ufw &> /dev/null; then
    configure_ufw
# If ufw is not installed, check for iptables
elif command -v iptables &> /dev/null; then
    configure_iptables
else
    echo "Neither ufw nor iptables are installed. Please install one of them to proceed."
    exit 1
fi

echo "Firewall configuration complete. Allow all outbound if you need internet connection. The default for this script is to deny all but the necessary outbound traffic."

configure_ufw() {
    echo "UFW is installed. Setting up firewall rules..."
    # Reset existing UFW rules
    sudo ufw reset
    sudo ufw default deny incoming
    sudo ufw default deny outgoing

    #Prompt User to set SSH
    echo "Do you want to allow SSH (Y/N)?"
    read -r answer

    if [[ "${answer,,}" == "y" ]]; then
        echo "yes"
        sudo ufw allow ssh
    else
        echo "You chose NO. IF YOU MEANT TO SAY YES ADD PORT 22 ON REQUESTED PORTS!!!!"
    fi


    # Ask the user which ports to open
    echo "Enter the ports you want to open (space-separated):"
    read -r ports

    # check for ftp and open passive ports
    if [[ "$ports" =~  "21" ]]; then
        echo "add passive port 40000-50000"
        sudo ufw allow 40000:50000/tcp
    fi

    # Open the specified ports
    for port in $ports; do
        echo "Allowing traffic on port $port..."
	
	if [[ "$port" == "53" ]]; then
            echo "DNS is UDP"
            sudo ufw allow $port/udp
	else
	    sudo ufw allow $port/tcp
        fi

    done

    sudo ufw enable
    sudo ufw status verbose


    echo "If you need internet access run 'sudo ufw default allow outgoing' but understand it will allow ALL outgoing so don't keep it permanently"
}


configure_iptables() {
    echo "iptables is installed. Setting up firewall rules..."
    # Flush existing iptables rules
    sudo iptables -P INPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT
    sudo iptables -P OUTPUT ACCEPT
    sudo iptables -t nat -F
    sudo iptables -t mangle -F
    sudo iptables -F
    sudo iptables -X

    #Prompt User to set SSH
    echo "Do you want to allow SSH (Y/N)?"
    read -r answer

    if [[ "${answer,,}" == "y" ]]; then
	echo "yes"
	sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
        sudo iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
    else
	echo "You chose NO. IF YOU MEANT TO SAY YES ADD PORT 22 ON REQUESTED PORTS!!!!"
    fi

    # Ask the user which ports to open
    echo "Enter the ports you want to open (space-separated):"
    read -r ports

    # check for ftp and open passive ports
    if [[ "$ports" =~  "21" ]]; then
        echo "add passive port 40000-50000"
        sudo iptables -A OUTPUT -p tcp --match multiport --sports 40000:50000 -j ACCEPT
	sudo iptables -A INPUT -p tcp --match multiport --dports 40000:50000 -j ACCEPT
    fi

    # Open the specified ports
    for port in $ports; do
        echo "Allowing traffic on port $port..."
        sudo iptables -A INPUT -p tcp --dport $port -j ACCEPT
        sudo iptables -A OUTPUT -p tcp --sport $port -j ACCEPT
    done

    # Set default policies to deny incoming and outgoing traffic
    sudo iptables -P INPUT DROP
    sudo iptables -P OUTPUT DROP


    sudo iptables -L -v

}