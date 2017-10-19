#!/bin/bash
#
# This script is used to create flows for HW test. 
# Please contact Hughes if needed.
# 



# --------------------functions----------------------

function usage()
{
 echo "Usage: `basename $0` [-t type] [-s src_slot] [-d dst_slot] [-j src_tm_offset] [-k dst_tm_offset] [-f output_file]
        -t: 10ge for 10GE card, xge for 1XGE card
        -s: source slot (1~24)
        -d: dest slot (1~24)
	-j: TM port offset for source slot (0~79)
	-k: TM port offset for dest slot (0~79)
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
 line "# This script is used to set up the service via debug I/F."
 line "# Please contact Hughes if you have trouble using it."
 line "# --------------------------------------------------" 
 line "# It creates flows cross Petra based on card type"
 line "# It does the followings:"
 line "#   service-1: slot-1,port1 <--> slot-13,port-1"
 line "#   service-2: slot-1,port2 <--> slot-13,port-2"
 line "#   ..."
 line "#   service-10: slot-1,port3 <--> slot-13,port-3"
 line "#   service-11: slot-3,port1 <--> slot-15,port-1"
 line "#   service-12: slot-3,port2 <--> slot-15,port-2"
 line "#   ..."
 line "#   service-61: slot-11,port1 <--> slot-23,port-1" 
 line "#   ..." 
 line "#   service-70: slot-11,port10 <--> slot-23,port-10" 
 line "#   -----------------------------------------------" 
 line "#   Petra-1 resource usage:"
 line "#     slot-1: voq 1k, schflow 2k"
 line "#       port-1: voq 1k, schflow 2k"
 line "#       port-2: voq 1k+8, schflow 2k+16"
 line "#       port-10: voq 1k+72, schflow 2k+144"
 line "#     slot-2: voq 1k+80, schflow 2k+160"
 line "#     ..."
 line "#     ------------------------------------------"
 line "#   Petra-2 resource usage(symmetrical with Petra-1):"
 line "#     ------------------------------------------"
}

# --------------------start----------------------
CARD_TYPE=
FILE=
SRC_SLOT=
DST_SLOT=
SRC_TM_BASE=
DST_TM_BASE=

while getopts t:s:j:d:k:f: opt
do
  case $opt in
    t) CARD_TYPE=$OPTARG
       ;;
    s) SRC_SLOT=$OPTARG
       ;;
    j) SRC_TM_BASE=$OPTARG
       ;;
    d) DST_SLOT=$OPTARG
       ;;
    k) DST_TM_BASE=$OPTARG
       ;;
    f) FILE=$OPTARG
       ;;
    ?) usage
       ;;
  esac
done
 
 
# Check card type
case ${CARD_TYPE} in
    10ge)
    PORT_NUM=10
    SHAPED_SPD=1000000000
    QUEUE_SIZE=125000000
    QUEUE_PROFILE=1
    METER_PROFILE=1
    ;;
    xge)
    PORT_NUM=1
    SHAPED_SPD=10000000000
    QUEUE_SIZE=256000000
    QUEUE_PROFILE=2
    METER_PROFILE=2
    ;;
    *)
    echo "Error! Unsupported card type: ${CARD_TYPE}"
    usage
    ;;
esac


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
if [ -z "$SRC_TM_BASE" ]; then
  echo "Error! Please specify the TM port offset for source slot."
  usage
fi
if [ $SRC_TM_BASE -gt 79 ]; then
  echo "Error! Invalid TM port: $SRC_TM_BASE."
  usage
fi


# Check the -k, parameters ---------------------------------------------
if [ -z "$DST_TM_BASE" ]; then
  echo "Error! Please specify the TM port offset for dest slot."
  usage
fi
if [ $DST_TM_BASE -gt 79 ]; then
  echo "Error! Invalid TM port: $DST_TM_BASE."
  usage
fi


# SLOT_NUM=6

VOQ_BASE=1024
VOQ_NUM_PER_PORT=8
VOQ_NUM_PER_SLOT=80


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
line "provQueProfile $QUEUE_PROFILE $QUEUE_SIZE 0"
empty_line

line "# ============================================================="
line "# Step 2:"
line "#  Set MeterProfile"
line "#  --usage: provMeterProfile <profileId> <cir (kbps)> <eir (kbps)> <cbs (bytes)> <ebs (bytes)>"
line "#                            <color-mode(1:aware;0:blind)> <cf (0 or 1)>"
line "# ============================================================="
((METER_XIR=$SHAPED_SPD/1000))
METER_XBS=128000
line "provMeterProfile $METER_PROFILE $METER_XIR $METER_XIR $METER_XBS $METER_XBS 0 0"
empty_line
empty_line


line "# ############################################################################"
line "# ############################################################################"
line "# Service created on slot-$SRC_SLOT  <-->  slot-$DST_SLOT, card type=$CARD_TYPE"
line "# ############################################################################"
line "# ############################################################################"
empty_line

