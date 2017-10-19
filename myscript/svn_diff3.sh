#!/bin/sh --

MINE_DESC="${4}"
BASE_DESC="${6}"
OTHER_DESC="${8}"

ORIG_MINE_FILE="${9}"
ORIG_BASE_FILE="${10}"
ORIG_OTHER_FILE="${11}"

MINE_FILE="${9}"
BASE_FILE="${10}"
OTHER_FILE="${11}"

kdiff3 --L1 "$BASE_DESC" --L2 "$OTHER_DESC" --L3 "$MINE_DESC" "$BASE_FILE" "$OTHER_FILE" "$MINE_FILE" -o "$MINE_FILE.merged"

RET=$?

if [ -e "$MINE_FILE.merged" ]; then
    cat "$MINE_FILE.merged"
    rm  "$MINE_FILE.merged"
fi

exit $RET
