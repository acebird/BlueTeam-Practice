#!/bin/bash

#Create directory for Inventory output

mkdir Inventory; cd Inventory;

echo "run nmap"

nmap -sC -sS 127.0.0.1 >> nmap.txt

echo "getting IP"

ip addr >> ip.txt


echo "Finding running services"

ps awfux >> services.txt

cd ~
