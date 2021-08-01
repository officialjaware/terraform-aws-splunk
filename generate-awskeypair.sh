#!/bin/bash


awsregion=us-west-2
keyname=test3
keyexportlocation=~/.ssh

touch $keyexportlocation/$keyname.pem
aws ec2 create-key-pair --region $awsregion --key-name $keyname --query 'KeyMaterial' --output text > "$keyexportlocation/$keyname.pem"

chmod 400 "$keyexportlocation/$keyname.pem"

# Uncomment to delete the keypair created by this script
#aws ec2 delete-key-pair --region $awsregion --key-name $keyname
