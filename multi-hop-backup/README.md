## Description

`multi-hop-backup` is a script designed to automate the creation of backups on multiple servers via SSH (multi-hop backups). It's ideal for environments where access to the hardware where the backups are stored is inaccessible, and for defining scheduled data transfers. It's also focused on low-capacity hardware.

## Features

- **Multi-hop backups**: Transfer data from source to final destination via SSH servers.
- **Cron jobs**: Allows running with a cronjob, allowing the program to perform periodic backups.
- **Use rsync**: Use rsync for greater efficiency in incremental data transfers.

## Requirements

```bash
- Bash
- OpenSSH Client
- Rsnapshot
- Restic
```


For this case, Nextcloud can be ignored or add another administrator or keep the local disk, the goal is to make a local and remote copy, the opensnap and restic directory can be located in any direction, however, I would change the cron job directory, by default all scripts are in `opt`

Cron task structure

```bash
0 1,9,17    * * *   root  /opt/openalpha/open_alpha.sh >> /opt/opensnap/openalpha/log_openalpha 2>&1
```

![](https://github.com/migue-afk/toolshub/blob/master/multi-hop-backup/screenshot/scheme.png)
