#! /bin/bash
#

PATH=/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin
export PATH

source ./config.sh

echo '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
date

( sleep 150; killall -15 mussh &>/dev/null; ) &
pid=$!

./mussh -m 60 -u -t 8 -l root -o StrictHostKeyChecking=no -H <( awk '!/^#/{print $2}' etc/lst.d/*.lst ) -c "date -s '$(date -R)' && /sbin/hwclock" \
                                                                                                                        >"$DATADIR/time_sync.data"

if ps -eo pid | grep -q "$pid"
then
    kill -15 "$pid" &>/dev/null
fi

echo -e 'Please check the time of the following hosts by yourself:\n\n' >$DISPLAYDIR/bad_hosts_time_sync
grep -vf <(awk -F'[@:]+' '/root@/{print $2}' "$DATADIR/time_sync.data" | sort -u) <( cat $ETCDIR/lst.d/*.lst ) | tee -a $DISPLAYDIR/bad_hosts_time_sync

date
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
