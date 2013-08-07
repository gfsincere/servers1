#! /bin/bash
for i in `cat users.txt`; do /scripts/pkgacct $i; done
echo "Account backups done" > email.txt
mail -vv -s "Account backups done" greg.thomas@gmail.com < email.txt
