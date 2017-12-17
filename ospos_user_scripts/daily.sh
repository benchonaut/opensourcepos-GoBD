#!/bin/bash
osposurl="http://woodstockpos.local/ospos/"
firefox -print-file /home/woadmin/pdfout/reports/$(date +%F).pdf -print $osposurl"public/reports/detailed_sales/"$(date +%F)"/"$(date +%F)"/all/all" -print-mode pdf -print-header no -print-footer no 
