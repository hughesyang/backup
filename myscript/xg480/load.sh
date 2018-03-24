#!/bin/bash

BASE_DIR=/opt/adva/qumran/dnx/rmt

count=`ls ${BASE_DIR} | wc -l`

if [ ${count} -eq 0 ]; then
  echo "do mount"
  mount -t nfs 172.23.5.118:/home/hughes/f8/aos/xg480/build/arm ${BASE_DIR}
fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${BASE_DIR}/Install/lib:

${BASE_DIR}/Build/qumran-api/bin/qumran

