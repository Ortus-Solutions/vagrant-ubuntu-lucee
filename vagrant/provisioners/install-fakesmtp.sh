#!/bin/bash

echo "================= START install-fakesmtp.sh $(date +"%r") ================="
echo " "
echo "BEGIN installing FakeSMTP"

##############################################################################################
## SMTP Installation
##############################################################################################
VERSION="2.0"

# Check if we have it installed
if [ ! -f "/opt/smtp/fakeSMTP-$VERSION.jar" ]; then
	
	# Don't download if we've already got it locally
	if [ ! -f "/vagrant/artifacts/fakeSMTP-$VERSION.jar" ]; then
		echo "... Downloading fakeSMTP-$VERSION, standby ..."
		wget -O /vagrant/artifacts/fakeSMTP-$VERSION.jar http://downloads.ortussolutions.com/nilhcem/fakeSMTP/$VERSION/fakeSMTP-$VERSION.jar &>> /vagrant/log/install.txt
	fi

	# Install it
	sudo mkdir -p /opt/fakeSMTP/output
	sudo /bin/cp -f /vagrant/artifacts/fakeSMTP-$VERSION.jar /opt/fakeSMTP
	echo "FakeSMTP installed successfully"
else
	echo "FakeSMTP is already installed, skipping"
fi

# Run fake SMTP Server
echo "Starting up FakeSMTP server on port 2525, output: /opt/fakeSMTP/output"
java -jar /opt/fakeSMTP/fakeSMTP-$VERSION.jar --start-server --background --port 2525 --output-dir /opt/fakeSMTP/output &

echo "... END installing fake SMTP."
echo " "
echo "================= FINISH install-fakesmtp.sh $(date +"%r") ================="
echo " "
