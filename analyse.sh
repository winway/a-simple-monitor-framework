#! /bin/bash
#

source ./config.sh

if [[ -f "$DATADIR/newest.txt" ]]
then
    newdir=$(cat "$DATADIR/newest.txt")
fi

for infile in $DATADIR/$RAWDIR/$newdir/*_all.raw
do
    outfile=$(echo "$infile" | sed "s/\_all/_warn/")
    python raw_analyse.py "$infile" "$outfile"
done

