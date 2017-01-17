#!/bin/bash
vnc_display_first() { ps -Fc|grep Xtight|grep -v grep |grep X11|sed 's/.\+Xtightvnc //g'|cut -d" " -f1|head -n1; } ;
osposurl="http://127.0.0.1/ospos/"
outdir=~/pdfout
target=$osposurl"public/reports/detailed_sales/"$(date +%F)"/"$(date +%F)"/all/all"
test -e $target || firefox --display $(vnc_display_first )-print-file $outdir/reports/$(date +%F).pdf -print $target -print-mode pdf -print-header no -print-footer no -print-delay 2
