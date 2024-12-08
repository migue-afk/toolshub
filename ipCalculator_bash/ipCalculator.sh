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
	echo -e "${yellowColour}\n[!]${endColour} ${redColour}Ended process\n${endColour} "
	exit 1
}

function helpPanel(){
	echo -e "${yellowColour}\n[!]${endColour} ${redColour}Help Panel\n${endColour} "
	echo -e " ${yellowColour}[+]${endColour} i) ${grayColour}Insert IP address${endColour}"
	echo -e " ${yellowColour}[+]${endColour} m) ${grayColour}Insert Network Mask${endColour}"
	echo -e "\n ${greenColour}Example:${endColour}\n"
	echo -e "	${grayColour}./ipCalculator.sh -i 192.168.100.150${endColour}"
	echo -e "	${grayColour}./ipCalculator.sh -i 192.168.100.150 -m 21${endColour}\n"
}

trap ctrl_c INT

function decToBinary(){
	decimal="$decimal"
	echo -e "$decimal" > report.txt
	for num in $(seq 1 4) ; do
		decBin=$(cat report.txt | awk -v n="$num" -F. '{print $n}')
		decBins=$(echo "obase=2;$decBin" | bc);
		decBins=$(printf "%07d"$decBins)
		echo "$decBins" > report2.txt
			if [ $(cat report2.txt | wc -L) -gt 8 ]; then
				id=$(echo "$(cat report2.txt | wc -L)-8" | bc)
				decBins=${decBins:$id}
			fi
		str="$str$decBins."
	done
	str=${str%?}
	echo -e "\n${purpleColour}ip Binary:${endColour} ${grayColour}$str${endColour} --> ${redColour}$(cat report.txt)${endColour}\n"
	rm report.txt report2.txt
}

function networkId(){

# Shows Ip Address (Decimal to Binary)
	decimal="$decimal"
	echo -e "$decimal" > report.txt
	for num in $(seq 1 4) ; do
		decBin=$(cat report.txt | awk -v n="$num" -F. '{print $n}')
		decBins=$(echo "obase=2;$decBin" | bc);
		decBins=$(printf "%07d"$decBins)
		echo "$decBins" > report2.txt
			if [ $(cat report2.txt | wc -L) -gt 8 ]; then
				id=$(echo "$(cat report2.txt | wc -L)-8" | bc)
				decBins=${decBins:$id}
			fi
		str="$str$decBins."
	done
	str=${str%?}
	echo -e "\n${purpleColour}IP Address:${endColour}  ${grayColour}$str${endColour} --> ${redColour}$(cat report.txt)${endColour}"

# Shows netMask in binary
	mask="$strDc"
	echo -e "$mask" > report.txt
	for num in $(seq 1 4) ; do
		maskBin=$(cat report.txt | awk -v n="$num" -F. '{print $n}')
		maskBins=$(echo "obase=2;$maskBin" | bc);
		maskBins=$(printf "%07d"$maskBins)
		echo "$maskBins" > report2.txt
			if [ $(cat report2.txt | wc -L) -gt 8 ]; then
				id=$(echo "$(cat report2.txt | wc -L)-8" | bc)
				maskBins=${maskBins:$id}
			fi
		strm="$strm$maskBins."
	done
	strm=${strm%?}
	echo -e "${purpleColour}Netmask:${endColour}     ${grayColour}$strm${endColour} --> ${redColour}$(cat report.txt)${endColour}"
	#echo " "

# Shows Network ID
	str=""
	echo -e "$decimal" > report.txt
	echo -e "$mask" > report2.txt
	for num in $(seq 1 4);do
		maskBin=$(cat report.txt | awk -v n="$num" -F. '{print $n}')
		decimalBin=$(cat report2.txt | awk -v n="$num" -F. '{print $n}')
		opAND=$(echo "$(($maskBin & $decimalBin))")
		#echo "$opAND"
		strAND="$strAND$opAND."
#		echo "$decimalBin"
	done
	strAND=${strAND%?}
	echo -e "$strAND" > report.txt
	for num in $(seq 1 4);do
		netID=$(cat report.txt | awk -v n="$num" -F. '{print $n}')
		netIDBin=$(echo "obase=2;$netID" | bc)
		netIDBin=$(printf "%07d"$netIDBin)
		echo "$netIDBin" > report2.txt
		if [ $(cat report2.txt | wc -L) -gt 8 ]; then 
			idNet=$(echo "$(cat report2.txt | wc -L)-8" | bc)
			netIDBin=${netIDBin:$idNet}
		fi
		str="$str$netIDBin."	
	done
	str=${str%?}
	echo -e "\n${purpleColour}Network ID:${endColour}  ${grayColour}$str${endColour} --> ${redColour}$strAND${endColour}"
	echo -e "${purpleColour}Host/Net:${endColour}    ${redColour}$hostNum${endColour}\n"
	rm report.txt report2.txt
}

#-----------------------------------------------
# Variables
#-----------------------------------------------

declare -i parameterCount=0
declare -i secCountIp=0
declare -i secCountMs=0
str=""
strm=""
strAND=""
strDc=""

#-----------------------------------------------
# Program
#-----------------------------------------------

while getopts "i:m:" arg ;do
	case $arg in
	i) decimal=$OPTARG; secCountIp=1;let parameterCount+=1;;
	m) number=$OPTARG; secCountMs=1;let parameterCount+=2;;
esac
done

if [ $parameterCount -eq 1 ]; then
	decToBinary $decimal
elif [ $secCountIp -eq 1 ] && [ $secCountMs -eq 1 ]; then
	number="$number"
	hostNum=$(echo "(2^(32-$number))-2" | bc)
	for num in $(seq 1 $number);do
		strDc="$strDc 1"
	done
	echo "$strDc" > report.txt
	strDc=$(cat report.txt | tr -d ' ')
	strDc=$(printf "%032d"$strDc)
	echo "$strDc" > report.txt
			if [ $(cat report.txt | wc -L) -gt 32 ]; then
				id=$(echo "$(cat report.txt | wc -L)-32" | bc)
				strDc=${strDc:$id}
			fi
	echo "$strDc" | rev > report.txt
	strDc=""
	mskBin=$(echo "$(cat report.txt | cut -c 1-8)")
	mskBin=$(echo "ibase=2;$mskBin" | bc)
	strDc="$strDc$mskBin."
	mskBin=$(echo "$(cat report.txt | cut -c 9-16)")
	mskBin=$(echo "ibase=2;$mskBin" | bc)
	strDc="$strDc$mskBin."	
	mskBin=$(echo "$(cat report.txt | cut -c 17-24)")
	mskBin=$(echo "ibase=2;$mskBin" | bc)
	strDc="$strDc$mskBin."	
	mskBin=$(echo "$(cat report.txt | cut -c 25-32)")
	mskBin=$(echo "ibase=2;$mskBin" | bc)
	strDc="$strDc$mskBin"
	networkId $decimal $strDc
else
	helpPanel
fi


#sleep 10
