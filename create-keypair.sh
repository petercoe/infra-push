#!/bin/bash

Keyname=$1

if [ -z "$Keyname" ]
then
    echo "You must specify a key name"
exit 1

fi

ec2-add-keypair $Keyname.keypair >  ~/.ssh/$Keyname.pem
chmod 600  ~/.ssh/$Keyname.pem
echo "Add the following to your environment:"
echo "csh/tcsh:"
echo setenv EC2_KEYPAIR_NAME $Keyname.keypair
echo "sh/bash:"
echo "export EC2_KEYPAIR_NAME=$Keyname.keypair"

