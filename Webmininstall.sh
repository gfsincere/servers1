#!/bin/bash
#Script to add Webmin
#
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#grabbing RHEL EPEL repo rpms
wget http://prdownloads.sourceforge.net/webadmin/webmin-1.660-1.noarch.rpm
#Installing RPMs
rpm -Uvh webmin-1.660-1.noarch.rpm
exit 0
