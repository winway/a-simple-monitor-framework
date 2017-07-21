#! /bin/bash
#

source ./config.sh

echo -e 'Please check the following hosts by yourself:\n\n' >$DISPLAYDIR/bad_hosts_monitor

if [[ -f "$DATADIR/newest.txt" ]]
then
    newdir=$(cat "$DATADIR/newest.txt")

    grep -vf <( awk -F'[@:]+' '{print $2}' $DATADIR/$RAWDIR/$newdir/*_all.raw | sort -u ) \
             <( cat $ETCDIR/lst.d/*.lst ) | \
             tee -a $DISPLAYDIR/bad_hosts_monitor
else
    echo "No such file: $DATADIR/newest.txt"
fi
