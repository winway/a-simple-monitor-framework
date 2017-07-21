#! /bin/bash
#

echo -n "<hostname>"
hostname

echo -n '<time>'
date '+%Y-%m-%d %H:%M:%S'

echo -n '<uptime>'
uptime | sed -r 's/.*up\s*([^,]*).*/\1/'

echo -n '<interface>'
/sbin/ifconfig | sed -nr '/^\S/{N;s/\s+.*inet addr:(\S+).*/ \1/;H};${x;s/^\s*//g;s/\n/+/g;p}'

echo -n '<process_number>'
ps -e | wc -l

echo -n '<disk_usage>'
df -h | awk -F'[ %]+' '$NF == "/"{print $(NF-1)}'

