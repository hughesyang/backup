#!/bin/bash
# The script build bcm sdk. 

# ----------------------------------------------------------------------------------
# SDK root path
BCM_SDK_BLD_PATH=/home/hughes/f8/aos/bcm/sdk/sdk-build

if [ ! -d ${BCM_SDK_BLD_PATH} ]; then
  echo "BCM SDK build dir not exist!"
  exit 1
fi

cd ${BCM_SDK_BLD_PATH}
./build_sdk.sh -a x86

exit 0

