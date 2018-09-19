#!/bin/sh
# generate Broadcom KBP patch file, run it with original SDK source tree and modified tree.

KBP_ORIG_DIR_NAME=kbp-orig
KBP_ADVA_DIR_NAME=kbp-adva

PATCH_FILE_NAME=bcmKbpAdva.patch

if [ ! -d ${KBP_ORIG_DIR_NAME}  ]; then
    echo "Original dir not found! ${KBP_ORIG_DIR_NAME}"
    exit 1
fi

if [ ! -d ${KBP_ADVA_DIR_NAME}  ]; then
    echo "Modified dir not found! ${KBP_ADVA_DIR_NAME}"
    exit 1
fi

diff -Naur ${KBP_ORIG_DIR_NAME} ${KBP_ADVA_DIR_NAME} > ${PATCH_FILE_NAME}

