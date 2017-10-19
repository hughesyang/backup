#!/bin/bash

# The script copy sync app files to VM. 
# Please export/modify below path variables to your case.

# ----------------------------------------------------------------------------------

# Sync app repo path
SYNC_REPO_PATH=/home/hughes/f8/aos/simX86/domain-apps/sync

# Sync build path
SYNC_BUILD_PATH=/home/hughes/f8/aos/prod/ge11x/sdk-build/Build/sync/source

# GE11x libs
PROD_LIB_PATH=/home/hughes/f8/aos/prod/ge11x/product-build/lib

# VM path
PROD_IP_ADDR=172.23.191.84
AOS_PATH=/opt/adva/aos
REMOTE_PATH=root@${PROD_IP_ADDR}:${AOS_PATH}

# ----------------------------------------------------------------------------------

function log()
{
  echo $(date +%T) "$*"
}

function check_path
{
  for dir in $*; do
    if [ ! -d ${dir} ] ; then
      echo -e "\033[31m ${dir} does not exist, error!\033[0m"
      exit 1
    fi
  done
  return 0
}

# ----------------------------------------------------------------------------------

# json files path
JSONTLV_PATH=${SYNC_REPO_PATH}/config/sim
CIM_DEFAULT_PATH=${SYNC_REPO_PATH}/share/cim/defaults
CIM_ADJUNCT_PATH=${SYNC_REPO_PATH}/share/cim/adjunct
CAPABILITY_FILE_PATH=${SYNC_REPO_PATH}/share/capability
CFG_FILE_PATH=${SYNC_REPO_PATH}/etc

# common lib, cim lib, apl plugin & hbmapp plugin
COMMON_LIB_PATH=${SYNC_BUILD_PATH}/common
CIM_LIB_PATH=${SYNC_BUILD_PATH}/cim
APL_PLUGIN_PATH=${SYNC_BUILD_PATH}/apl/plugin
HBMAPP_PLUGIN_PATH=${SYNC_BUILD_PATH}/hbmapp

# process dte/bin
PROCESS_PATH=${SYNC_BUILD_PATH}/apl/app
DBG_LIB_PATH=${SYNC_BUILD_PATH}/apl/app/dte

# file names
LIB_NAME="libAosDomEthSync*"
APP_NAME="aosDomEthSync*"
JSON_NAME="*json*"

# commands
SCP_CMD="sudo scp"
SSH_CMD="sudo ssh"
MKDIR_CMD="sudo mkdir -p"

# ----------------------------------------------------------------------------------

log "*** Copy sync app files to Product ***"
log " @ repo_path=${SYNC_REPO_PATH}"
log " @ build_path=${SYNC_BUILD_PATH}"
log " @ remote_path=${REMOTE_PATH}"

check_path ${SYNC_REPO_PATH} ${SYNC_BUILD_PATH}

log " -- copy common lib..."
${SCP_CMD} ${COMMON_LIB_PATH}/${LIB_NAME} ${REMOTE_PATH}/lib > /dev/null

log " -- copy cim lib..."
${SCP_CMD} ${CIM_LIB_PATH}/${LIB_NAME} ${REMOTE_PATH}/lib > /dev/null

log " -- copy apl plugin..."
${SCP_CMD} ${APL_PLUGIN_PATH}/${LIB_NAME} ${REMOTE_PATH}/lib/plugin/aplfw > /dev/null

log " -- no copy hbmapp plugin..."
# ${SCP_CMD} ${HBMAPP_PLUGIN_PATH}/${LIB_NAME} ${REMOTE_PATH}/lib/plugin/hbmapp > /dev/null

log " -- copy process..."
${SCP_CMD} ${PROCESS_PATH}/${APP_NAME} ${REMOTE_PATH}/bin > /dev/null
${SCP_CMD} ${DBG_LIB_PATH}/${LIB_NAME} ${REMOTE_PATH}/lib > /dev/null

log " -- copy process cfg files..."
${SSH_CMD} ${PROD_IP_ADDR} 'mkdir -p /opt/adva/aos/etc/domain-apps/sync'

${SCP_CMD} ${CFG_FILE_PATH}/${JSON_NAME} ${REMOTE_PATH}/etc/domain-apps/sync > /dev/null

log " -- copy model json/jsontlv files..."
${SCP_CMD} ${JSONTLV_PATH}/${JSON_NAME} ${REMOTE_PATH}/share/cim/json > /dev/null

log " -- copy cim default json files..."
${SCP_CMD} ${CIM_DEFAULT_PATH}/${JSON_NAME} ${REMOTE_PATH}/share/cim/defaults > /dev/null

log " -- copy cim adjunct jsontlv files..."
${SCP_CMD} ${CIM_ADJUNCT_PATH}/${JSON_NAME} ${REMOTE_PATH}/share/cim/adjunct > /dev/null

log " -- copy capability json files..."
${SSH_CMD} ${PROD_IP_ADDR} 'mkdir -p /opt/adva/aos/share/capability/sync'

${SCP_CMD} ${CAPABILITY_FILE_PATH}/${JSON_NAME} ${REMOTE_PATH}/share/capability/sync > /dev/null

log " -- copy ge11x libs"
${SCP_CMD} ${PROD_LIB_PATH}/libGe11xHbmDrvFpga.so ${REMOTE_PATH}/lib > /dev/null
${SCP_CMD} ${PROD_LIB_PATH}/libGe11xHbmCard.so ${REMOTE_PATH}/lib > /dev/null
${SCP_CMD} ${PROD_LIB_PATH}/libProdSyncHbmApp.so ${REMOTE_PATH}/lib/plugin/hbmapp > /dev/null

log "*** Done ***"

exit 0
