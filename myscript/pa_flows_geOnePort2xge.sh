#!/bin/bash
#
# This script is used to create flows for HW test. 
# Please contact Hughes if needed.
# 



# --------------------functions----------------------

function usage()
{
 echo "Usage: `basename $0` [-s src_slot (10ge)] [-p port] [-j src_tm] [-d dst_slot (xge)] [-k dst_tm] [-f output_file]
        -s: source slot (1~24)
        -p: port (1~10)
	-j: TM port for source slot (0~79)
        -d: dest slot (1~24)
	-k: TM port for dest slot (0~79)
	-f: output file name, in .txt format"
 echo "Please contact Hughes if you have trouble using it."	
 exit 1
}

function line()
{
  echo $* >> $FILE
}

function empty_line()
{
  line ""
}

function sleep()
{
 # sleep 2 seconds
  line "#sleep 2000" >> $FILE
}

function title()
{
 line "# This script is used to set up the service for HW group test."
 line "# It creates flows from a port of 10ge card to xge card"
 line "# It does the followings:"
 line "#   service: slot-n,port-n (10ge) <--> slot-n,port-1 (xge)"
 line "#   Note: only 1Gbits traffic bi-di is guaranteed."
 line "#   -----------------------------------------------" 
 line "#   Petra-1 resource usage:"
 line "#     slot-1: voq 1k~2k, schflow 2k~4k"
 line "#       port-1: voq 1k, schflow 2k"
 line "#       port-2: voq 1k+100, schflow 2k+200"
 line "#       port-10: voq 1k+900, schflow 2k+1800"
 line "#     slot-11: voq 11k~12k, schflow 22k~24k"
 line "#     ------------------------------------------"
 line "#   Petra-2 resource usage(symmetrical with Petra-1):"
 line "#     slot-13: voq 1k~2k, schflow 2k~4k"
 line "#      port-1: voq 1k, schflow 2k"
 line "#       port-2: voq 1k+100, schflow 2k+200"
 line "#       port-10: voq 1k+900, schflow 2k+1800"
 line "#     slot-23: voq 11k~12k, schflow 22k~24k "
 line "#     ------------------------------------------"
}

# --------------------start----------------------
FILE=
SRC_SLOT=
SRC_PORT=
DST_SLOT=
SRC_TM_PORT=
DST_TM_PORT=

DST_PORT=1

SRC_SHAPED_SPD=1000000000
DST_SHAPED_SPD=10000000000

while getopts t:s:p:j:d:k:f: opt
do
  case $opt in
    s) SRC_SLOT=$OPTARG
       ;;
    p) SRC_PORT=$OPTARG
       ;;
    j) SRC_TM_PORT=$OPTARG
       ;;
    d) DST_SLOT=$OPTARG
       ;;
    k) DST_TM_PORT=$OPTARG
       ;;
    f) FILE=$OPTARG
       ;;
    ?) usage
       ;;
  esac
done
 
 
# Check output file ------------------------------------------------
if [ -z "$FILE" ];
then
  echo "Error! Please specify the output file."
  usage
fi


# Check the -s, parameters -----------------------------------------
if [ -z "$SRC_SLOT" ]; then
  echo "Error! Please specify the source slot."
  usage
fi
if [ $SRC_SLOT -gt 24 ]; then
  echo "Error! Invalid src slot number: $SRC_SLOT."
  usage
fi

if [ $SRC_SLOT -le 12 ]; then
  SRC_DEV=0
  SRC_SLOT_RELATIVE=$SRC_SLOT
else
  SRC_DEV=1
  ((SRC_SLOT_RELATIVE=$SRC_SLOT - 12))
fi


# Check the -p, parameters -----------------------------------------
if [ -z "$SRC_PORT" ]; then
  echo "Error! Please specify the source port."
  usage
fi
if [ $SRC_PORT -gt 10 ]; then
  echo "Error! Invalid src port num: $SRC_PORT."
  usage
