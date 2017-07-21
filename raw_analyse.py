#! /usr/bin/env python
# -*- coding: utf-8 -*-
#

import os
import re
import sys

ETCDIR = './etc'

threshold = {}
with open(os.path.join(ETCDIR, 'monitor.conf'), 'rt') as f1:
    for l1 in f1:
        if l1.startswith('#'):
            continue
        type = l1.split()[0]
        threshold[type] = {}
        with open(os.path.join(ETCDIR, 'thv.d', l1.split()[-1])) as f2:
            for l2 in f2:
                if l2.startswith('#'):
                    continue
                d = {}
                d['min'] = l2.split()[1]
                d['max'] = l2.split()[2]
                threshold[type][l2.split()[0]] = d

print threshold

ptn_ip = re.compile(r'[^@]*@([^:]*).*')
ptn = re.compile(r'[^@]*@([^:]*):[^<]*<([^>]*)>(.*)')
def raw_analyse(infile, outfile):
    '''
    Spawn html file base on data file.
    '''

    try:
        inf = open(infile, 'rt')
    except IOError:
        print 'open %s error' % infile
        return
    try:
        outf = open(outfile, 'wt')
    except IOError:
        print 'open %s error' % outfile
        return
    print '%s --> %s' % (infile, outfile)

    type = os.path.basename(infile).replace('_all.raw', '')

    ip = ''
    title = ''
    value = ''
    outlines = []
    write = 0
    for inline in inf:
        if ip != '' and ip != ptn_ip.match(inline).groups()[0]:
            if write:
                outf.writelines(outlines)
            ip = ''
            title = ''
            value = ''
            outlines = []
            write = 0
        if 'timed out' in inline:
            outf.write(inline.replace('\n', '**\n'))
            ip = ''
            title = ''
            value = ''
            outlines = []
            write = 0
            continue
        if 'Connection refused' in inline:
            outf.write(inline.replace('\n', '**\n'))
            ip = ''
            title = ''
            value = ''
            outlines = []
            write = 0
            continue
        ip = ptn_ip.match(inline).groups()[0]
        title = ptn.match(inline).groups()[1]
        value = ptn.match(inline).groups()[2]
        if title in threshold[type]:
            if int(value) <= int(threshold[type][title]['min']) or \
                int(value) >= int(threshold[type][title]['max']):
                write = 1
                inline = inline.replace('\n', '**\n')
        outlines.append(inline)
    if write:
        outf.writelines(outlines)

    inf.close()
    outf.close()

if __name__ == '__main__':
    raw_analyse(sys.argv[1], sys.argv[2])

