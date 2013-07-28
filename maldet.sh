# To install Screen and Maldet on Servers
#!/bin/bash
#Server hardening script written by Sincere the Minotaur
if [[ $EUID -ne 0 ]]; then
echo "This script must be run as root"
   exit 1
fi
echo "---------------------------------"
echo ""
echo "Installing screen and maldet to server"
echo ""
echo ""
echo "---------------------------------"
#grabbing screen
yum install screen -y
#grabbing maldet
wget http://www.rfxn.com/downloads/maldetect-current.tar.gz
tar -xzf maldetect-current.tar.gz
cd maldetect-1.4.2
sh install.sh
echo "--------------------------------------------------------------------"
echo ""
echo ""
echo "Maldet and screen successfully installed and enabled. Written by the Minotaur."
echo ""
echo ""
echo "---------------------------------------------------------------------"
#Running the maldet automagically
read -r -p "Would you like to run the scan now? [Y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	screen -d -m -S "maldet" maldet -a /
	screen -r maldet
else
	exit 0
fi
	
