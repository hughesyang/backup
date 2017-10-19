#!/bin/bash
#
# This script is used to create flows for HW test. 
# Please contact Hughes if needed.
# 



# --------------------functions----------------------

function usage()
{
 echo "Usage: `basename $0` [-t type] [-f output_file]
        -t: 10ge for 10GE card, xge for 1XGE card
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
 line "#     slot-23: voq 11k~12k, schflow 22k~24k"
 line "#     ------------------------------------------"
}

# --------------------start----------------------
CARD_TYPE=
FILE=


while getopts t:f: opt
do
  case $opt in
    t) CARD_TYPE=$OPTARG
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
    ;;
    xge)
    PORT_NUM=1
    SHAPED_SPD=10000000000
    ;;
    *)
    echo "Error! Unsupported card type: ${CARD_TYPE}"
    usage
    ;;
esac


# Check output file
if [ -z "$FILE" ];
then
  echo "Error! Please specify the output file."
  usage
fi


SLOT_NUM=6

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


for ((slot=1; slot<=$SLOT_NUM; slot++))
do
    ((REAL_SLOT=$slot * 2 - 1))
    SLOT_SELF=$REAL_SLOT
    ((SLOT_PEER=$SLOT_SELF + 12))
  
    line "# ############################################################################"
    line "# ############################################################################"
    line "# Service created on slot-$SLOT_SELF  <-->  slot-$SLOT_PEER, card type=$CARD_TYPE"
    line "# ############################################################################"
    line "# ############################################################################"
    empty_line

    ((UP_SLOT_EID=$SLOT_SELF + 1))
    ((DOWN_SLOT_EID=$SLOT_PEER + 1))
    
    ((TM_PORT_BASE=($slot-1) * 10))


    line "# ============================================================="
    line "# Step 2: "
    line "#  Set TM port -> NIF/channel mapping"
    line "#  --usage: provTmPort <dev> <tm-port> <slot> <port>"
    line "#   <dev>:  0~1"
    line "#   <tm-port>: 0~79"
    line "#   <slot>: 2~25 coressponding to actual slot of 1~24 "
    line "#   <port>: 1~10"    
    line "# ============================================================="

    for ((port=1; port<=$PORT_NUM; port++))
    do
        ((TM_PORT=$TM_PORT_BASE + $port))
        
        line "provTmPort 0 $TM_PORT $UP_SLOT_EID $port"
        line "provTmPort 1 $TM_PORT $DOWN_SLOT_EID $port"
    done
    empty_line
 
 
    line "# ============================================================="
    line "# Step 3: "
    line "#  Set TM port shaping/scheduling"
    line "#  --usage: provPortShaping <dev> <tm-port> <shaped-speed(bps)>"
    line "#   <shaped-speed(bps)>:  shaping speed, in bps"
    line "# ============================================================="
 
    for ((port=1; port<=$PORT_NUM; port++))
    do
        ((TM_PORT=$TM_PORT_BASE + $port))
        
        line "provPortShaping 0 $TM_PORT $SHAPED_SPD"
        sleep
        line "provPortShaping 1 $TM_PORT $SHAPED_SPD"
        sleep
    done
    empty_line


    line "# ============================================================="
    line "# Step 4: "
    line "#  Set VOQ -> SchFlow mapping"
    line "#  --usage: provVoq2SchFlowMapping <dev-of-voq> <voq-qrtt-id> <dev-of-sch-flow> <tm-port> <sch-flow-qrtt-id>"
    line "#   <voq-qrtt-id>: voq-id/4"
    line "#   <sch-flow-qrtt-id>: sch-flow/4"
    line "# ============================================================="
 
    for ((port=1; port<=$PORT_NUM; port++))
    do
        ((TM_PORT=$TM_PORT_BASE + $port))
        ((VOQ_QUARTET=($REAL_SLOT*$VOQ_QUARTET_BASE) + ($port-1)*$VOQ_QUARTET_SPACE))
        ((SCHFLOW_QUARTET=($REAL_SLOT*$SCHFLOW_QUARTET_BASE) + ($port-1)*$SCHFLOW_QUARTET_SPACE))

        line "provVoq2SchFlowMapping 0 $VOQ_QUARTET 1 $TM_PORT $SCHFLOW_QUARTET"
        line "provVoq2SchFlowMapping 1 $VOQ_QUARTET 0 $TM_PORT $SCHFLOW_QUARTET"
    done
    empty_line


    line "# ============================================================="
    line "# Step 5: "
    line "#  Set SchFlow -> VOQ mapping"
    line "#  --usage: provSchFlow2VoqMapping <dev-of-voq> <voq-qrtt-id> <dev-of-sch-flow> <sch-flow-qrtt-id>"
    line "# ============================================================="
 
    for ((port=1; port<=$PORT_NUM; port++))
    do
        ((VOQ_QUARTET=($REAL_SLOT*$VOQ_QUARTET_BASE) + ($port-1)*$VOQ_QUARTET_SPACE))
        ((SCHFLOW_QUARTET=($REAL_SLOT*$SCHFLOW_QUARTET_BASE) + ($port-1)*$SCHFLOW_QUARTET_SPACE))

        line "provSchFlow2VoqMapping  0 $VOQ_QUARTET 1 $SCHFLOW_QUARTET"
        line "provSchFlow2VoqMapping  1 $VOQ_QUARTET 0 $SCHFLOW_QUARTET"
    done
    empty_line
    

    line "# ============================================================="
    line "# Step 6: "
    line "#  Set VOQ"
    line "#  --usage: provVoq <dev> <voq-id> <profile-id>"
    line "# ============================================================="
 
    for ((port=1; port<=$PORT_NUM; port++))
    do
        ((VOQ=(($REAL_SLOT*$VOQ_QUARTET_BASE) + ($port-1)*$VOQ_QUARTET_SPACE) * 4))

        line "provVoq 0 $VOQ 1"
        line "provVoq 1 $VOQ 1"
    done
    empty_line


    line "# ============================================================="
    line "# Step 7: "
    line "#  Set SchFlow"
    line "#  --usage: provSchFlowForAggregate <dev> <tm-port> <sch-flow-id> <cir> <eir> <output-cos>"
    line "#   <cir>/<eir>: in bps"
    line "#   <output-cos>: 0~7(7 is highest)"
    line "# ============================================================="
 
    for ((port=1; port<=$PORT_NUM; port++))
    do
        ((TM_PORT=$TM_PORT_BASE + $port))
        ((SCHFLOW=(($REAL_SLOT*$SCHFLOW_QUARTET_BASE) + ($port-1)*$SCHFLOW_QUARTET_SPACE) * 4))

        line "provSchFlowForAggregate 0 $TM_PORT $SCHFLOW $SHAPED_SPD $SHAPED_SPD 7"
        line "provSchFlowForAggregate 1 $TM_PORT $SCHFLOW $SHAPED_SPD $SHAPED_SPD 7"
    done
    empty_line
    empty_line
    
done

unix2dos $FILE 2>/dev/null

exit 0
