#!/bin/bash

# The script copy all apps to VM. 
# Please export/modify below path variables to your case.

DIR=/home/hughes/myscript/aos

$DIR/cp_pdh_to_vm.sh
echo

$DIR/cp_timing_to_vm.sh
echo

$DIR/cp_synce_to_vm.sh
echo

$DIR/cp_ptp_to_vm.sh
echo

exit 0