elif [ $SRC_PORT -lt 1 ]; then
  echo "Error! Invalid src port num: $SRC_PORT."
  usage
fi


# Check the -d, parameters -------------------------------------------
if [ -z "$DST_SLOT" ]; then
  echo "Error! Please specify the dest slot."
  usage
fi
if [ $DST_SLOT -gt 24 ]; then
  echo "Error! Invalid dest slot number: $DST_SLOT."
  usage
fi

if [ $DST_SLOT -le 12 ]; then
  DST_DEV=0
  DST_SLOT_RELATIVE=$DST_SLOT
else
  DST_DEV=1
  ((DST_SLOT_RELATIVE=$DST_SLOT - 12))
fi


# Check the -j, parameters ------------------------------------------
if [ -z "$SRC_TM_PORT" ]; then
  echo "Error! Please specify the TM port offset for source slot."
  usage
fi
if [ $SRC_TM_PORT -gt 79 ]; then
  echo "Error! Invalid TM port: $SRC_TM_PORT."
  usage
fi


# Check the -k, parameters ---------------------------------------------
if [ -z "$DST_TM_PORT" ]; then
  echo "Error! Please specify the TM port offset for dest slot."
  usage
fi
if [ $DST_TM_PORT -gt 79 ]; then
  echo "Error! Invalid TM port: $DST_TM_PORT."
  usage
fi



# SLOT_NUM=6

VOQ_QUARTET_BASE=256
VOQ_QUARTET_SPACE=25
SCHFLOW_QUARTET_BASE=512
SCHFLOW_QUARTET_SPACE=50


> $FILE
title

line "connect hal"
line "petra"
empty_line

line "# ============================================================="
line "# Step 1:"
line "#  Set Queue Profile"
line "#  --usage: provQueProfile <profileId> <qsize> <REDEnabled>"
line "# ============================================================="
line "provQueProfile 1 1048576 0"
empty_line
empty_line


line "# ############################################################################"
line "# ############################################################################"
line "# Service created on slot-$SRC_SLOT (10ge) <-->  slot-$DST_SLOT (xge)"
line "# ############################################################################"
line "# ############################################################################"
empty_line

((SRC_SLOT_EID=$SRC_SLOT + 1))
((DST_SLOT_EID=$DST_SLOT + 1))

line "# ============================================================="
line "# Step 2: "
line "#  Set TM port -> NIF/channel mapping"
line "#  --usage: provTmPort <dev> <tm-port> <slot> <port>"
line "#   <dev>:  0~1"
line "#   <tm-port>: 0~79"
line "#   <slot>: 2~25 coressponding to actual slot of 1~24 "
line "#   <port>: 1~10"    
line "# ============================================================="

line "provTmPort $SRC_DEV $SRC_TM_PORT $SRC_SLOT_EID $SRC_PORT"
line "provTmPort $DST_DEV $DST_TM_PORT $DST_SLOT_EID $DST_PORT"
empty_line


line "# ============================================================="
line "# Step 3: "
line "#  Set TM port shaping/scheduling"
line "#  --usage: provPortShaping <dev> <tm-port> <shaped-speed(bps)>"
line "#   <shaped-speed(bps)>:  shaping speed, in bps"
line "# ============================================================="

line "provPortShaping $SRC_DEV $SRC_TM_PORT $SRC_SHAPED_SPD"
sleep
line "provPortShaping $DST_DEV $DST_TM_PORT $DST_SHAPED_SPD"
sleep
empty_line


line "# ============================================================="
line "# Step 4: "
line "#  Set VOQ -> SchFlow mapping"
line "#  --usage: provVoq2SchFlowMapping <dev-of-voq> <voq-qrtt-id> <dev-of-sch-flow> <tm-port> <sch-flow-qrtt-id>"
line "#   <voq-qrtt-id>: voq-id/4"
line "#   <sch-flow-qrtt-id>: sch-flow/4"
line "# ============================================================="
 
