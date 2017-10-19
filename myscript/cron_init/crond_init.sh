#!/bin/bash
# This script is used to setup the daily build server.
# This script is running by root user.

# set scripts directory
# SCRIPTS_DIR="/home/bldserver/scripts"

# copy scripts_build_daily to $SCRIPTS_DIR
# echo "cp scripts_build_daily $SCRIPTS_DIR"
# cp scripts_build_daily $SCRIPTS_DIR

# init ntpd server
echo "cp ntp.conf /etc"
cp ntp.conf /etc
sleep 1

# check ntpd server is running?
echo "/sbin/service ntpd status"
/sbin/service ntpd status
sleep 1

echo "/sbin/chkconfig --add ntpd"
/sbin/chkconfig --add ntpd
sleep 1

echo "/sbin/chkconfig ntpd on"
/sbin/chkconfig ntpd on
sleep 1

echo "/sbin/chkconfig --list ntpd"
/sbin/chkconfig --list ntpd
sleep 1

echo "/sbin/service ntpd status"
/sbin/service ntpd status
sleep 1

# init crond server
echo "/sbin/service crond status"
/sbin/service crond status
sleep 1

echo "/sbin/chkconfig --list crond"
/sbin/chkconfig --list crond
sleep 1

echo "/sbin/chkconfig --add crond"
/sbin/chkconfig --add crond
sleep 1

echo "/sbin/chkconfig crond on"
/sbin/chkconfig crond on
sleep 1

echo "/sbin/service crond status"
/sbin/service crond status
sleep 1

# configure crond_build_daily
echo "crontab -u root \"crond_build_daily.conf\""
crontab -u hughes "crond_build_daily.conf"
sleep 1

echo "crontab -u hughes -l"
crontab -u hughes -l
sleep 1

