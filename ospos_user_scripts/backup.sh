#!/bin/bash
### rememver to install some mount point like cifs or nfs or webdav in /etc/fstab
### WEBDAV:https://webdav.yandex.com       /home/ospos/ospos-backup        davfs   rw,uid=ospos,gid=ospos,file_mode=0660,dir_mode=0770,noauto,user 0 0
mount ~/ospos-backup;mysqldump -uospos -pospospwd ospos > /tmp/ospos$(date +%F).sql ; ssh woadmin@woadmin-HPdc5700.local 'mv .osposbackup.sql .osposbackup.old.sql'; scp -pr /tmp/ospos$(date +%F).sql woadmin@woadmin-HPdc5700.local:osposbackup.sql;mv /tmp/ospos$(date +%F).sql ~/ospos-backup/;umount ~/ospos-backup
