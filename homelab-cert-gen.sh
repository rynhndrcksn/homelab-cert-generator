#!/usr/bin/env bash
# Generates a wildcard cert to be used with *.home.arpa

set -euo pipefail

# Generates a wildcard cert for *.home.arpa with SAN entry for bare domain
# Usage: ./generate-ssl-cert.sh

readonly SSL_DIR="/etc/nginx/ssl"
readonly DOMAIN="home.arpa"
readonly CERT_FILE="${SSL_DIR}/${DOMAIN}.crt"
readonly KEY_FILE="${SSL_DIR}/${DOMAIN}.key"
readonly DAYS_VALID=3650

# Check if running as root (avoids repeated sudo)
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo" 
   exit 1
fi

# Create SSL directory
mkdir -p "${SSL_DIR}"

# Generate certificate
openssl req -x509 -newkey rsa:4096 \
  -days "${DAYS_VALID}" \
  -noenc \
  -keyout "${KEY_FILE}" \
  -out "${CERT_FILE}" \
  -subj "/CN=*.${DOMAIN}" \
  -addext "subjectAltName=DNS:*.${DOMAIN},DNS:${DOMAIN}" \
  -addext "keyUsage=critical,digitalSignature,keyEncipherment" \
  -addext "extendedKeyUsage=serverAuth"

# Set permissions
chmod 600 "${KEY_FILE}"
chmod 644 "${CERT_FILE}"
chown root:root "${KEY_FILE}" "${CERT_FILE}"

echo "✓ Certificate generated successfully:"
echo "  Key:  ${KEY_FILE}"
echo "  Cert: ${CERT_FILE}"
echo "  Valid for ${DAYS_VALID} days (~10 years)"
