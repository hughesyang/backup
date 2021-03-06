#!/bin/bash

# The script copy ptp files to VM. 
# Please export/modify below path variables to your case.

# ----------------------------------------------------------------------------------

# app repo path
PTP_REPO_PATH=/home/hughes/f8/aos/simX86/domain-apps/ptp-1588

# build path
PTP_BUILD_PATH=/home/hughes/f8/aos/simX86/mybuild/Build/ptp-1588/source

# VM path
VM_PATH=/home/hughes/f8/aos/vm/ec/ld/adva.0.9p/aos

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
JSONTLV_PATH=${PTP_REPO_PATH}/share/cim/json
CIM_DEFAULT_PATH=${PTP_REPO_PATH}/share/cim/defaults
CAPABILITY_FILE_PATH=${PTP_REPO_PATH}/share/capability
CFG_FILE_PATH=${PTP_REPO_PATH}/etc

# common lib, cim lib, apl plugin & hbmapp plugin
COMMON_LIB_PATH=${PTP_BUILD_PATH}/common
CIM_LIB_PATH=${PTP_BUILD_PATH}/cim
MSG_LIB_PATH=${PTP_BUILD_PATH}/message
APP_LIB_PATH=${PTP_BUILD_PATH}/apl/app
APL_PLUGIN_PATH=${PTP_BUILD_PATH}/apl/plugin

# process dte/bin
PROCESS_PATH=${PTP_BUILD_PATH}/apl/app
DBG_LIB_PATH=${PTP_BUILD_PATH}/apl/app/dte

# file names
LIB_NAME="libAosDomPtp*"
APP_NAME="aosDomPtp*"
JSON_NAME="*json*"

# commands
CP_CMD="sudo cp -a"
MKDIR_CMD="sudo mkdir -p"

# ----------------------------------------------------------------------------------

log "*** Copy PTP files to VM ***"
log " @ repo_path=${PTP_REPO_PATH}"
log " @ build_path=${PTP_BUILD_PATH}"
log " @ vm_path=${VM_PATH}"

check_path ${PTP_REPO_PATH} ${PTP_BUILD_PATH} ${VM_PATH}

log " -- copy common lib..."
${CP_CMD} ${COMMON_LIB_PATH}/${LIB_NAME} ${VM_PATH}/lib

log " -- copy cim lib..."
${CP_CMD} ${CIM_LIB_PATH}/${LIB_NAME} ${VM_PATH}/lib

log " -- copy msg lib..."
${CP_CMD} ${MSG_LIB_PATH}/${LIB_NAME} ${VM_PATH}/lib

log " -- copy app lib..."
${CP_CMD} ${APP_LIB_PATH}/${LIB_NAME} ${VM_PATH}/lib

log " -- copy apl plugin..."
${CP_CMD} ${APL_PLUGIN_PATH}/${LIB_NAME} ${VM_PATH}/lib/plugin/aplfw

log " -- copy process..."
${CP_CMD} ${PROCESS_PATH}/${APP_NAME} ${VM_PATH}/bin
${CP_CMD} ${DBG_LIB_PATH}/${LIB_NAME} ${VM_PATH}/lib

log " -- copy process cfg files..."
DST_CFG_PATH=${VM_PATH}/etc/domain-apps/ptp-1588
${MKDIR_CMD} ${DST_CFG_PATH}

${CP_CMD} ${CFG_FILE_PATH}/${JSON_NAME} ${DST_CFG_PATH}

log " -- copy model json/jsontlv files..."
${CP_CMD} ${JSONTLV_PATH}/${JSON_NAME} ${VM_PATH}/share/cim/json

log " -- copy cim default json files..."
${CP_CMD} ${CIM_DEFAULT_PATH}/${JSON_NAME} ${VM_PATH}/share/cim/defaults

log " -- copy capability json files..."
DST_CAPABILITY_PATH=${VM_PATH}/share/capability/ptp-1588
${MKDIR_CMD} ${DST_CAPABILITY_PATH}

${CP_CMD} ${CAPABILITY_FILE_PATH}/${JSON_NAME} ${DST_CAPABILITY_PATH}

log "*** Done ***"

exit 0
