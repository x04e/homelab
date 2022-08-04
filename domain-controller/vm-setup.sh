#!/bin/sh

read -p "Enter your new hostname: " hn
hostnamectl set-hostname "$hn"

read -p "Enter realm to join (e.g. example.internal): " rl
realm join "$rl"

sed -i \
    -e 's/use_fully_qualified_names.*/use_fully_qualified_names = False/g;' \
    -e 's/fallback_homedir.*/fallback_homedir=\/home\/%u/g;' \
    /etc/sssd/sssd.conf

# Required property for automatic DNS registration for domain controller
# (Possibly only needed when using short hostname without domain component?)
echo "ad_hostname = $hn.$rl" >> /etc/sssd/sssd.conf

systemctl restart sssd

