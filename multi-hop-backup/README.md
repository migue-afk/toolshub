## Script to backup the main disk to a local disk B and a remote disk C

For this case, Nextcloud can be ignored or add another administrator or keep the local disk, the goal is to make a local and remote copy, the opensnap and restic directory can be located in any direction, however, I would change the cron job directory, by default all scripts are in `opt` 

```bash
/opt/openalpha/open_alpha.sh >> opensnap/openalpha/log_openalpha 2>&1
```

![](https://github.com/migue-afk/toolshub/blob/master/multi-hop-backup/screenshot/scheme.png)
