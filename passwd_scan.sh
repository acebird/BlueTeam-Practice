#!/bin/bash

echo "===== Password Security Audit ====="

SUMMARY=""

prompt_reinstall() {
    read -p "Do you want to reinstall the binary? (y/n): " choice
    case "$choice" in
        y|Y )
            apt-get install --reinstall -y "$1"
            ;;
        * )
            echo "[i] Skipping reinstall of $1"
            ;;
    esac
}

check_package() {
    PKG=$1
    echo ""
    echo "===== Checking $PKG ====="
    OUTPUT=$(dpkg -V "$PKG" 2>&1)

    if [[ -z "$OUTPUT" ]]; then
        echo "the dpkg output is: (no output - clean)"
        SUMMARY+="[OK] $PKG clean\n"
    else
        echo "the dpkg output is:"
        echo "$OUTPUT"
        SUMMARY+="[WARN] $PKG modified\n"
        prompt_reinstall "$PKG"
    fi
}

# Step 1: Check passwd, sudo, login
check_package "passwd"
check_package "sudo"
check_package "login"

# Step 2: PAM Security Check
echo ""
echo "===== Running PAM Security Check ====="

ISSUES=0

check_line() {
    FILE=$1
    PATTERN=$2
    MESSAGE=$3
    if grep -q "$PATTERN" "$FILE" 2>/dev/null; then
        echo "[!!] $MESSAGE ($FILE)"
        ((ISSUES++))
    fi
}

check_missing() {
    FILE=$1
    PATTERN=$2
    MESSAGE=$3
    if ! grep -q "$PATTERN" "$FILE" 2>/dev/null; then
        echo "[!!] MISSING: $MESSAGE in $FILE"
        ((ISSUES++))
    fi
}

echo "[+] Checking for NULL passwords allowed..."
check_line "/etc/pam.d/common-password" "nullok" "nullok detected → Allows blank passwords"

echo "[+] Checking for pam_permit"
check_line "/etc/pam.d/common-auth" "pam_permit.so" "pam_permit found → Unconditional access risk"

echo "[+] Checking password hashing strength..."
check_missing "/etc/pam.d/common-password" "pam_unix.so.*sha512" "SHA512 hashing"

echo "[+] Checking password quality enforcement..."
check_missing "/etc/pam.d/common-password" "pam_pwquality.so\|pam_cracklib.so" "Password quality module"

echo "[+] Checking brute-force mitigation..."
check_missing "/etc/pam.d/common-auth" "pam_tally2.so\|pam_faillock.so" "Failed attempt lockout"

echo "[+] Checking sudo permissions..."
check_line "/etc/pam.d/sudo" "pam_permit.so" "sudo bypass issue"

if [[ $ISSUES -eq 0 ]]; then
    echo "[✔] PAM configuration seems secure"
    SUMMARY+="[OK] PAM config clean\n"
else
    echo "[⚠] $ISSUES PAM issues found"
    SUMMARY+="[WARN] PAM issues detected: $ISSUES\n"
fi

# Step 3: Scan for unusual PAM modules
echo ""
echo "===== Scanning PAM Modules ====="

KNOWN_DIRS="/lib/security /lib/x86_64-linux-gnu/security"
SUSPICIOUS=0

for file in /etc/pam.d/*; do
    grep -oP '\S+\.so' "$file" 2>/dev/null | while read -r module; do
        FOUND=0
        for dir in $KNOWN_DIRS; do
            if [[ -f "$dir/$module" ]]; then
                FOUND=1
            fi
        done
        if [[ $FOUND -eq 0 ]]; then
            echo "[!!] Suspicious module: $module referenced in $file"
            SUSPICIOUS=1
        fi
    done
done

if [[ $SUSPICIOUS -eq 1 ]]; then
    SUMMARY+="[WARN] Suspicious PAM modules found\n"
    read -p "Reinstall pam modules? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        apt-get install --reinstall -y libpam-modules libpam-runtime
    fi
else
    SUMMARY+="[OK] PAM modules appear normal\n"
fi

# Step 4: Search for passwd hijacking (ignore output file and prioritize autorun)
echo ""
echo "===== Searching for passwd hijacking ====="

OUTPUT_FILE="./passwd_search_results.txt"

# All grep results excluding the output file itself
ALL_RESULTS=$(grep -R --exclude="$(basename "$OUTPUT_FILE")" "passwd" /root /home /etc 2>/dev/null)

# Save everything to a file
echo "$ALL_RESULTS" > "$OUTPUT_FILE"

# Filter potential autorun files
AUTORUN_RESULTS=$(echo "$ALL_RESULTS" | grep -E "(\.bashrc|\.bash_profile|\.profile|/etc/profile|/etc/bash\.bashrc|/etc/cron|/var/spool/cron)" || echo "[None found]")
OTHER_RESULTS=$(echo "$ALL_RESULTS" | grep -vE "(\.bashrc|\.bash_profile|\.profile|/etc/profile|/etc/bash\.bashrc|/etc/cron|/var/spool/cron)" || echo "[None found]")

# Display to user
echo ""
echo "[+] Potential autorun files containing 'passwd':"
echo "$AUTORUN_RESULTS"

echo ""
echo "[+] Other files containing 'passwd':"
echo "$OTHER_RESULTS"

# Add to SUMMARY, autorun hits first
SUMMARY+="[INFO] passwd search completed; autorun files flagged separately\n"
SUMMARY+="[AUTORUN FILES]\n$AUTORUN_RESULTS\n"
SUMMARY+="[OTHER FILES]\n$OTHER_RESULTS\n"



# Step 5: Environment checks
echo ""
echo "===== Environment Check ====="

echo "PATH is:"
echo "$PATH"

echo ""
echo "LD_PRELOAD is:"
echo "$LD_PRELOAD"

SUMMARY+="[INFO] PATH and LD_PRELOAD checked\n"

# Step 6: Summary
echo ""
echo "===== SUMMARY ====="
echo -e "$SUMMARY"

echo -e "$SUMMARY" > ./password_scan

echo "Report saved to ./password_scan"
echo "===== Completed ====="
