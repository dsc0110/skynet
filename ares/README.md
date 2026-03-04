# ares

```
mkdir -p {REPODIR}/ares/appdata/{radarr,sonarr,prowlarr,servarr,jellyfin,transmission}
mkdir -p {REPODIR}/ares/data/{torrents/{shows,movies,music},media/{shows,movies,music}}
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
