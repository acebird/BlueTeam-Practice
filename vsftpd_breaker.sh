#!/usr/bin/env bash
set -e

echo "[*] Breaking vsftpd lab environment"

########################################
# Must be root
########################################
if [[ $EUID -ne 0 ]]; then
  echo "Run as root"
  exit 1
fi

########################################
# 1. Replace /etc/vsftpd.conf contents
########################################

cat > /etc/vsftpd.conf << 'EOF'
# Example config file /etc/vsftpd.conf
listen=NO
listen_port=2121
listen_ipv6=YES
anonymous_enable=NO
local_enable=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
local_root=/var
chroot_local_user=YES
chroot_local_user=NO
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd_broken
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=YES
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000
EOF

########################################
# 2. Rename to /etc/vsftpd.config
########################################

mv -f /etc/vsftpd.conf /etc/vsftpd.config

########################################
# 3. Comment out files
########################################

comment_file () {
  FILE="$1"
  if [[ -f "$FILE" ]]; then
    sed -i 's/^[^#]/#&/' "$FILE"
  fi
}

comment_file /etc/pam.d/other
comment_file /etc/pam.d/vsftpd
comment_file /lib/systemd/system/vsftpd.service

########################################
# 4. Replace runtime directory with file
########################################

rm -rf /var/run/vsftpd
touch /var/run/vsftpd

echo "[*] Done. vsftpd should be very broken now."