((SRC_VOQ_QUARTET=($SRC_SLOT_RELATIVE*$VOQ_QUARTET_BASE) + ($SRC_PORT-1)*$VOQ_QUARTET_SPACE))
((SRC_SCHFLOW_QUARTET=($SRC_SLOT_RELATIVE*$SCHFLOW_QUARTET_BASE) + ($SRC_PORT-1)*$SCHFLOW_QUARTET_SPACE))
 
((DST_VOQ_QUARTET=($DST_SLOT_RELATIVE*$VOQ_QUARTET_BASE) + ($DST_PORT-1)*$VOQ_QUARTET_SPACE))
((DST_SCHFLOW_QUARTET=($DST_SLOT_RELATIVE*$SCHFLOW_QUARTET_BASE) + ($DST_PORT-1)*$SCHFLOW_QUARTET_SPACE))
 
 
line "provVoq2SchFlowMapping $SRC_DEV $SRC_VOQ_QUARTET $DST_DEV $DST_TM_PORT $DST_SCHFLOW_QUARTET"
line "provVoq2SchFlowMapping $DST_DEV $DST_VOQ_QUARTET $SRC_DEV $SRC_TM_PORT $SRC_SCHFLOW_QUARTET"
empty_line


line "# ============================================================="
line "# Step 5: "
line "#  Set SchFlow -> VOQ mapping"
line "#  --usage: provSchFlow2VoqMapping <dev-of-voq> <voq-qrtt-id> <dev-of-sch-flow> <sch-flow-qrtt-id>"
line "# ============================================================="
 
line "provSchFlow2VoqMapping $SRC_DEV $SRC_VOQ_QUARTET $DST_DEV $DST_SCHFLOW_QUARTET"
line "provSchFlow2VoqMapping $DST_DEV $DST_VOQ_QUARTET $SRC_DEV $SRC_SCHFLOW_QUARTET"
empty_line


line "# ============================================================="
line "# Step 6: "
line "#  Set VOQ"
line "#  --usage: provVoq <dev> <voq-id> <profile-id>"
line "# ============================================================="

((SRC_VOQ=(($SRC_SLOT_RELATIVE*$VOQ_QUARTET_BASE) + ($SRC_PORT-1)*$VOQ_QUARTET_SPACE) * 4))
((DST_VOQ=(($DST_SLOT_RELATIVE*$VOQ_QUARTET_BASE) + ($DST_PORT-1)*$VOQ_QUARTET_SPACE) * 4))

line "provVoq $SRC_DEV $SRC_VOQ 1"
line "provVoq $DST_DEV $DST_VOQ 1"
empty_line


line "# ============================================================="
line "# Step 7: "
line "#  Set SchFlow"
line "#  --usage: provSchFlowForAggregate <dev> <tm-port> <sch-flow-id> <cir> <eir> <output-cos>"
line "#   <cir>/<eir>: in bps"
line "#   <output-cos>: 0~7(7 is highest)"
line "# ============================================================="
 
((SRC_SCHFLOW=(($SRC_SLOT_RELATIVE*$SCHFLOW_QUARTET_BASE) + ($SRC_PORT-1)*$SCHFLOW_QUARTET_SPACE) * 4))
((DST_SCHFLOW=(($DST_SLOT_RELATIVE*$SCHFLOW_QUARTET_BASE) + ($DST_PORT-1)*$SCHFLOW_QUARTET_SPACE) * 4))

line "provSchFlowForAggregate $SRC_DEV $SRC_TM_PORT $SRC_SCHFLOW $SRC_SHAPED_SPD $SRC_SHAPED_SPD 7"
line "provSchFlowForAggregate $DST_DEV $DST_TM_PORT $DST_SCHFLOW $DST_SHAPED_SPD $DST_SHAPED_SPD 7"
empty_line
    

unix2dos $FILE 2>/dev/null

exit 0
