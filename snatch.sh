#! /bin/bash
#

source ./config.sh

date="$(date '+%Y%m%d')"
time="$(date '+%H%M')"

[[ -d "$DATADIR/$RAWDIR/$date/$time" ]] || \
        mkdir -p "$DATADIR/$RAWDIR/$date/$time"
[[ -d "$DATADIR/$WARNDIR/$date/$time" ]] || \
        mkdir -p "$DATADIR/$WARNDIR/$date/$time"
[[ -d "$DATADIR/$ALLDIR/$date/$time" ]] || \
        mkdir -p "$DATADIR/$ALLDIR/$date/$time"

echo "$date/$time" >"$DATADIR/newest.txt"
echo "$date/$time" >"$DATADIR/newest.txt"
echo "$date/$time"

n=0
while read type iplstfile shfile
do
    if [[ "${type:0:1}" = "#" ]]
    then
        continue
    fi

    ((n++))

    ( sleep 160; killall -15 ssh ) &
    pid=$!

    date
    ./mussh -m 60 -u -b -t 8 -l root \
        -o StrictHostKeyChecking=no \
        -H <( awk '!/^#/{print $2}' "$ETCDIR/lst.d/$iplstfile" ) \
        -C "$ETCDIR/sh.d/$shfile" > \
        "$DATADIR/$RAWDIR/$date/$time/${type}_all.raw"
    date

    if ps -eo pid | grep -q "$pid"
    then
        kill -15 "$pid" &>/dev/null
    fi
done <"$ETCDIR/monitor.conf"

for file in $DATADIR/$RAWDIR/$date/$time/*_all.raw
do
    if [[ -s "$file" ]]
    then
        sort -t ':' -k1,1 -s "$file" >"$file.tmp"
        mv -f "$file.tmp" "$file"
    fi
done

for file in $DATADIR/$RAWDIR/$date/$time/*_all.raw
do
    if [[ -s "$file" ]]
    then
        sort -t ':' -k1,1 -s "$file" >"$file.tmp"
        mv -f "$file.tmp" "$file"
    fi
done
