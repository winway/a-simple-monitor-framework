#! /usr/bin/env python
# -*- coding: utf-8 -*-
#

import os
import re
import sys
import pyh

ETCDIR = './etc'

ip_map = {}
with open(os.path.join(ETCDIR, 'monitor.conf'), 'rt') as f1:
    for l1 in f1:
        if l1.startswith('#'):
            continue
        with open(os.path.join(ETCDIR, 'lst.d', l1.split()[1])) as f2:
            for l2 in f2:
                if l2.startswith('#'):
                    continue
                d = {}
                d['belong'] = l2.split()[0]
                if len(l2.split()) >= 3:
                    d['comment'] = '<br>'.join(l2.split()[2:])
                else:
                    d['comment'] = ''
                ip_map[l2.split()[1].replace('root@', '')] = d

ptn_ip = re.compile(r'[^@]*@([^:]*).*')
ptn = re.compile(r'[^@]*@([^:]*):[^<]*<([^>]*)>(.*)')
def data2html(infile, outfile):
    '''
    Spawn html file base on data file.
    '''

    try:
        inf = open(infile, 'rt')
    except IOError:
        print 'open %s error' % infile
        return
    if os.path.exists(outfile):
        os.remove(outfile)
    print '%s --> %s' % (infile, outfile)

    page = pyh.PyH('Monitor')
    table = page << pyh.table(border='1')

    ip = ''
    title = []
    value = []
    hastitle = 0
    title_tr = table << pyh.tr()
    for line in inf:
        if 'root@' not in line:
            print '[Unknown error]', line
            continue
        if ip != '' and ip != ptn_ip.match(line).groups()[0]:
            if not hastitle:
                hastitle = 1
                title_tr << pyh.th('归属地')
                title_tr << pyh.th('ip')
                for t in title:
                    title_tr << pyh.th(t)
                title_tr << pyh.th('备注')
            tr = table << pyh.tr()
            tr << pyh.td(ip_map[ip]['belong'])
            tr << pyh.td(ip)
            for v in value:
                v = v.replace('^^^^', '<font color="#FF0000">')
                v = v.replace('&&&&', '</font>')
                v = v.replace('+', '<br>')
                if v.endswith('**'):
                    tr << pyh.td(v.replace('**', ''), \
                            style='background-color:#F9F900')
                else:
                    tr << pyh.td(v)
            tr << pyh.td(ip_map[ip]['comment'])
            ip = ''
            title = []
            value = []
        try:
            ip = ptn_ip.match(line).groups()[0]
            title.append(ptn.match(line).groups()[1])
            value.append(ptn.match(line).groups()[2])
        except:
            tr = table << pyh.tr()
            tr << pyh.td(ip_map[ip]['belong'])
            tr << pyh.td(ip)
            tr << pyh.td(line.split(' ', 1)[1], \
                    style='background-color:#F9F900')
            tr << pyh.td(ip_map[ip]['comment'])
            ip = ''
            title = []
            value = []
            continue
    if not hastitle:
        hastitle = 1
        title_tr << pyh.th('归属地')
        title_tr << pyh.th('ip')
        for t in title:
            title_tr << pyh.th(t)
        title_tr << pyh.th('备注')
    if ip:
        tr = table << pyh.tr()
        tr << pyh.td(ip_map[ip]['belong'])
        tr << pyh.td(ip)
        for v in value:
            v = v.replace('^^^^', '<font color="#FF0000">')
            v = v.replace('&&&&', '</font>')
            v = v.replace('+', '<br>')
            if v.endswith('**'):
                tr << pyh.td(v.replace('**', ''), \
                        style='background-color:#F9F900')
            else:
                tr << pyh.td(v)
        tr << pyh.td(ip_map[ip]['comment'])

    page.printOut(outfile)
    inf.close()

if __name__ == '__main__':
    data2html(sys.argv[1], sys.argv[2])

