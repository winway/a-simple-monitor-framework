#! /bin/bash
#

echo -n '<app1>'
n=$(pgrep app1 | wc -l)
if [[ n -ge 1 ]] && [[ n -le 4 ]]
then
    echo "$n"
else
    echo "${n}**"
fi

echo -n '<app2>'
n=$(pgrep app2 | wc -l)
if [[ n -ge 1 ]] && [[ n -le 4 ]]
then
    echo "$n"
else
    echo "${n}**"
fi

echo -n '<monitor>'
n=$(pgrep monitor | wc -l)
if [[ n -ge 1 ]]
then
    echo "$n"
else
    echo "${n}**"
fi

echo -n '<links_to_db>'
n=$(netstat -ant | grep -c '1521.*ESTABLISHED')
if [[ $n -ge 1 ]]
then
    echo "${n}"
else
    echo "${n}**"
fi

echo -n '<backup>'
du -sm /backup/* | \
awk -F'[ \t/]+' '{pref = suff = ""; if($1 >= 7168){warn = "**"; pref = "^^^^"; suff = "&&&&"};res = res ? res "+" pref $1 "M" OFS $NF suff : pref $1 "M" OFS $NF suff}END{print res warn}'

echo -n '<ORA_ERROR>'
start=$(date -d '5min ago' '+%s')
export start
tail -1500 /var/log/messages | while read a b c d; do e=$(date -d "$a $b $c" '+%s'); [[ $e -ge $start ]] && echo "$a $b $c $d"; done | \
LANG="C" sed -n '/ORA/s/.*\(ORA-[^:]*\):.*$/\1/p' | \
awk '{a[$0]; warn = "**"}END{for(i in a)res = res ? res "+" i : i; if(res)print res warn; else print "OK"}'
unset start

echo -n '<disk_usage>'
df -h | awk 'NR > 1{pref = suff = ""; if(int($(NF-1)) >= 80){warn = "**"; pref = "^^^^"; suff = "&&&&"};res = res ? res "+" pref $(NF-1) OFS $NF suff : pref $(NF-1) OFS $NF suff}END{print res warn}'

echo -n '<sys_time>'
date '+%Y-%m-%d %H:%M:%S'

echo -n '<uptime>'
uptime 2>/dev/null | sed -n '/up/s/^.*up[ \t]*\([^,]*\),.*$/\1/p'
