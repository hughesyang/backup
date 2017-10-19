#!/bin/bash

# count .cpp codes lines

function usage()
{
  echo "Usage: count source codes lines, incl. comments and empty lines"
  echo "  ${0##*/} [options] -v -h"
  echo
  echo "Options:"
  echo "  -v  verbose"
  echo "  -h  help"
}

function parseArgs()
{
  gBranch=dev
  while getopts ":hv" opt; do
    case $opt in
      "v") verbose="y" ;;
      "h") usage
           exit 0 ;;
    esac
  done
}

verbose=

parseArgs $*

CMD="wc -l `find ./ -regextype posix-extended -regex ".*\.(h|hpp|hxx|c|cc|cpp)"`"

if [ -n  "$verbose" ] ; then
  $CMD
else
  $CMD | tail -n1
fi

exit 0
