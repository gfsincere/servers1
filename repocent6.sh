#!/bin/bash
#Script to add RHEL EPEL Repos to CentOS 6
#
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
echo "---------------------------------"
echo "Adding RHEL Repos to the server!"
echo ""
echo ""
echo "---------------------------------"
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
echo "Repos successfully installed and enabled. Written by the Minotaur."
echo ""
echo ""
echo "---------------------------------------------------------------------"

exit 0
