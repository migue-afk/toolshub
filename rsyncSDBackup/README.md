
# rsyncSDBackup

A **Bash script** for performing **automatic mirror-mode backups** using `rsync`.  
It’s designed to synchronize the contents of a local directory with an external storage device (such as an SD card or USB drive).

---

## Features

- Synchronizes files in **mirror mode** (`--delete`): files deleted in the source are also deleted in the destination.  
- Logs all operations for easy tracking.  
- Automatically detects if the external storage is mounted.  
- Calculates the time since the last successful backup.  
- Handles interruptions (`CTRL+C`) gracefully.  

---

##  How It Works

1. The script waits 3 seconds before starting synchronization.  
2. It checks whether the external storage (identified by its **UUID**) is mounted.  
3. If the device **is found**:
   - Executes `rsync` with the `--delete` option to keep an exact mirror copy.
   - Records the date and time of execution in `/opt/scriptbash/rsyncSDBackup/logs.txt`.
   - Updates the timestamp of the last backup in `/opt/scriptbash/rsyncSDBackup/logDate.txt`.
4. If the device **is not found**:
   - Logs the issue in the error file.
   - Calculates the elapsed time since the last successful backup.
   - Saves that info in `/opt/scriptbash/rsyncSDBackup/dateFinal.txt`.

---

## Requirements

- Linux / macOS system with `bash` and `rsync` installed.  
- Write permissions to `/opt/scriptbash/rsyncSDBackup/`.  
- An external storage device mounted under `/run/media/user/<UUID>`.  

---

## Important Variables

```bash
ID_DISK="d7cf9a9e-f7da-43d1-aa06-c78c570fb671"
````

Replace the above value with the **UUID** of your actual external device.  
You can find it by running:

```bash
lsblk -f
```

---

## Recommended Directory Structure

```
/opt/scriptbash/rsyncSDBackup/
│
├── logs.txt           # General log of backup events
├── logDate.txt        # Timestamp of the last successful backup
├── error.log          # Errors or missing storage reports
└── dateFinal.txt      # Time since last successful backup
```

---

## Usage

1. Make the script executable:
    
    ```bash
    chmod +x rsyncSDBackup.sh
    ```
    
2. Run it manually or schedule it with a **cron job** for automation:
    
    ```bash
    crontab -e
    ```
    
    Example (run every day at 2 AM):
    
    ```bash
    0 2 * * * /opt/scriptbash/rsyncSDBackup/rsyncSDBackup.sh
    ```
    

---

## 🧾 Logs & Monitoring

The script generates three types of logs:

|File|Description|
|---|---|
|`logs.txt`|Records successful and failed backups|
|`error.log`|Logs when the external storage is missing or backup fails|
|`dateFinal.txt`|Shows time elapsed since last backup|

---

## Example Output

```
[!] Attention Syncing files in mirror mode on:
     --> 3 second
     --> 2 second
     --> 1 second

--> Running data backup
--> Backup successful
```

---

## Notes

- Use with caution: the `--delete` flag will remove files in the destination that do not exist in the source.
- It’s highly recommended to test with `--dry-run` before running the real backup:

    ```bash
    rsync -av --delete --dry-run /mnt/mountDisk/ /run/media/user/<UUID>
    ```