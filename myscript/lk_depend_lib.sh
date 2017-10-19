#!/bin/bash
# This script is used to find a lib, given a symbol

SDK_LIB=libBcmSdk.a

if [ $# -ne 1 ]; then
   echo "Usage: $0 [SEARCH_STRING]"
   exit 1
fi

STR=$1
TMP=

# extract object files from libs
LIST=`ls lib*`
LIST+=" "
LIST+=`ls *.o`

for F in $LIST
do
   nm -A --defined-only $F | grep -w $STR
done

exit 0
