rsync -avz --progress 107.170.96.220:/etc/php.ini /etc
rsync -avz --progress 107.170.96.220:/etc/my.cnf /etc
sed -i 's_/var/run/mysqld/mysqld.sock_/mysqld/mysqld.sock_g' /etc/mysql/my.cnf
rsync -avz --progress 107.170.96.220:/etc/crontab /etc/crontab
rsync -avz --progress 107.170.96.220:/etc/httpd/* /etc/httpd/
rsync -avz --progress 107.170.96.220:/etc/nagios/* /etc/nagios
rsync -avz --progress 107.170.96.220:/etc/hosts.allow /etc/
rsync -avz --progress 107.170.96.220:/etc/hosts.deny /etc/
