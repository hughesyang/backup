#!/bin/sh
# generate Broadcom SDK patch file, run it with original SDK source tree and modified tree.

SDK_ORIG_DIR_NAME=sdk-orig
SDK_ADVA_DIR_NAME=sdk-adva

PATCH_FILE_NAME=bcmSdkAdva.patch

if [ ! -d ${SDK_ORIG_DIR_NAME}  ]; then
    echo "Original dir not found! ${SDK_ORIG_DIR_NAME}"
    exit 1
fi

if [ ! -d ${SDK_ADVA_DIR_NAME}  ]; then
    echo "Modified dir not found! ${SDK_ADVA_DIR_NAME}"
    exit 1
fi

diff -Naur ${SDK_ORIG_DIR_NAME} ${SDK_ADVA_DIR_NAME} > ${PATCH_FILE_NAME}

