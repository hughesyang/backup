#!/bin/bash
#
# This script is used to create a certain number of FPs under a given slot's port, which can be used later 
# on by debugTool under SAF/NCM. In addition, the maximum 8 Policer/Shaper pe FP are created along with the FP.
# Normally it is useful for stress test. 
# 
# syntax: crtfp <slot> <port> <start> <number> <to file>
#	-slot: logical port corresponding to real slot as seen from GUI
#	-port: port number 1 ~ 10
#	-fp number: the number of fp to be created
#	-to file: the output file name
#
# example: crtFp 1 1 1 2000 test.txt


function usage()
{
 echo "Incomplete comamnd!
  Usage: crtfp <slot> <port> <start> <number> <file name>
	-slot: slot number 1-24 (real slot number)
	-port: port number 1-10
	-start: start index. 1-4000
	-fp number: the number of fp to be created. 1-4000
 	-to file: the output file name, in .txt format"
}

function sleep()
{
 # sleep 1 seconds
 echo "sleep 1000" >>$FILE
}


# --------------------------------------------------

SLOT=`expr $1 + 1`
PORT=$2
START=$3
NUMBER=$4
FILE=$5

if [ $# -ne "5" ]; then
   usage
   exit
fi

> $FILE

for ((fp=$START; fp<`expr $START + $NUMBER`; fp++))
do
    echo "ent-fp 1 1 $SLOT $PORT $fp 4" >> $FILE
    sleep

    for ((policer=1; policer<=8; policer++))
    do
        echo "ent-policerv2 1 1 $SLOT $PORT $fp $policer 4" >> $FILE
        sleep
    done

    for ((shaper=1; shaper<=8; shaper++))
    do
        echo "ent-shaperv2 1 1 $SLOT $PORT $fp $shaper 4" >> $FILE
        sleep
    done

done

unix2dos $FILE 2>/dev/null

exit 0
