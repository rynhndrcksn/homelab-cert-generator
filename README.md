# Homelab Certificate Generator

A simple script to generate self-signed wildcard SSL certificates for homelab environments using `*.home.arpa` domains.

While setting up my homelab, I wanted SSL certificates for local services.
Tools like [Caddy](https://caddyserver.com) and [Traefik](https://traefik.io/traefik) handle this automatically, but I chose Nginx to deepen my familiarity with it.

## Features

- Generates wildcard cert for `*.home.arpa` and bare `home.arpa` domain
- 10-year validity (3650 days)
- RSA 4096-bit key for broad compatibility
- Proper certificate extensions (keyUsage, extendedKeyUsage, SAN)

## Requirements

- `openssl` (typically pre-installed on Linux/macOS)
- Root/sudo access (certificates are written to `/etc/nginx/ssl/`)

## Installation

Download the script:
```shell
curl -fsSL https://raw.githubusercontent.com/rynhndrcksn/homelab-cert-generator/main/homelab-cert-gen.sh -o ~/.local/bin/homelab-cert-gen
```

Make it executable:
```shell
chmod +x ~/.local/bin/homelab-cert-gen
```

Ensure `~/.local/bin` is in your `$PATH`:
```shell
echo $PATH | tr ':' '\n' | grep '.local/bin'
```

If missing, add to `~/.bashrc` or `~/.zshrc`:
```shell
export PATH="$HOME/.local/bin:$PATH"
```

Then reload your shell:
```shell
source ~/.bashrc  # or ~/.zshrc
```

## Usage

Run the script with sudo:
```shell
sudo homelab-cert-gen
```

Output:
```
✓ Certificate generated successfully:
  Key:  /etc/nginx/ssl/home.arpa.key
  Cert: /etc/nginx/ssl/home.arpa.crt
  Valid for 3650 days (~10 years)
```

### Nginx Configuration

Add to your `server {}` block:
```nginx
server {
    listen 443 ssl;
    server_name service.home.arpa;

    ssl_certificate     /etc/nginx/ssl/home.arpa.crt;
    ssl_certificate_key /etc/nginx/ssl/home.arpa.key;

    # Recommended SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Your location blocks...
}
```

### Trusting the Certificate

To avoid browser warnings, add the certificate to your system's trust store:

**macOS:**
```shell
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /path/to/cert/home.arpa.crt
```

**Linux (Debian/Ubuntu):**
```shell
sudo cp /path/to/cert/home.arpa.crt /usr/local/share/ca-certificates/home.arpa.crt
sudo update-ca-certificates
```

**Windows:**
Import the `.crt` file via `certmgr.msc` → Trusted Root Certification Authorities

## FAQ

### Why `*.home.arpa`?

The `.home.arpa` domain is [officially designated](https://www.rfc-editor.org/rfc/rfc8375.html) for non-unique use in residential networks.
Unlike `.local` (reserved for mDNS), `.home.arpa` is safe for standard DNS resolution.

### Why RSA instead of Ed25519?

RSA 4096 offers broader compatibility with older browsers and devices.
During testing, Ed25519 certificates had reliability issues with Vivaldi on macOS, while RSA "just works" across platforms.

### How do I regenerate the certificate?

Simply re-run the script. The existing certificate will be overwritten.

### Can I use a different domain?

Yes. Edit the `DOMAIN` variable in the script before running:
```bash
readonly DOMAIN="your-domain.local"
```

## Contributing

This is a simple utility script, but improvements are welcome!
Please [open an issue](https://github.com/rynhndrcksn/homelab-cert-generator/issues/new) to discuss changes before submitting a PR.

## License

Released under the [MIT License](LICENSE).
