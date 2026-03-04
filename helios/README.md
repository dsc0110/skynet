# helios

```
mkdir -p {REPODIR}/helios/appdata/{pihole,home-assistant}

vim /etc/fstab
UUID={UUID}       {REPODIR}/helios/data    ext4    defaults        0       2

vim /etc/samba/smb.conf
[data]
path = {REPODIR}/helios/data
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
