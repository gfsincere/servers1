#! /bin/bash
for i in `cat users.txt`; do /scripts/pkgacct $i; done
scp -r /home/cpmove* root@69.65.41.83:/home
echo "Account backups done" > email.txt
mail -vv -s "Account backups done" youjoomla@gmail.com < email.txt
