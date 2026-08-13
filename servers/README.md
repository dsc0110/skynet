# ares

```
mkdir -p /home/skynet/{radarr,sonarr,prowlarr,servarr,jellyfin,transmission}
mkdir -p /home/skynet/data/{torrents/{shows,movies,music},media/{shows,movies,music}}
```

## jellyfin

-   Hardware acceleration: Intel QuickSync (QSV)
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


# helios

```
mkdir -p /home/skynet/{pihole,home-assistant}

vim /etc/fstab
UUID={UUID}       /home/skynet/data    ext4    defaults        0       2

vim /etc/samba/smb.conf
[data]
path = /home/skynet/data
writeable = yes
browseable = yes
public = yes
```

## pihole
-   internet/account info: use other dns servers
-   dhcp/set as local dns server
-   update block list
-   local dns & cnames

## home-assistant
todo: backup dashboards