#!/bin/bash

echo "BEGIN Set VM timezone and perform some cleanup pre-install ..."

# set server timezone
echo $1 | ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime

# a little housekeeping
echo "... Doing a little housekeeping ..."
yum update &>> /vagrant/log/install.txt

echo "... END Set VM timezone and perform some cleanup pre-install."
echo " "