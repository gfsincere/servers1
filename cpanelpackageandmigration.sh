#! /bin/bash
ls /var/cpanel/users/ > migration.txt
tail -n +3 migration.txt > users.txt
for i in `cat users.txt`; do /scripts/pkgacct --skipdb $i; done
mysql -u root -e "show databases"; grep -v Database; while read i; do mysqldump $i > /root/SQL/$i.sql; done
php -v >> /root/INFO
pvp -m >>/root/INFO
httpd status >>/root/INFO
