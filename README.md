# Homelab Certificate Generator

While working on my homelab I decided that I wanted to implement SSL certificates.
I could've used [Caddy](https://caddyserver.com) or [Traefik](https://traefik.io/traefik) to easily handle this.

However, I wanted to use Nginx to get more comfortable/familiar with it.

## Usage

Clone the file:

```shell
curl https://github.com/rynhndrcksn/homelab-cert-generator/blob/main/homelab-cert-gen.sh -o ~/.local/bin/homelab-cert-gen
```

Ensure it's executable:

```shell
chmod +x ~/.local/bin/homelab-cert-gen
```

Run the script:

```shell
homelab-cert-gen
```

It should work now 🎉

If the script doesn't work then make sure that `$HOME/.local/bin` is in your `$PATH` variable:

```shell
echo $PATH | tr ':' '\n'
# Should have a line like: /Users/<username>/.local/bin
```

If `/Users/<username>/.local/bin` is missing from your `$PATH`, add it by adding the following line in your `.bashrc`/`.zshrc`:

```shell
PATH="$HOME/.local/bin:$PATH"
```

Finally, make sure you add the following to the applicable `server{}` block in your Nginx configuration:

```conf
ssl_certificate     /etc/nginx/ssl/home.arpa.crt;
ssl_certificate_key /etc/nginx/ssl/home.arpa.key;
```

## Frequently Asked Questions

### Why *.home.arpa?

The domain `.home.arpa` was designated for non-unique use in residential home networks: https://www.rfc-editor.org/rfc/rfc8375.html

### Why RSA Certificates?

During testing, I was having difficulties with ed25519 certificates working reliably with Vivaldi on MacOS.
Apparently RSA isn't treated so harshly by the combination and "just works".

## Contributing

This script is fairly simple, but if you can think of a worthwhile improvement to it,
feel free to create an [issue](https://github.com/rynhndrcksn/homelab-cert-generator/issues/new) to discuss it.

## License

This is released under the MIT license, which can be viewed [here](LICENSE).

