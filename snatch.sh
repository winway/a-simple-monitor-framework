#! /bin/bash
#

source ./config.sh

date=$(date '+%Y%m%d')
time=$(date '+%H%M')

[[ -d "$DATADIR/$RAWDIR/$date/$time" ]] ||\
        mkdir -p "$DATADIR/$RAWDIR/$date/$time"
[[ -d "$DATADIR/$WARNDIR/$date/$time" ]] ||\
        mkdir -p "$DATADIR/$WARNDIR/$date/$time"
[[ -d "$DATADIR/$ALLDIR/$date/$time" ]] ||\
        mkdir -p "$DATADIR/$ALLDIR/$date/$time"

echo "$date/$time" >"$DATADIR/newest.txt"
echo "$date/$time"

n=0
while read type iplstfile shfile thvfile
do
    if [[ "$type" = "#" ]]
    then
        continue
    fi

    ((n++))
    mussh -m -u -b -t 5 \
        -H <( awk '!/^#/{print $2}' "$ETCDIR/lst.d/$iplstfile" ) \
        -C "$ETCDIR/sh.d/$shfile" > \
        "$DATADIR/$RAWDIR/$date/$time/${type}_all.raw" &
done <"$ETCDIR/monitor.conf"

# wait all background processes to complete
for ((i=1; i<=n; i++))
do
    wait %$i
done
