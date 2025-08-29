#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use sudo."
    exit 1
fi

printf "Which Script would you like to run?\n1. Change Passwords\n2. Download Tools\n3. Get Inventory\n4. Create Backups\n5. Enable Logging\n6. Configure Firewall\n7. Run All"

read -r "Which number would you like to run?" option

case $option in
    1)
        echo "Running Change Passwords Script"
        ./ChangePasswords.sh
        ;;
    2)
        echo "Runnning Dowload Tools Script"
        ./DownloadTools.sh
        ;;
    3)
        echo "Running Get Inventory Script"
        ./GetInventory.sh
        ;;
    4)
        echo "Running Create Backups Script"
        ./CreateBackups.sh
        ;;
    5)
        echo "Running Enable Logging Script"
        ./EnableLogging.sh
        ;;
    6)
        echo "Running Configure Firewall Script"
        ./ConfigureFirewall.sh
        ;;
    7)
        echo "Running Change Passwords Script"
        ./ChangePasswords.sh

        echo "Runnning Dowload Tools Script"
        ./DownloadTools.sh

        echo "Running Get Inventory Script"
        ./GetInventory.sh

        echo "Running Create Backups Script"
        ./CreateBackups.sh

        echo "Running Enable Logging Script"
        ./EnableLogging.sh

        echo "Running Configure Firewall Script"
        ./ConfigureFirewall.sh
        ;;