#!/bin/bash

mount -o remount,rw /opt/adva

function line()
{
  echo $(date +%T) "- $*" >> ${LOG_FILE} 2>&1
}

cd /opt/adva/qumran/dnx

LOG_FILE=`date '+%y%m%d-%H%M'`
touch ${LOG_FILE}
> ${LOG_FILE}

count=0
while [ 1 -eq 1 ]
do
	count=`expr ${count} + 1`
	line "Test, count=$count"
	
	./load_rmt.sh >> ${LOG_FILE} 2>&1
	sleep 5
done  

exit 0
