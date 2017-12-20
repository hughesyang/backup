#!/bin/bash
# This script is used to merge multiple static libs to a single one
# Note: run it at the directory where holding .a and .o files

# --------------------------------------------------
function usage()
{
  echo "Usage: `basename $0` [-a (arm|x86)]"
  exit 0
}

function cleanup()
{
# just delete the generated objects
  rm -rf *.a_*o
}

# --------------------------------------------------
set -e

# parse params
while getopts a: opt
do
  case $opt in
    a) ARCH=$OPTARG
       ;;
    ?) usage
       exit 0
       ;;
  esac
done

CROSS_COMPILE=
TOOL_DIR=

# arch type
case ${ARCH} in
    arm)
      CROSS_COMPILE=aarch64-linux-gnu-
      TOOL_DIR=/usr/bin
      export PATH=${TOOL_DIR}:${PATH}
      ;;
    x86)
      CROSS_COMPILE=
      ;;
    *)
      echo "Error! Unsupported arch type: ${ARCH}"
      usage
      exit 1
      ;;
esac

# cross compile tools
AR=${CROSS_COMPILE}ar
STRIP=${CROSS_COMPILE}strip

# generated lib name
SDK_LIB=libBcmSdk.a
SDK_LIB_DBG=libBcmSdkFull.a

cleanup

# delete the generated lib if already exist
if [ -e ${SDK_LIB} ]; then
  rm ${SDK_LIB}
fi

if [ -e ${SDK_LIB_DBG} ]; then
  rm ${SDK_LIB_DBG}
fi

# extract object files from libs
LIST=`ls lib*.a`

for F in ${LIST}
do
   ${AR} x ${F}
   OBJ=`${AR} t ${F}`

   for O in ${OBJ}
   do
       mv ${O} ${F}_${O}
   done
done

# archieve all objects to a lib
${AR} crus ${SDK_LIB_DBG} *.o

# strip debug info
cp ${SDK_LIB_DBG} ${SDK_LIB}
${STRIP} -g ${SDK_LIB}

cleanup

exit 0
