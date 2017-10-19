cron_conf:
  minute hour date month week [user] command
  1-59   *    *    *     *    root   updatedb     # means updatedb every minute

crontab:
  (1) check crond is running or not
      /sbin/service crond status

  (2) set crond auto running after system startup
      /sbin/chkconfig --list crond
      /sbin/chkconfig --add crond
      /sbin/chkconfig crond on

  (3) add new cron_conf
      crontab -u <cron_conf>

  (4) list current crontab tasks
      crontab -l

  (5) edit current crontab tasks
      crontab -e

  (6) delete current crontab tasks
      crontab -r
ntpd:
  (1) check ntpd is running or not
      /sbin/service ntpd status

  (2) set ntpd auto running after system startup
      /sbin/chkconfig --list ntpd
      /sbin/chkconfig --add ntpd
      /sbin/chkconfig ntpd on

  (3) set ntpd config file "/etc/ntp.conf"
      server 192.168.190.9
      server 127.127.1.0