((SRC_SLOT_EID=$SRC_SLOT + 1))
((DST_SLOT_EID=$DST_SLOT + 1))


line "# ============================================================="
line "# Step 3: "
line "#  Set TM port -> NIF/channel mapping"
line "#  --usage: provTmPort <dev> <tm-port> <slot> <port> [type]"
line "#   <dev>:  0~1"
line "#   <tm-port>: 0~79"
line "#   <slot>: 2~25 coressponding to actual slot of 1~24"
line "#   <port>: 1~10"    
line "# ============================================================="

for ((port=1; port<=$PORT_NUM; port++))
do
    ((SRC_TM_PORT=$SRC_TM_BASE + $port - 1))
    ((DST_TM_PORT=$DST_TM_BASE + $port - 1))
    
    line "provTmPort $SRC_DEV $SRC_TM_PORT $SRC_SLOT_EID $port"
    line "provTmPort $DST_DEV $DST_TM_PORT $DST_SLOT_EID $port"
done
empty_line


line "# ============================================================="
line "# Step 4: "
line "#  Set PP port"
line "#  --usage: provPpPort <dev> <tm-port> <pp-port>"
line "#   <dev>:  0~1"
line "#   <tm-port>: 0~79"
line "#   <pp-port>: 0~63"
line "# ============================================================="

for ((port=1; port<=$PORT_NUM; port++))
do
    ((SRC_TM_PORT=$SRC_TM_BASE + $port - 1))
    ((DST_TM_PORT=$DST_TM_BASE + $port - 1))
    SRC_PP_PORT=$SRC_TM_PORT
    DST_PP_PORT=$DST_TM_PORT
    
    line "provPpPort $SRC_DEV $SRC_TM_PORT $SRC_PP_PORT"
    line "provPpPort $DST_DEV $DST_TM_PORT $DST_PP_PORT"
done
empty_line


line "# ============================================================="
line "# Step 5: "
line "#  Set AC"
line "#  --usage: provP2pAc <dev> <ac-id> <peer-ac-id> <is-lag> <dest-id>"
line "#                     [ctag-op(PUSH/PUSHVID/SWAPVID/NONE)] [ctag(vid-prio)] [stag-op] [stag] [swap-cvid]"
line "#   <dev>:  0~1"
line "#   <ac-id>/<peer-ac-id>: 0~16k-1"
line "#   <is-lag>: 0~1"
line "#   <dest-id>: Lag-Id or Flow-Id"
line "# ============================================================="

