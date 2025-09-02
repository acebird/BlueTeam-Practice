#!/bin/bash

#create backups folder
mkdir /etc/backups

#backup all of etc to cover config files and such
echo "Backing up /etc"
cp -r /etc /etc/backups/etc_backup

#backup home directories
echo "Backing up /home"
cp -r /home /etc/backups/home_backup

#backup web data
echo "Backing up /var/www"
cp -r /var/www /etc/backups/var/www_backup

echo "List any additional directories you wish to backup (space separated)"
read -r directories

for directory in $directories; do
    echo "Backing up $directory"
    cp -r $directory /etc/backups/
done