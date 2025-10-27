#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

# Custom homepage
echo "<h1>Hello from GCP NGINX Server </h1>" > /var/www/html/index.nginx-debian.html