for ((port=1; port<=$PORT_NUM; port++))
do
    ((AC_ID=($SRC_SLOT - 1)*10 + $port))
    ((PEER_AC_ID=($DST_SLOT - 1)*10 + $port))
    
    ((SRC_VOQ=$VOQ_BASE + ($SRC_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))
    ((DST_VOQ=$VOQ_BASE + ($DST_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))
    
    line "provP2pAc $SRC_DEV $AC_ID $PEER_AC_ID 0 $SRC_VOQ"
    line "provP2pAc $DST_DEV $PEER_AC_ID $AC_ID 0 $DST_VOQ"
done
empty_line


line "# ============================================================="
line "# Step 6: "
line "#  Set Meter Instance"
line "#  --usage: provMeter <dev> <meter-id> <profile-id>"
line "#   <dev>:  0~1"
line "#   <meter-id>: 0~16k-1"
line "#   <profile-id>: 0~511"
line "# ============================================================="

for ((port=1; port<=$PORT_NUM; port++))
do
    ((SRC_METER_ID=($SRC_SLOT - 1)*10 + $port))
    ((DST_METER_ID=($DST_SLOT - 1)*10 + $port))

    line "provMeter $SRC_DEV $SRC_METER_ID $METER_PROFILE"
    line "provMeter $DST_DEV $DST_METER_ID $METER_PROFILE"
done
empty_line


line "# ============================================================="
line "# Step 7: "
line "#  Set TM port shaping/scheduling"
line "#  --usage: provPortShaping <dev> <tm-port> <shaped-speed(bps)>"
line "#   <shaped-speed(bps)>:  shaping speed, in bps"
line "# ============================================================="

for ((port=1; port<=$PORT_NUM; port++))
do
    ((SRC_TM_PORT=$SRC_TM_BASE + $port - 1))
    ((DST_TM_PORT=$DST_TM_BASE + $port - 1))
    
    line "provPortShaping $SRC_DEV $SRC_TM_PORT $SHAPED_SPD"
    sleep
    line "provPortShaping $DST_DEV $DST_TM_PORT $SHAPED_SPD"
    sleep
done
empty_line


line "# ============================================================="
line "# Step 8: "
line "#  Set VOQ -> SchFlow mapping"
line "#  --usage: provVoq2SchFlowMapping <dev-of-voq> <voq-qrtt-id> <dev-of-sch-flow> <tm-port> <sch-flow-qrtt-id>"
line "#   <voq-qrtt-id>: voq-id/4"
line "#   <sch-flow-qrtt-id>: sch-flow/4"
line "# ============================================================="
 
for ((port=1; port<=$PORT_NUM; port++))
do
    ((SRC_TM_PORT=$SRC_TM_BASE + $port - 1))
    ((DST_TM_PORT=$DST_TM_BASE + $port - 1))
  
    ((SRC_VOQ=$VOQ_BASE + ($SRC_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))
    ((DST_VOQ=$VOQ_BASE + ($DST_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))

    ((SRC_VOQ_QUARTET=$SRC_VOQ/4))
    ((SRC_SCHFLOW_QUARTET=$SRC_VOQ_QUARTET*2))
    
    ((DST_VOQ_QUARTET=$DST_VOQ/4))
    ((DST_SCHFLOW_QUARTET=$DST_VOQ_QUARTET*2))
  
    line "provVoq2SchFlowMapping $SRC_DEV $SRC_VOQ_QUARTET $DST_DEV $DST_TM_PORT $DST_SCHFLOW_QUARTET"
    line "provVoq2SchFlowMapping $DST_DEV $DST_VOQ_QUARTET $SRC_DEV $SRC_TM_PORT $SRC_SCHFLOW_QUARTET"
done
empty_line


line "# ============================================================="
line "# Step 9: "
line "#  Set SchFlow -> VOQ mapping"
line "#  --usage: provSchFlow2VoqMapping <dev-of-voq> <voq-qrtt-id> <dev-of-sch-flow> <sch-flow-qrtt-id>"
line "# ============================================================="
 
for ((port=1; port<=$PORT_NUM; port++))
do
    ((SRC_VOQ=$VOQ_BASE + ($SRC_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))
    ((DST_VOQ=$VOQ_BASE + ($DST_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))

    ((SRC_VOQ_QUARTET=$SRC_VOQ/4))
    ((SRC_SCHFLOW_QUARTET=$SRC_VOQ_QUARTET*2))
    
    ((DST_VOQ_QUARTET=$DST_VOQ/4))
    ((DST_SCHFLOW_QUARTET=$DST_VOQ_QUARTET*2))
    
    line "provSchFlow2VoqMapping $SRC_DEV $SRC_VOQ_QUARTET $DST_DEV $DST_SCHFLOW_QUARTET"
    line "provSchFlow2VoqMapping $DST_DEV $DST_VOQ_QUARTET $SRC_DEV $SRC_SCHFLOW_QUARTET"
done
empty_line


line "# ============================================================="
line "# Step 10: "
line "#  Set VOQ"
line "#  --usage: provVoq <dev> <voq-id> <profile-id>"
line "#   <dev>:  0~1"
line "#   <voq-id>: 0~32k-1"
line "#   <profile-id>: 0~63"
line "# ============================================================="
 
for ((port=1; port<=$PORT_NUM; port++))
do
    ((SRC_VOQ=$VOQ_BASE + ($SRC_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))
    ((DST_VOQ=$VOQ_BASE + ($DST_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))

    line "provVoq $SRC_DEV $SRC_VOQ $QUEUE_PROFILE"
    line "provVoq $DST_DEV $DST_VOQ $QUEUE_PROFILE"
done
empty_line


line "# ============================================================="
line "# Step 11: "
line "#  Set SchFlow"
line "#  --usage: provSchFlowForAggregate <dev> <tm-port> <sch-flow-id> <cir> <eir> <output-cos>"
line "#   <cir>/<eir>: in bps"
line "#   <output-cos>: 0~7(7 is highest)"
line "# ============================================================="
 
for ((port=1; port<=$PORT_NUM; port++))
do
    ((SRC_TM_PORT=$SRC_TM_BASE + $port - 1))
    ((DST_TM_PORT=$DST_TM_BASE + $port - 1))
    
    ((SRC_VOQ=$VOQ_BASE + ($SRC_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))
    ((DST_VOQ=$VOQ_BASE + ($DST_SLOT_RELATIVE-1)*VOQ_NUM_PER_SLOT + ($port-1)*VOQ_NUM_PER_PORT))

    ((SRC_VOQ_QUARTET=$SRC_VOQ/4))
    ((SRC_SCHFLOW_QUARTET=$SRC_VOQ_QUARTET*2))
    ((SRC_SCHFLOW=$SRC_SCHFLOW_QUARTET * 4))
    
    ((DST_VOQ_QUARTET=$DST_VOQ/4))
    ((DST_SCHFLOW_QUARTET=$DST_VOQ_QUARTET*2))
    ((DST_SCHFLOW=$DST_SCHFLOW_QUARTET * 4))
    
    line "provSchFlowForAggregate $SRC_DEV $SRC_TM_PORT $SRC_SCHFLOW $SHAPED_SPD 0 7"
    line "provSchFlowForAggregate $DST_DEV $DST_TM_PORT $DST_SCHFLOW $SHAPED_SPD 0 7"
done
empty_line
empty_line
    

unix2dos $FILE 2>/dev/null

exit 0
