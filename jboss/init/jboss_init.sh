#!/bin/sh
### BEGIN INIT INFO
# Provides:          jboss
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/Stop JBoss AS v7.0.0
### END INIT INFO
#
#source some script files in order to set and export environmental variables
#as well as add the appropriate executables to $PATH
[ -r /etc/profile.d/java.sh ] && . /etc/profile.d/java.sh
[ -r /etc/profile.d/jboss.sh ] && . /etc/profile.d/jboss.sh
[ -r /etc/jboss-as/jboss-as.conf ] && . /etc/jboss-as/jboss-as.conf

case "$1" in
    start)
        echo "Starting JBoss AS 7.0.0"
        #original:
        #sudo -u jboss sh ${JBOSS_HOME}/bin/standalone.sh

        #updated:
        start-stop-daemon --start --quiet --background --chuid jboss --exec ${JBOSS_HOME}/bin/standalone.sh
    ;;
    stop)
        echo "Stopping JBoss AS 7.0.0"
        #original:
        #sudo -u jboss sh ${JBOSS_HOME}/bin/jboss-admin.sh --connect command=:shutdown

        #updated:
        start-stop-daemon --start --quiet --background --chuid jboss --exec ${JBOSS_HOME}/bin/jboss-cli.sh -- --connect command=:shutdown
    ;;
    *)
        echo "Usage: /etc/init.d/jboss {start|stop}"
        exit 1
    ;;
esac

exit 0
