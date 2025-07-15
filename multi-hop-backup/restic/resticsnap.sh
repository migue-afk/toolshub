#!/bin/bash

function ctrl_c (){
	echo -e "End Process"
	exit 1
}

trap ctrl_c INT

namerepo=/yournamerepo  #name of you reposiry, example ./restic0 or /mnt/diskA/resctic0
backup_directory=/yourbackupdirectory #direcotory to backup, example /mnt/disk500 or /home/user or /etc

echo ">>>>>><<<<<<------ init restic backup ------>>>>>><<<<<"
echo "$(date)"

# backup restic

restic -r $namerepo --verbose backup /mnt/disk500GB --password-file /keypass
restic -r $namerepo --verbose backup /home/$USER/ --password-file /keypass
restic -r $namerepo --verbose backup /etc --password-file /keypass
echo ">>>>><<<<<<<----- backup finish $(date)"




