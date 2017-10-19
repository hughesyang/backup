#!/bin/bash

# The script copy timing files to VM. 
# Please export/modify below path variables to your case.

# ----------------------------------------------------------------------------------

# app repo path
TIMING_REPO_PATH=/home/hughes/f8/aos/simX86/domain-apps/timing

# build path
TIMING_BUILD_PATH=/home/hughes/f8/aos/simX86/mybuild/Build/timing/source

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
JSONTLV_PATH=${TIMING_REPO_PATH}/share/cim/json
CIM_DEFAULT_PATH=${TIMING_REPO_PATH}/share/cim/defaults
CIM_ADJUNCT_PATH=${TIMING_REPO_PATH}/share/cim/adjunct
CAPABILITY_FILE_PATH=${TIMING_REPO_PATH}/share/capability
CFG_FILE_PATH=${TIMING_REPO_PATH}/etc

# common lib, cim lib, apl plugin & hbmapp plugin
COMMON_LIB_PATH=${TIMING_BUILD_PATH}/common
CIM_LIB_PATH=${TIMING_BUILD_PATH}/cim
MSG_LIB_PATH=${TIMING_BUILD_PATH}/message
APP_LIB_PATH=${TIMING_BUILD_PATH}/apl/app
APL_PLUGIN_PATH=${TIMING_BUILD_PATH}/apl/plugin

# process dte/bin
PROCESS_PATH=${TIMING_BUILD_PATH}/apl/app
DBG_LIB_PATH=${TIMING_BUILD_PATH}/apl/app/dte

# file names
LIB_NAME="libAosDomTiming*"
APP_NAME="aosDomTiming*"
JSON_NAME="*json*"

# commands
CP_CMD="sudo cp -a"
MKDIR_CMD="sudo mkdir -p"

# ----------------------------------------------------------------------------------

log "*** Copy Timing files to VM ***"
log " @ repo_path=${TIMING_REPO_PATH}"
log " @ build_path=${TIMING_BUILD_PATH}"
log " @ vm_path=${VM_PATH}"

check_path ${TIMING_REPO_PATH} ${TIMING_BUILD_PATH} ${VM_PATH}

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
DST_CFG_PATH=${VM_PATH}/etc/domain-apps/timing
${MKDIR_CMD} ${DST_CFG_PATH}

${CP_CMD} ${CFG_FILE_PATH}/${JSON_NAME} ${DST_CFG_PATH}

log " -- copy model json/jsontlv files..."
${CP_CMD} ${JSONTLV_PATH}/${JSON_NAME} ${VM_PATH}/share/cim/json

log " -- copy cim default json files..."
${CP_CMD} ${CIM_DEFAULT_PATH}/${JSON_NAME} ${VM_PATH}/share/cim/defaults

log " -- copy cim adjunct jsontlv files..."
${CP_CMD} ${CIM_ADJUNCT_PATH}/${JSON_NAME} ${VM_PATH}/share/cim/adjunct

log " -- copy capability json files..."
DST_CAPABILITY_PATH=${VM_PATH}/share/capability/timing
${MKDIR_CMD} ${DST_CAPABILITY_PATH}

${CP_CMD} ${CAPABILITY_FILE_PATH}/${JSON_NAME} ${DST_CAPABILITY_PATH}

log "*** Done ***"

exit 0
