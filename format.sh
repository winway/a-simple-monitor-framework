#! /bin/bash
#

source ./config.sh

if [[ -f "$DATADIR/newest.txt" ]]
then
    newdir=$(cat "$DATADIR/newest.txt")

    for infile in $DATADIR/$RAWDIR/$newdir/*_warn.raw
    do
        if [[ -s "$infile" ]]
        then
            outfile=$(echo "$infile" | sed "s/$RAWDIR/$WARNDIR/;s/\.raw$/.html/")
            python raw2html.py "$infile" "$outfile"
        fi
    done

    for infile in $DATADIR/$RAWDIR/$newdir/*_all.raw
    do
        if [[ -s "$infile" ]]
        then
            outfile=$(echo "$infile" | sed "s/$RAWDIR/$ALLDIR/;s/\.raw$/.html/")
            python raw2html.py "$infile" "$outfile"
        fi
    done
else
    echo "No such file: $DATADIR/newest.txt"
fi
