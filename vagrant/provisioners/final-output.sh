#!/bin/bash

echo "================= START FINAL-OUTPUT.SH $(date +"%r") ================="
echo " "
echo "Doing some last minute cleanup ..."



##############################################################################################
## Restarting
##############################################################################################

echo "... Restarting Lucee ..."
service lucee_ctl restart &>> /vagrant/log/install.txt

echo "... Restarting Nginx..."
sudo service nginx restart &>> /vagrant/log/install.txt

echo "... Restarting networking..."
sudo service network restart &>> /vagrant/log/install.txt


# some final housekeeping
yum update &>> /vagrant/log/install.txt

sudo rm /root/*.run &>> /vagrant/log/install.txt
sudo rm /root/lucee-options.txt &>> /vagrant/log/install.txt

# Gid rid of firewalld
systemctl stop firewalld &>> /vagrant/log/install.txt
systemctl disable firewalld &>> /vagrant/log/install.txt

echo " "
echo "================= END FINAL-OUTPUT.SH $(date +"%r") ================="
echo " "
echo " "
echo "$1"
echo " "
echo "========================================================================"
echo " "
echo "http://$2 ($3)"
echo " "
echo "Lucee Server/Web Context Administrators"
echo " "
echo "http://$2:8888/lucee/admin/server.cfm"
echo "http://$2:8888/lucee/admin/web.cfm"
echo " "
echo " "
echo "Password (for each admin): password"
echo "========================================================================"

echo "Install finished at $(date) " >> /vagrant/log/install.txt