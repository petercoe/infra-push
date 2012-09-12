#!/bin/bash

KEYNAME=$1

if [ -z "$KEYNAME" ]
then
    echo "You must specify a key name"
exit 1

fi

ec2-add-keypair $KEYNAME.keypair >  ~/.ssh/$KEYNAME.pem
chmod 600  ~/.ssh/$KEYNAME.pem
echo "Add the following to your environment:"
echo "csh/tcsh:"
echo setenv EC2_KEYPAIR_NAME $KEYNAME.keypair
echo "sh/bash:"
echo "export EC2_KEYPAIR_NAME=$KEYNAME.keypair"
