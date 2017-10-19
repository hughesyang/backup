#!/bin/bash
# This script is used to disable the daily build server.
# You should be the root to execute it.

echo "crontab -u hughes -r"
crontab -u hughes -r
sleep 1

echo "crontab -l"
crontab -l
sleep 1

