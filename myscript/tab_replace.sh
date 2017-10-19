#!/bin/bash

FILE=$1
BAKFILE=tmpbak.f

if [ $# -ne "1" ]; then
  echo "Usage: `basename $0` <file>"
  exit
fi

sed -e 's/\t/    /g' $FILE > $BAKFILE
mv $BAKFILE $FILE

# ls -l | awk '{print $9}' | while read f; do replace $f; done 

