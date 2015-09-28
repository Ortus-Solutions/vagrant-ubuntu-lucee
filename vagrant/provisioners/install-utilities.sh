#!/bin/bash

echo "================= START INSTALL-UTILITIES.SH $(date +"%r") ================="
echo " "
echo "BEGIN installing utilities"

# install some common utilities
if [ ! -f /var/log/utils_installed ]; then
	echo "... Installing miscellaneous/common utilities ..."

	yum install perl -y &>> /vagrant/log/install.txt
	yum install wget -y &>> /vagrant/log/install.txt
	yum install nano -y &>> /vagrant/log/install.txt
	yum install curl -y &>> /vagrant/log/install.txt
	yum install zip -y &>> /vagrant/log/install.txt
	yum install unzip -y &>> /vagrant/log/install.txt
	yum install net-tools -y &>> /vagrant/log/install.txt

	#echo "... Installing WebMin ..."
	#wget -O /root/jcameron-key.asc http://www.webmin.com/jcameron-key.asc &>> /vagrant/log/install.txt
	#rpm --import /root/jcameron-key.asc
	#cp /vagrant/configs/webmin.repo /etc/yum.repos.d/
	#yum install webmin -y &>> /vagrant/log/install.txt

	touch /var/log/utils_installed
fi

echo "... END installing utilities."
echo " "
echo "================= FINISH INSTALL-UTILITIES.SH $(date +"%r") ================="
echo " "
