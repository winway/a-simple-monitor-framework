#! /usr/bin/env python
# -*- coding: utf-8 -*-
#

import os
import re
import sys

ETCDIR = './etc'

ptn_ip = re.compile(r'[^@]*@([^:]*).*')
ptn = re.compile(r'[^@]*@([^:]*):[^<]*<([^>]*)>(.*)')
def raw_analyse(infile, outfile):
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
        if 'root@' not in inline:
            print '[Unknown error]', inline
            continue
        if ip != '' and ip != ptn_ip.match(inline).groups()[0]:
            if write:
                outf.writelines(outlines)
            ip = ''
            title = ''
            value = ''
            outlines = []
            write = 0
        try:
            ip = ptn_ip.match(inline).groups()[0]
            title = ptn.match(inline).groups()[1]
            value = ptn.match(inline).groups()[2]
        except Exception, e:
            print 'Exception:', e
            print '[Analyse error]', inline
            outf.write(inline)
            ip = ''
            title = ''
            value = ''
            outlines = []
            write = 0
            continue
        if inline.endswith('**\n'):
            write = 1
        outlines.append(inline)
    if write:
        outf.writelines(outlines)

    inf.close()
    outf.close()

if __name__ == '__main__':
    raw_analyse(sys.argv[1], sys.argv[2])

