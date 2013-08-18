read -p " Destination Server IP :- " remote_host;

echo " Checking For The Keys "

hostname=$(hostname)
Key=$(grep -s $hostname /root/.ssh/id_rsa.pub | wc -l)
if [ "$Key" -le 0 ]; then
echo " No Keys Found.... Generating New KEY"
ssh-keygen -t rsa -b 1024 -f /root/.ssh/id_rsa -N ""
else
echo "Key Exists"
fi

echo "Copying The Key"
read -p "Detestation Server SSH Port :- " remote_port;
cat /root/.ssh/id_rsa.pub | ssh root@$remote_host -p$remote_port " cat >> /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys"
mkdir -p /home/Migration;

\ls /var/cpanel/users/ > /home/Migration/list.txt
echo 'for i in `cat /home/Migration/list.txt`;do /scripts/restorepkg --cpuser /home/Migration/cpmove-$i.tar.gz;done' > /home/Migration/migration.sh

for i in `cat /home/Migration/list.txt`;do /scripts/pkgacct --skiphomedir "$i" /home/Migration/;done

rsync -vrplogDtH -e "ssh -p $remote_port" /home/Migration root@$remote_host:/home/;

ssh root@$remote_host -p $remote_port 'sh /home/Migration/migration.sh'

echo "Performing Final Sync"
for i in `cat /home/Migration/list.txt`;do rsync -vrplogDtH -e "ssh -p $remote_port" /home/$i root@$remote_host:/home/;done

echo "Migration Completed !!!"
