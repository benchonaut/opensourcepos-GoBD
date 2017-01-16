#!/bin/bash
osposurl="http://127.0.0.1/ospos/"
outdir=~/pdfout
target=$osposurl"public/reports/detailed_sales/"$(date +%F)"/"$(date +%F)"/all/all"
test -e $target || firefox -print-file $outdir/reports/$(date +%F).pdf -print $target -print-mode pdf -print-header no -print-footer no -print-delay 2
