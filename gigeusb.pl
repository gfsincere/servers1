#!/usr/bin/perl
##
## Creates a GigeUSB Drive
## But it doesn't have to be USB
## So why is USB in the name ?????
##
## gigeusb Version 1.0b
## it's super dirty, but easy enough for anybody to use and/or change and it is pretty safe ( no guarentee's! )
## aroman..
##
## gigeusb Version 1.1b
## Updated drivers / firmware and put to NOCshare
## aguimont..

##############################################
## Checks to see if a device name was given ##
##############################################

if ($#ARGV != 0) {
        print "\nUsage: ./gigeusb.pl /dev/sd[a-z]\n\n";
                exit; }


$gigeusb           =  $ARGV[0];
$gigeusbp          =  "1";
$gigefileloc       =  "/tmp/gigeusb.tgz";
$gigefiles         =  "/tmp/GigeUSB";
$gigeusbfiles      =  "/tmp/GigeUSB/GigeUSBfiles";
$gigefilesurl      =  "http://192.168.203.10/GigeUSB/gigeusb.tgz";
$gigeusbmount      =  "/tmp/gigeusbmount";
$obtainfiles       =  "wget -O $gigefileloc $gigefilesurl";
$extractfiles      =  "tar xvfz $gigefileloc -C /tmp/";
$chkmnt            =  `mount | grep $gigeusb`;
$chkmnt2           =  "df | grep $gigeusb$gigeusbp | awk '{ print $7 }'";
$mkpart            =  "printf 'n\np\n1\n\n\nt\nc\na\n1\nw\n' | fdisk -cu $gigeusb";
$mkusbfs           =  "mkfs.vfat -F 32 -n GigeUSB $gigeusb$gigeusbp";
$crmbr             =  "$gigefiles/bootlace.com  --time-out=0 $gigeusb";
$gigeumount        =  "umount $gigeusb$gigeusbp";
$cpfiles           =  "cp -a -R /tmp/GigeUSB/GigeUSBfiles/* $gigeusbmount";


#####################
## Checks for root ##
#####################

if ($uid != 0) {
        print "\nMust Be root, Exiting...\n";
                exit; }

#########################################################################################
## Checks to make sure the device exist                                                ##
## Uses a -b file test operator to make sure the device given is indeed a block device ##
#########################################################################################

if (-b $gigeusb) {
        print "\n$gigeusb Has Been Located.\n"; }
                else {
                        print "\n$gigeusb Can Not Be Located. Exiting...\n";
                                 exit; }

###################################################
## Checks to make sure the device is not mounted ##
###################################################

if ($chkmnt eq "") {
        print "$gigeusb Does Not Look Mounted.\n\nAssuming It's Safe To Use...\n";
                 } else {
                  print "\nDrive Is Mounted. Exiting...\n";
                                 exit; }

#################################################################
## Text warning to cancel before any further actions are taken ##
#################################################################

print "\n*******WARNING*********************WARNING*******\n";
print "ALL EXISTING DATA ON $gigeusb WILL BE DESTROYED!!\n";
print "Press CTRL+C Within 5 seconds to abort.\n";
print "ALL EXISTING DATA ON $gigeusb WILL BE DESTROYED!!\n";
print "*******WARNING*********************WARNING*******\n";
sleep 5;

#######################
## Clears partitions ##
#######################

print "\nClearing Partitions...\n";
	system("parted $gigeusb rm 1 &>/dev/null; parted $gigeusb rm 2 &>/dev/null; parted $gigeusb rm 3 &>/dev/null; parted $gigeusb rm 4 &>/dev/null");
        	sleep 1;

###############################################
## Makes one solid Boot-able Fat32 Partition ##
## from B.Tong  -  Thanks!                   ##
###############################################

print "\nMaking Bootable Partition and Formatting...\n";
	system("$mkpart > /dev/null 2>&1");
		sleep 1;

###############################
## Formats the new partition ##
###############################

system("$mkusbfs > /dev/null 2>&1");
	sleep 1;

########################################
## Retrieves and extract files needed ##
########################################

print "\nDownloading The Necessary Files...\n";
	system("$obtainfiles > /dev/null 2>&1");
        	print "\nExtracting The Necessary Files...\n";
                	system("$extractfiles > /dev/null 2>&1"); 

#############################
## Creates MBR for Device  ##
#############################

print "\nCreating MBR On $gigeusb\n";
	system("$crmbr > /dev/null 2>&1");
		sleep 2;

#####################################################
## Makes the directory needed for GigeUSB creation ##
#####################################################

print "\nCreating Directories Needed...\n";
	unless(-d $gigeusbmount){
                mkdir $gigeusbmount or die; }
       			sleep 1;

#################################################
## Mounts the new partition prep for file copy ##
#################################################

system("mount $gigeusb$gigeusbp $gigeusbmount > /dev/null 2>&1");
        sleep 1;

#############################################################################################
## Checks the mount to make sure we copy files to the drive and not the systems hard drive ##
#############################################################################################

if ($chkmnt = $gigeusbmount) {
       	print "\n$gigeusb$gigeusbp Has Been Mounted.\n";
               	} else {
                       	 print "$gigeusb$gigeusbp Could Not Be Mounted.. Exiting...\n";
                               	 exit; }

######################################
## Copies Files needed to the Drive ##
######################################

print "\nTransferring Files...\n";
	system("$cpfiles > /dev/null 2>&1");
		sleep 1;

##################################
## Unmount Drive and Cleaning Up##
##################################

print "\nUnmounting $gigeusb$gigeusbp And Cleaning Up...\n";
	system("$gigeumount > /dev/null 2>&1");
		sleep 1;
			system("$cleanup");




print "\nYour GigeUSB Is Ready For Use!\n";

