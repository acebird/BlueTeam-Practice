#!/bin/bash

#Set good permissions for common files

echo "Changing permissions for /etc/shadow"
sudo chown root /etc/shadow
sudo chgrp root /etc/shadow
sudo chmod 640 /etc/shadow

echo "Changing permissions for /etc/group"
sudo chown root /etc/group
sudo chgrp root /etc/group
sudo chmod 640 /etc/group

# Change permissions for all config files




#Change permissions for service specific files