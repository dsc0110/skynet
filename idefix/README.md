# r2d2

```
mkdir -p {REPODIR}/r2d2/appdata/{pihole,home-assistant}

vim /etc/fstab
UUID={UUID}       {REPODIR}/r2d2/data    ext4    defaults        0       2

vim /etc/samba/smb.conf
[data]
path = {REPODIR}/r2d2/data
writeable = yes
browseable = yes
public = yes
```

## traefik

### traefik.yml
```
api:
  dashboard: true
  debug: true
entryPoints:
  http:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: https
          scheme: https
  https:
    address: ":443"
serversTransport:
  insecureSkipVerify: true
providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
  # file:
  #   filename: /config.yml
certificatesResolvers:
  cloudflare:
    acme:
      email: my@email.com
      storage: acme.json
      caServer: https://acme-v02.api.letsencrypt.org/directory # prod (default)
      # caServer: https://acme-staging-v02.api.letsencrypt.org/directory # staging
      dnsChallenge:
        provider: cloudflare
        #disablePropagationCheck: true # uncomment this if you have issues pulling certificates through cloudflare, By setting this flag to true disables the need to wait for the propagation of the TXT record to all authoritative name servers.
        #delayBeforeCheck: 60s # uncomment along with disablePropagationCheck if needed to ensure the TXT record is ready before verification is attempted 
        resolvers:
          - "1.1.1.1:53"
          - "1.0.0.1:53"
```

## pihole
-   internet/account info: use other dns servers
-   dhcp/set as local dns server
-   update block list
-   local dns & cnames

## home-assistant
todo: backup dashboards

## Todo
-   traeffik
-   nextcloud
-   rsync nas
-   navidrome
-   webapp
