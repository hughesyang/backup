#!/bin/bash

set -e

function kill_process()
{
    local NAME=$1
	ID=`ps -ef | grep ${NAME} | grep -v "grep" | awk '{print $2}'`
	if [ ${ID} ]; then
		echo "To kill ${NAME}..."
		echo "---------------"
		for id in $ID
		do
			kill -9 $id
			echo "killed $id"
		done
		echo "---------------"
	fi
}

function umount_sth()
{
    local NAME=$1
	if [ -d ${NAME} ]; then
		echo "To umount ${NAME}..."
		ID=`lsof ${NAME} | awk '{print $2}'`
		echo "---------------"
		for id in $ID
		do
			kill -9 $id
			echo "killed $id"
		done
		echo "---------------"
	
		# umount
		umount ${NAME}
		
		# rename
		mv ${NAME} ${NAME}_bak
	fi
}

# kill log
kill_process rsyslogd

# umount tracelog and rename
umount_sth /var/opt/adva/aos/log/tracelog



