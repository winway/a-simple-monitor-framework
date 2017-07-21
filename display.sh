#! /bin/bash
#

source ./config.sh

if [[ -f "$DATADIR/newest.txt" ]]
then
    newdir=$(cat "$DATADIR/newest.txt")

    ( cd "$DISPLAYDIR" && ln -Tf -s ".$DATADIR/$WARNDIR/$newdir" new_warning )
else
    echo "No such file: $DATADIR/newest.txt"
fi
