#! /bin/bash
#

PATH=/usr/lib/qt-3.3/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/winway/bin
export PATH

echo 'snatching...'
./snatch.sh

echo 'analysing...'
./analyse.sh

echo 'formatting...'
./format.sh

echo 'displaying...'
./display.sh
