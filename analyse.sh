#! /bin/bash
#

source ./config.sh

if [[ -f "$DATADIR/newest.txt" ]]
then
    newdir=$(cat "$DATADIR/newest.txt")

    for infile in $DATADIR/$RAWDIR/$newdir/*_all.raw
    do
        if [[ -s "$infile" ]]
        then
            outfile=$(echo "$infile" | sed "s/\_all/_warn/")
            python raw_analyse.py "$infile" "$outfile"
        fi
    done
else
    echo "No such file: $DATADIR/newest.txt"
fi

find $DATADIR/$RAWDIR/$newdir/ -name '*_warn.raw' -empty -exec rm -f '{}' \;
