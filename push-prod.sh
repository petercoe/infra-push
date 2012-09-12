#!/bin/sh

#
# Push the specified file out to the production hosts for Keyname
#
Keyname=$1

if [ -z "${Keyname}" ]
then
    echo "You must specify a Keyname"
    echo "Usage: create-instances.sh <Keyname> [Instances (defaults to 4)]"
    exit 1
fi

#
# Push code to production
#
if [ -f $2 ]
then
    for host in `cat ${Keyname}-hosts.txt | sed -e's%.* %%'`
    do
        echo "\t${host}"
        scp -p -i ${HOME}/.ssh/${Keyname}.pem $1 ubuntu@${Hostname}:/var/www
    done
else
    echo "$1 does not exist"
fi
exit
