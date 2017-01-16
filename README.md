# opensourcepos-GoBD
Opensource-Point-of-sale extensions and tweaks for use in Germany


###############
#### NOTES: csv import imports 500 articles stable (ospos 3.0.2) , so split and rework your large csv
####  e.g. 
######  split -l 500 ospos_import_sorted.csv xosposimport;
######  mv xosposaa ospos_temp_stage/xosposaa.csv ; 
######  for i in xospos* ;do (head -n1 ospos_temp_stage/xosposaa.csv ;cat $i ) > ospos_temp_stage/$i;done
################

More infos soon...
