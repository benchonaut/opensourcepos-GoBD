#!/bin/bash
#### You need an authenticated firefox profile first, then create an archive like:  tar cvzf mozilla.profile.tar.gz .mozilla/
#### this script expects an already installed "cmdlnprint" extension in your pre-authed firefox profile
#### this scripts expects your mozilla.profile.tar.gz in your home directory
#### firefox will behave strange with no printer installed, so meybe install cups-pdf before

/usr/bin/tightvncserver :1 -geometry 1920x1080 
vnc_display_first() { ps -AFc|grep Xtight|grep -v grep |grep ~/.Xauthority |sed 's/.\+Xtightvnc //g'|cut -d" " -f1|head -n1; } ;

grep "Path=ospos-headless.ospos-headless" ~/.mozilla/firefox/profiles.ini|| echo -en "\n[Profile"$(cat ~/.mozilla/firefox/profiles.ini |grep "\[Profile"|wc -l)"]\nName=ospos-headless\nIsRelative=1\nPath=ospos-headless.ospos-headless\n" >> ~/.mozilla/firefox/profiles.ini
rm -rf /tmp/ospos-headless/profile/
mkdir -p /tmp/ospos-headless/cache;mkdir -p /tmp/ospos-headless/profile;
chown $(id -un) /tmp/ospos-headless/*;chgrp $(id -gn) /tmp/ospos-headless/*;
cd /tmp/ospos-headless/profile ; tar xvzf ~/opensourcepos-GoBD/ospos_user_scripts/mozilla.profile.tar.gz

ln -sf /tmp/ospos-headless/cache ~/.cache/mozilla/firefox/ospos-headless.ospos-headless
ln -sf /tmp/ospos-headless/profile/ospos-headless.ospos-headless ~/.mozilla/firefox/ospos-headless.ospos-headless

lsof -i|grep localhost:32000|grep firefox || nohup firefox -P ospos-headless --display $(vnc_display_first ) & sleep 10; lsof -i|grep localhost:32000|grep firefox && echo port open10 || ( sleep 10 ;lsof -i|grep localhost:32000|grep firefox && echo port open20 ||echo not open)
#nohup firefox -P ospos-headless --display $(vnc_display_first ) & sleep 10;##find way to wait for port 32000 to open 
hosturl="http://127.0.0.1/"
osposurl=$hosturl"ospos"
outdir=~/pdfout
list=$(wget -q -O- $hosturl"ospos_addons/invoice-highest.php"|sed 's/ //g'|grep -v ^$);
echo 'window.location="'$osposurl'/public/login";'|netcat localhost 32000;sleep 5 ;echo 'document.forms[0].username.value="'$(cat ~/.ospos_credentials/username)'";document.forms[0].password.value="'$(cat ~/.ospos_credentials/password)'";document.forms[0].submit();'|netcat localhost 32000
test -d $outdir/invoices || mkdir -p $outdir/invoices;
test -d $outdir/.invoices || mkdir -p $outdir/.invoices
echo "$list"|while read a;do 
	sale=$(echo $a|cut -d":" -f1);invnum=$(echo $a|cut -d":" -f2);
	echo -n $sale $invnum;
	invnum=$(echo -n $invnum|cut -d"-" -f1|tr -d '\n';echo -n "-";printf %.5d $(echo $invnum|cut -d"-" -f2))
	echo "→ "$invnum".pdf"
	finaltarget=$outdir"/invoices/"$invnum".pdf";
	pretarget=$outdir"/.invoices/"$invnum".pdf";
	test -e $finaltarget || (
				firefox -P ospos-headless --display $(vnc_display_first) -silent -tray \
				-print-shrinktofit yes \
				-print-header-left no -print-header-center no -print-header-right no \
				-print-footer-center no -print-footer-left no -print-footer-right no \
				-print-bgcolors yes \
				-print-margin-top 0.2 -print-margin-left 0.2 -print-margin-right 0.2 -print-margin-bottom 0.2 \
				-print-file $pretarget \
				-print $osposurl"/public/sales/invoice/"$sale \
				-print-mode pdf -print-header no -print-footer no 2>/dev/null;sleep 10
				pdftops $pretarget $pretarget".ps" && rm $pretarget && 	gs 	-dPDFA -dBATCH \
												-dNOPAUSE -dNOOUTERSAVE -dUseCIEColor \
												-sProcessColorModel=DeviceCMYK -sDEVICE=pdfwrite \
												-sPDFACompatibilityPolicy=1 \
												-dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress \
												-sOutputFile=$pretarget".pdf" $pretarget".ps"
				##NEED ZUGFERD CONVERSION
				mv $pretarget".pdf" $finaltarget 
				rm $pretarget".ps"
				)
	done
	killall /usr/lib/firefox-esr/crashreporter /usr/lib/firefox/crashreporter
echo 'window.location="'$osposurl'/public/home/logout";'|netcat localhost 32000;
/usr/bin/tightvncserver -kill :1
