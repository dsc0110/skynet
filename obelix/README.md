# ananas

```
mkdir -p {REPODIR}/ananas/appdata/{radarr,sonarr,prowlarr,servarr,jellyfin,transmission}
mkdir -p {REPODIR}/ananas/data/{torrents/{shows,movies,music},media/{shows,movies,music}}
```

## git-shell
```
services:
  git-shell:
    image: alpine:latest
    container_name: git-shell
    command: sleep infinity
    tty: true
    stdin_open: true
    volumes:
      - /volume2/docker/git-shell:/git-alpine
      - /volume1/@home:/git-repos
    ports:
      - "2222:22"
    restart: unless-stopped
```

```
sudo docker exec -it git-shell /bin/sh

apk update
apk add --no-cache git
apk add --no-cache openssh

adduser -D -u ${PUID} -G wheel git
passwd git

/etc/ssh/sshd_config: PubkeyAuthentication yes

ssh-keygen -A
/usr/sbin/sshd
ps aux | grep sshd

su git
cd /git-repos
git init --bare mein-repo.git
```


## jellyfin

-   Hardcare acceleration: Intel QuickSync (QSV)
-   Enable hardware decoding for: H264, HEVC, MPEG2, VC1, VP8, VP9, HEVC 10bit, HEVC RExt 8/10bit, HEVC RExt 12bit

## transmission
-   download folder: /media/torrents

## prowlarr
-   download client: transmission
-   applications: add radarr (api key from radar)
-   applications: add sonarr (api key from sondar)

## radarr
-   download client: transmission

## sonarr
-   download client: transmission

## Todo
 - servarr
 - git @ ugreen