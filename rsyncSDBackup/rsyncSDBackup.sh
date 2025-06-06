#!/bin/bash
#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c (){
	echo -e "\n End Process"
	exit 1
}

trap ctrl_c INT
	
echo -e "\n [!] Attention Syncing files in mirror mode on:"

for num in $(seq 1 3) ; do
	result=$((3 - num))
	echo -ne "\r\t --> $result second"
	sleep 1
done

if [[ -d /run/media/user/d7cf9a9e-f7da-43d1-aa06-c78c570fb671/ ]]; then
	
	echo "Script Executed --> $(date)" >> /opt/scriptbash/rsyncSDBackup/logs.txt
	echo "lastBackup:$(date +%s)" >> /opt/scriptbash/rsyncSDBackup/logDate.txt
	echo "⏳ Running data backup" >> /opt/scriptbash/rsyncSDBackup/logs.txt

		if rsync -av --delete /mnt/mountDisk/adata250GB/NextCloud/ssd500GB/ /run/media/abig4m/d7cf9a9e-f7da-43d1-aa06-c78c570fb671/; then
		echo "✅ Backup successful" >> /opt/scriptbash/rsyncSDBackup/logs.txt
			else
    				echo "⚠️ BACKUP FAILED" >> /opt/scriptbash/rsyncSDBackup/logs.txt
		fi
		exit 0

else
	echo "♻️ Storage_Found_No_Backup" >> /opt/scriptbash/rsyncSDBackup/logs.txt
	echo " [!] Storage not found --> $(date) " >> /opt/scriptbash/rsyncSDBackup/error.log
	Last=$(tail -n 1 /opt/scriptbash/rsyncSDBackup/logDate.txt | grep "lastBackup" | awk -F: '{print $NF}' | xargs)
	Current=$(date +%s)
	lastBackup=$(($Current - $Last))
	Hours=$(($lastBackup / 3600))
	Minutes=$((($lastBackup % 3600)/60))
	days=$(($lastBackup / 86400))
	daysH=$((($Hours-(($Hours/24)*24)))) #ModelMatematic
	daysM=$(($Minutes % 60))
	#Model Mathematic
	#Minutes1=$(((($lastBackup / 3600) * 3600)-$lastBackup)) #take into absolute values
	#echo "$lastBackup"
	echo "($Hours:$Minutes)" >> /opt/scriptbash/rsyncSDBackup/dateFinal.txt
		if [ $Hours -gt 23 ]; then
			echo "(${days}d ${daysH}h:${daysM}m)" >> /opt/scriptbash/rsyncSDBackup/dateFinal.txt
		fi
	exit 1
fi

