#!/bin/bash

# The script copy qumran NFS scripts to xg400

if [ $# -ne "1" ]; then
  echo "Usage: `basename $0` <ip>"
  exit
fi

BOX_ADDR=$1
BOX_LOGIN=root@${BOX_ADDR}

# ----------------------------------------------------------------------------------
function log()
{
  echo $(date +%T) "$*"
}
# ----------------------------------------------------------------------------------

# commands
SCP_CMD="scp -P 614"
SSH_CMD="ssh -p 614"

# local path storing scripts
LOCAL_PATH=/home/hughes/upload/dnx

# ----------------------------------------------------------------------------------
log " -- enable r/w access"
${SSH_CMD} ${BOX_LOGIN} -o "StrictHostKeyChecking no" 'mount -o remount,rw /opt/adva; mount -o remount,rw /lib/modules/'

log " -- create/copy files"
${SSH_CMD} ${BOX_LOGIN} 'cd /opt/adva; mkdir -p qumran; cd qumran; mkdir -p dnx; cd dnx; mkdir -p rmt;'

cd ${LOCAL_PATH}
${SCP_CMD} * ${BOX_LOGIN}:/opt/adva/qumran/dnx
${SSH_CMD} ${BOX_LOGIN} 'cd /opt/adva/qumran/dnx; sudo cp bashrc /etc/bash/'

# set hostname, in upper-case
${SSH_CMD} ${BOX_LOGIN} 'HOST=`hostname`; sudo echo "HY-${HOST^^}" > /etc/hostname'

# copy tcpdump
#${SSH_CMD} ${BOX_LOGIN} 'cd /opt/adva/qumran/dnx; sudo tar jxf tcpdump.tar.bz2 -C /'

log "*** Done ***"
exit 0
