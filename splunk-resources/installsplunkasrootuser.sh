#!/bin/bash

# Tested on CentOS 7

# Variables

SPLUNK_HOME=/opt/splunk

# You can manually specify a password here, 
# instead of the script prompting you 
# (or you don't want to use the user-seed.conf method)
# NOTE: THIS IS INSECURE. USE ONLY FOR TESTING PURPOSES!

# If using user-seed.conf, uncomment this line
#splunkuserpassword=`cat user-seed.conf | grep PASSWORD | awk '{print $3;}'`

# If manually specifying a password, uncomment this
splunkuserpassword=Splunk.5

hostname=splunk                                                




# VERSION 8.2.0
splunkpackagefilename=splunk-8.2.0.tgz
splunkpackagedownload="wget -O $splunkpackagefilename https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.2.0&product=splunk&filename=splunk-8.2.0-e053ef3c985f-Linux-x86_64.tgz&wget=true"


# Installs wget
if [ ! -x /usr/bin/wget ] ; then                                                                          
    command -v wget >/dev/null 2>&1 || command sudo yum -y install wget
fi



# This section deals with $SPLUNK_HOME
# if it's found, try to stop splunkd, then
# rename + move the existing Splunk install


if [ -x $SPLUNK_HOME ] ; then
    echo "$SPLUNK_HOME found, renaming and moving to /tmp/";
    sudo $SPLUNK_HOME/bin/splunk stop
    sudo mv -v $SPLUNK_HOME /tmp/splunk_$(date +%d-%m-%Y_%H:%M:%S)
else
    echo "$SPLUNK_HOME not found, progressing with installation..."
fi

sudo mkdir $SPLUNK_HOME

# This section deals with $splunkpackagefilename
# if it's found, proceed with installation
# if it's not found, download it

if [ -a ./$splunkpackagefilename ] ; then
    echo "$splunkpackagefilename found, progressing with installation";
else
    echo "$splunkpackagefilename not found, downloading..."
    $splunkpackagedownload
fi


# Untar the package
sudo tar -xzvC /opt -f $splunkpackagefilename

# Takes ownership of $SPLUNK_HOME to root
sudo chown -vR root $SPLUNK_HOME                                                             


# Starts splunk as $splunkuser, still needs password input, admin acct not created
# Required if using the $splunkuserpassword variable above
sudo $SPLUNK_HOME/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd $splunkuserpassword                                               

# Starts splunk as root, auto generates password
#sudo $SPLUNK_HOME/bin/splunk enable boot-start --accept-license --answer-yes --no-prompt

# Copies user-seed.conf so our preferred password is set
#sudo cp ./user-seed.conf $SPLUNK_HOME/etc/system/local/user-seed.conf

# Add license from local license file
sudo $SPLUNK_HOME/bin/splunk add licenses ./license.lic -auth admin:$splunkuserpassword

# Set default hostname and servername
sudo $SPLUNK_HOME/bin/splunk set default-hostname $hostname
sudo $SPLUNK_HOME/bin/splunk set servername $hostname

sudo $SPLUNK_HOME/bin/splunk restart

# Cleanup items, uncomment to enable
echo "Performing cleanup actions..."
unset splunkuserpassword
#sudo rm -f ./user-seed.conf
sudo rm -f ./$splunkpackagefilename
#sudo rm -f ./license.lic