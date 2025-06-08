#!/bin/bash

function ctrl_c (){
	echo -e "End Process"
	exit 1
}

trap ctrl_c INT

echo "-------------------------<<<<<<<>>>>>>>>init alpha backup"
if ssh hostC@192.168.0.220 "sudo cryptsetup open /dev/sda namedisk --key-file /root/keyfile"; then
	echo -e "$(date) --------->>><<<<"
	echo "init mount namedisk --> $(date)"
	ssh hostC@192.168.0.220 "sudo mount -t ext4 /dev/mapper/namedisk /mnt/diskbackup/"
	echo "init mount smb --> $(date)"
	sudo mount.cifs //192.168.0.220/rsnapshotRemote /mnt/smbsnap/ -o user=user,pass=passtext #---then use keypass, passtext may present security risks

	echo "init rsnapshot mode alpha --> $(date)"
	/usr/bin/rsnapshot -c /etc/rsnapshot_external.conf alpha
	sleep 10

	echo "umount smb --> $(date)"
	umount /mnt/smbsnap
	echo "restart smb-server remote --> $(date)"	# only if necessary
	ssh hostC@192.168.0.220 "sudo systemctl restart smbd"
	echo "umount namedisk external --> $(date)" 
	ssh hostC@192.168.0.220 "sudo umount /mnt/diskbackup"
	echo "close disk ------------> $(date)"
	ssh hostC@192.168.0.220 "sudo cryptsetup close namedisk"
else
	echo "error /dev/ mount or not found"
fi
