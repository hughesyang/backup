#!/bin/bash

# Enable errexit: Exit if any "simple command" fails
set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 [FROM_STRING] [TO_STRING]"
    exit 1
fi

FROM=$1
TO=$2

FIND=`grep "${FROM}" -r`

echo "${FIND}"

sed -i "s/${FROM}/${TO}/g" `grep "${FROM}" -rl` 

echo "Done..."

exit 0
