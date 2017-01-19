#!/bin/bash
vnc_display_first() { ps -AFc|grep Xtight|grep -v grep |grep ~/.Xauthority |sed 's/.\+Xtightvnc //g'|cut -d" " -f1|head -n1; } ;
firefox --display $(vnc_display_first );sleep 10;##find way to wait for port 32000 to open 
osposurl="http://127.0.0.1/ospos/"
outdir=~/pdfout
target=$osposurl"public/reports/detailed_sales/"$(date +%F)"/"$(date +%F)"/all/all"
firefox --display $(vnc_display_first )
echo 'window.location="'$osposurl'public/login";widow.location.reload;window.addEventListener("load", function () {  document.forms[0].username.value="$(cat ~/opensourcepos_credentials/username)";document.forms[0].password.value="$(cat ~/opensourcepos_credentials/password)";document.forms[0].submit(); }, true );'|netcat localhost 32000
test -e $target || firefox --display $(vnc_display_first ) -print-file $outdir/reports/$(date +%F).pdf -print $target -print-mode pdf -print-header no -print-footer no -print-delay 2
