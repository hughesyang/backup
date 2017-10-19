#!/bin/bash

# This script is used to retrive the head revisioin of external link for EGX
# Here is the list of R8.1, one can update it if external link has something changes in future

ROOT=https://advactfdev.com/svn/repos/fsp150cm
SVN=svn

ExtLinks="
$ROOT/branches/platform/bootldr/r4
$ROOT/trunk/platform/os-platform
$ROOT/branches/3rdparty/gPerfTools
$ROOT/branches/3rdparty/arrive
$ROOT/branches/3rdparty/dune
$ROOT/branches/infomodel/v29.x
$ROOT/branches/features/sat/r8.x
$ROOT/branches/features/mef35/r3.x
$ROOT/branches/features/amp/r3.x
$ROOT/branches/features/erp/r6.x
$ROOT/branches/features/jdsuLoop/r1.x
$ROOT/branches/features/lldp/r5.x
$ROOT/branches/features/ptp/r15.x
$ROOT/branches/features/pwe3/r2.x/
$ROOT/branches/features/tdm/r1.x
$ROOT/branches/platform/os-software/r13/powerpc
$ROOT/branches/platform/os-software/r8-r9.5egx/powerpc
$ROOT/branches/software/cr4/dev/software/releases/fsp150
$ROOT/branches/software/cr4/dev/software/releases/pwe_he
"

echo "Dump external HEAD rev info, staring..."
echo "---------------------------------------"

for link in $ExtLinks; do
  rev=`$SVN info $link | grep "Last Changed Rev" | cut -d' ' -f4`
  echo "HEAD revision is: $rev for $link"
done

echo "---------------------------------------"
echo "Done..."
