#!/usr/bin/env bash

SENTORA_UPDATER_VERSION="1.0.3"
PANEL_PATH="/etc/sentora"
PANEL_DATA="/var/sentora"

# Check if the user is 'root' before updating
if [ $UID -ne 0 ]; then
    echo "Install failed: you must be logged in as 'root' to install."
    echo "Use command 'sudo -i', then enter root password and then try again."
    exit 1
fi
# Ensure the OS is compatible with the launcher
if [ -f /etc/centos-release ]; then
    OS="CentOs"
    VERFULL=$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)
    VER=${VERFULL:0:1} # return 6 or 7
elif [ -f /etc/lsb-release ]; then
    OS=$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')
    VER=$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')
else
    OS=$(uname -s)
    VER=$(uname -r)
fi
ARCH=$(uname -m)

echo "Detected : $OS  $VER  $ARCH"

### Ensure that sentora is installed
if [ -d /etc/sentora ]; then
    echo "Found Sentora, processing"
else
    echo "Sentora is not installed, aborting..."
    exit 1
fi

## If OS is CENTOS 7 then perform update
if [[ "$OS" = "CentOs" ]]; then

if [[ "$VER" = "6" ]]; then
        
	echo"Starting update"	

	# Update PHP to PHP 5.6 with Sushin

	yum install epel*
	yum update
	yum upgrade

	#Add repo source - CentOS and Red Hat Enterprise Linux 6.x
	wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm 
	sudo rpm -Uvh remi-release-6*.rpm
	
	yum update
	yum upgrade

	yum --enablerepo=remi,remi-php56 update
	yum --enablerepo=remi,remi-php56 upgrade

	cd /tmp
	# OLD - wget -nv -O suhosin.zip https://github.com/Dukecitysolutions/sentora-upgrade-scripts/blob/master/suhosin-0.9.38.zip
	wget -nv -O suhosin.zip http://zppy-repo.dukecitysolutions.com/repo/centos_php56/suhosin-0.9.38.zip
	unzip -q suhosin-0.9.38.zip
	cd suhosin-0.9.38
	phpize &> /dev/null
	./configure &> /dev/null
	make &> /dev/null
	make install 

	#Reboot System
	#reboot


    elif [[ "$VER" = "7" ]]; then
        
	echo"Starting update"	

	# Update PHP to PHP 5.6 with Sushin

	yum install epel*
	yum update
	yum upgrade

	#Add repo source - CentOS and Red Hat Enterprise Linux 6.x

	wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm 
	sudo rpm -Uvh remi-release-7*.rpm
	
	yum update
	yum upgrade

	yum --enablerepo=remi,remi-php56 update
	yum --enablerepo=remi,remi-php56 upgrade

	cd /tmp
	# OLD -wget -nv -O suhosin.zip https://github.com/Dukecitysolutions/sentora-upgrade-scripts/blob/master/suhosin-0.9.38.zip
	wget -nv -O suhosin.zip http://zppy-repo.dukecitysolutions.com/repo/centos_php56/suhosin-0.9.38.zip
	unzip -q suhosin-0.9.38.zip
	cd suhosin-0.9.38
	phpize &> /dev/null
	./configure &> /dev/null
	make &> /dev/null
	make install 

	#Reboot System
	#reboot

    else
        
	#add something here for non-Centos OS
	echo "Wrong OS. Exiting update."
	exit 1

    fi
fi

echo "We are done updating PHP to PHP 5.6 with SUHOSIN version-0.9.38"
