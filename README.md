# /home/lab
<table>
  <thead>
    <tr>
      <th>Server</th>
      <th>Docker Services</th>
    </tr>
  </thead>
  <tr>
    <td style="font-weight:bold;">Artemis</td>
    <td><code>pihole</code>, <code>home-assistant</code>, <code>gitea</code></td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Apollo</td>
    <td><code>jellyfin</code>, <code>radarr</code>, <code>sonarr</code>, <code>prowlarr</code>, <code>transmission</code>, <code>glances</code></td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Hermes</td>
    <td><code>backup</code></td>
  </tr>
</table>

## Artemis
```
mkdir -p /home/lab/{pihole,home-assistant}

vim /etc/fstab
UUID={UUID}       /mnt/drive    ext4    defaults        0       2

vim /etc/samba/smb.conf
[data]
path = /madie/drive
writeable = yes
browseable = yes
public = yes
```

| Service | Configuration Steps |
| :--- | :--- |
| **pihole** | <ul><li>internet/account info: use other dns servers</li><li>dhcp/set as local dns server</li><li>update block list</li><li>local dns & cnames</li></ul> |
| **home-assistant** | <ul><li>todo: backup dashboards</li></ul> |


## Apollo
```
mkdir -p /home/lab/{radarr,sonarr,prowlarr,servarr,jellyfin,transmission}
mkdir -p /home/lab/data/{torrents/{shows,movies,music},media/{shows,movies,music}}
```

| Service | Configuration Steps |
| :--- | :--- |
| **jellyfin** | <ul><li>Enable Hardware acceleration: Intel QuickSync (QSV)</li><li>Enable hardware decoding for: H264, HEVC, MPEG2, VC1, VP8, VP9, HEVC 10bit, HEVC RExt 8/10bit, HEVC RExt 12bit</li></ul> |
| **transmission** | <ul><li>Set download folder: `/media/torrents`</li></ul> |
| **prowlarr** | <ul><li>Set download client: `transmission`</li><li>Add application: `radarr` (use API key from Radarr)</li><li>Add application: `sonarr` (use API key from Sonarr)</li></ul> |
| **radarr** | <ul><li>Set download client: `transmission`</li></ul> |
| **sonarr** | <ul><li>Set download client: `transmission`</li></ul> |

## hermes
-   backup (1,2,3)

