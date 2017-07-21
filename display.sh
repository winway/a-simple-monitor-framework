#! /bin/bash
#

source ./config.sh

newdir=$(cat "$DATADIR/newest.txt")

( cd "$DISPLAYDIR" && ln -Tf -s ".$DATADIR/$WARNDIR/$newdir" new_warning )
