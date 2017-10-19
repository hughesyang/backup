#!/bin/bash

# The script copy pdh files to VM. 
# Please export/modify below path variables to your case.

# ----------------------------------------------------------------------------------

# app repo path
PDH_REPO_PATH=/home/hughes/f8/aos/simX86/domain-apps/pdh

# build path
PDH_BUILD_PATH=/home/hughes/f8/aos/simX86/mybuild/Build/pdh/source

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
JSONTLV_PATH=${PDH_REPO_PATH}/share/cim/json
CIM_DEFAULT_PATH=${PDH_REPO_PATH}/share/cim/defaults
CIM_ADJUNCT_PATH=${PDH_REPO_PATH}/share/cim/adjunct
CAPABILITY_FILE_PATH=${PDH_REPO_PATH}/share/capability
CFG_FILE_PATH=${PDH_REPO_PATH}/etc

# common lib, cim lib, apl plugin & hbmapp plugin
COMMON_LIB_PATH=${PDH_BUILD_PATH}/common
CIM_LIB_PATH=${PDH_BUILD_PATH}/cim
APL_PLUGIN_PATH=${PDH_BUILD_PATH}/apl/plugin

# file names
LIB_NAME="libAosDomPdh*"
JSON_NAME="*json*"

# commands
CP_CMD="sudo cp -a"
MKDIR_CMD="sudo mkdir -p"

# ----------------------------------------------------------------------------------

log "*** Copy Pdh files to VM ***"
log " @ repo_path=${PDH_REPO_PATH}"
log " @ build_path=${PDH_BUILD_PATH}"
log " @ vm_path=${VM_PATH}"

check_path ${PDH_REPO_PATH} ${PDH_BUILD_PATH} ${VM_PATH}

log " -- copy common lib..."
${CP_CMD} ${COMMON_LIB_PATH}/${LIB_NAME} ${VM_PATH}/lib

log " -- copy cim lib..."
${CP_CMD} ${CIM_LIB_PATH}/${LIB_NAME} ${VM_PATH}/lib

log " -- copy apl plugin..."
${CP_CMD} ${APL_PLUGIN_PATH}/${LIB_NAME} ${VM_PATH}/lib/plugin/aplfw

log " -- copy model json/jsontlv files..."
${CP_CMD} ${JSONTLV_PATH}/${JSON_NAME} ${VM_PATH}/share/cim/json

log " -- copy cim default json files..."
${CP_CMD} ${CIM_DEFAULT_PATH}/${JSON_NAME} ${VM_PATH}/share/cim/defaults

log "*** Done ***"

exit 0
