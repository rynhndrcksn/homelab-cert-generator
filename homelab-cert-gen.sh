#!/usr/bin/env bash
# Generates a wildcard cert to be used with *.home.arpa

# Create the Nginx SSL directory if it doesn’t exist
sudo mkdir -p /etc/nginx/ssl

# Generate the cert and key directly into /etc/nginx/ssl
sudo openssl req -x509 -newkey rsa:4096 \
  -days 3650 \
  -noenc \
  -keyout /etc/nginx/ssl/home.arpa.key \
  -out /etc/nginx/ssl/home.arpa.crt \
  -subj "/CN=*.home.arpa" \
  -addext "subjectAltName=DNS:*.home.arpa" \
  -addext "keyUsage=digitalSignature,keyEncipherment" \
  -addext "extendedKeyUsage=serverAuth"

# Make sure the certs have the right permissions
sudo chmod 600 /etc/nginx/ssl/home.arpa.key
sudo chmod 644 /etc/nginx/ssl/home.arpa.crt
sudo chown root:root /etc/nginx/ssl/home.arpa.*

