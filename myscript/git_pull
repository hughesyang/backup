#!/bin/bash
# This script is used to update all GIT repo, given a directory.

function usage()
{
  echo "Usage:"
  echo "  ${0##*/} [options] -r <recursive> -h"
  echo
  echo "Options:"
  echo "  -r  recursive"
  echo "  -h  help"
    
  exit 0
}

function parseArgs()
{
  while getopts hr opt; do
    case ${opt} in
      r) RECURSIVE=1 ;;
      h) usage ;;
      ?) usage ;;
    esac
  done
}

function update(){
	pwd=`pwd`
    for name in `ls -l`
    do 
		cd ${pwd}
        if [ -d ${name} ]
        then
			if [ -d ${name}/.git ]
			then
				echo "------------------------------------"
				echo "Update ${name}"
				echo "------------------------------------"
				cd ${name}
				git pull			
				echo -e "\n"
			elif [ ${RECURSIVE} == 1 ]
			then
				cd ${name}
				update
			fi
        fi
    done
}

# ----------------------------------------------------------------------------------
set -e
RECURSIVE=0

parseArgs $*
update

exit 0
