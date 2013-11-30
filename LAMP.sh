#!/bin/bash
#Script to add RHEL EPEL Repos to CentOS 6
#
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
check input "Do you want to install a LAMP stack and good 3rd party repos to CentOS 6? (yes/no) [Default: yes]" "yes|no" "yes"
query=$INPUTTEXT
if [ "$query" == "no" ]; then
	echo "Exiting"
	echo
	exit 1
fi
echo "---------------------------------"
echo ""
echo "LAMP Stack Automation"
echo "Written by @minossec"
echo "Find me on Twitter or on Github"
echo "www.github.com/gfsincere"
echo "---------------------------------"
sleep 15
#updating CentOS
echo "---------------------------------"
echo ""
echo "Adding RHEL Repos to the server!"
echo ""
echo ""
echo "---------------------------------"
yum update -y
#installing Apache
echo "---------------------------------"
echo ""
echo "Installing Apache"
echo ""
echo ""
echo "---------------------------------"
sleep 10
yum install httpd -y
chkconfig --levels 235 httpd on
service httpd start
#installing PHP
echo "---------------------------------"
echo ""
echo "Installing and configuring PHP"
echo ""
echo ""
echo "---------------------------------"
sleep 10
yum install php php-mysql php-common php-cli -y
#Creates PHP info page
echo -e "<?php\n\tphpinfo();\n?>" > /var/www/html/info.php
service httpd restart
#Installing MySQL
echo "---------------------------------"
echo ""
echo "Installing MySQL"
echo ""
echo ""
echo "---------------------------------"
sleep 10
yum install mysql mysql-server -y
chkconfig --levels 235 mysqld on
echo "Starting MySQL"
echo "..."
sleep 2
echo "..."
sleep 2
echo "..."
sleep 2
echo "..."
sleep 2
service mysqld start
echo "---------------------------------"
echo ""
echo "Adding RHEL Repos to the server!"
echo ""
echo ""
echo "---------------------------------"
sleep 10
#grabbing RHEL EPEL repo rpms
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
#Installing RPMs
rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
# Check to see if repos installed
if [ -f /etc/yum.repos.d/remi.repo ];
then
	echo "----------------------------------"
	echo "Repos installed successfully."
	echo ""
	echo "----------------------------------"
else
	echo "Repo installation failure, please install manually."
	exit 1
fi
# Enabling RPM
sed -i '1,9 s/enabled=0/enabled=1/' /etc/yum.repos.d/remi.repo
echo "--------------------------------------------------------------------"
echo ""
echo ""
echo "Repos successfully installed and enabled. Written by @minossec."
echo ""
echo ""
echo "---------------------------------------------------------------------"

exit 0
