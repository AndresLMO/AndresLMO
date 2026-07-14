#!/bin/bash

read -p "[+] Enter the absolute path of a file log to analyze: " filelog

if [ ! -f $filelog ]; then
	echo "[+] Path does not exist"
	exit 0 
fi

ERROR_COUNTER=$(grep -c "ERROR" "$filelog")
WARNING_COUNTER=$(grep -c "WARNING" "$filelog")
INFO_COUNTER=$(grep -c "INFO" "$filelog")
declare -A ERRORS_PER_HOUR

for x in $(seq 0 24); do
	ERRORS_PER_HOUR[$x]=$((cat "$filelog" | grep "ERROR" | awk '{print $1}' | awk -F '-' '{print $3}' | awk -F ':' '{print $1}' | awk -F 'T' '{print $2}' | grep -w "$x" | wc -l) 2>/dev/null) 
done



echo "[+] TOTAL ERRORS MESAGGES: $ERROR_COUNTER"
echo "[+] TOTAL WARNINGS MESSAGES: $WARNING_COUNTER"
echo -e "[+] TOTAL INFO MESSAGES: $INFO_COUNTER\n"
echo -e "\n[+] ERRORS PER HOUR"
for x in $(seq 0 24); do
	echo "HOUR: $x | ERRORS: ${ERRORS_PER_HOUR[$x]}"
done


echo -e "\n[+] UNIQUE IPs"
(cat /var/log/syslog | grep -E -o '[0-9][0-9][0-9]\.[0-9][0-9][0-9]\.[0-9][0-9][0-9]\.[0-9][0-9]*' | sort --unique) 2>/dev/null

echo -e "\n[+] LAST 100 LINES OF THE FILE"
cat "$filelog" | tail -n 100 


