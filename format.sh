#! /bin/bash
#

source ./config.sh

if [[ -f "$DATADIR/newest.txt" ]]
then
    newdir=$(cat "$DATADIR/newest.txt")
fi

for infile in $DATADIR/$RAWDIR/$newdir/*_warn.raw
do
    outfile=$(echo "$infile" | sed "s/$RAWDIR/$WARNDIR/;s/\.raw$/.html/")
    python raw2html.py "$infile" "$outfile"
done

for infile in $DATADIR/$RAWDIR/$newdir/*_all.raw
do
    outfile=$(echo "$infile" | sed "s/$RAWDIR/$ALLDIR/;s/\.raw$/.html/")
    python raw2html.py "$infile" "$outfile"
done

