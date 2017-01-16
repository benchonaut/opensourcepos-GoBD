#!/bin/bash
#### You need an authenticated firefox profile first, then create an archive like:  tar cvzf mozilla.profile.tar.gz .mozilla/
#### this script expects an already installed "cmdlnprint" extension in your pre-authed firefox profile
#### this scripts expects your mozilla.profile.tar.gz in your home directory
hosturl="http://127.0.0.1"
outdir=~/pdfout
list=$(wget -q -O- $hosturl"/ospos_addons/invoice-highest.php"|sed 's/ //g'|grep -v ^$);
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
				cd ~;test -d .mozilla/ && rm -rf .mozilla && tar xzf mozilla.profile.tar.gz 
				firefox -silent -tray \
				-print-shrinktofit yes \
				-print-header-left no -print-header-center no -print-header-right no \
				-print-footer-center no -print-footer-left no -print-footer-right no \
				-print-bgcolors yes \
				-print-margin-top 0.2 -print-margin-left 0.2 -print-margin-right 0.2 -print-margin-bottom 0.2 \
				-print-file $pretarget \
				-print $hosturl/ospos/public/sales/invoice/$sale \
				-print-mode pdf -print-header no -print-footer no 2>/dev/null;
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