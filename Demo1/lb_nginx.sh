#!/bin/bash
apt update -y
apt full-upgrade -y
apt install nginx -y
systemctl stop nginx
rm /etc/nginx/nginx.conf
echo "Sehr Gut!"
