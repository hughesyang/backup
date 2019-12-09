#!/bin/bash

set -e

function usage()
{
  echo "Usage: count source codes lines, without comments and empty line"
  echo "  ${0##*/} [options] -v -h"
  echo
  echo "Options:"
  echo "  -v  verbose"
  echo "  -h  help"
}

function parseArgs()
{
  gBranch=dev
  while getopts ":hva" opt; do
    case $opt in
      "v") verbose="y" ;;
      "a") all="y" ;;
      "h") usage
           exit 0 ;;
    esac
  done
}

verbose=
all=

parseArgs $*

#COUNT_CMD=`wc -l`

FIND_FILES=`find ./ -regextype posix-extended -regex ".*\.(hpp|hxx|c|cc|cpp)"`

RESULT=tmp.log

grep -rcvE '(^\s*[/*])|(^\s*$)' $FIND_FILES > $RESULT

if [ -n "$verbose" ] ; then
  cat $RESULT
fi

TOTAL=0
while read LINE
do
    NUMBER=`echo ${LINE} | awk -F'[:]' '{print $2}'`
    if [ $NUMBER -ne 0 ]
    then
        TOTAL=`expr $TOTAL + $NUMBER`
    fi
done < $RESULT 

echo "Total lines: $TOTAL"

if [ -e $RESULT ] ; then
rm $RESULT
fi

exit 0
