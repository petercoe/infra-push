#!/bin/sh

Usage()
{
    echo "Usage: push-prod.sh <Keyname> <file>"
}

#
# Push the specified file out to the production hosts for Keyname
#
Keyname=$1

if [ $# -ne 2 ]
then
    Usage
    exit 1
fi

if [ -z "${Keyname}" ]
then
    echo "You must specify a Keyname"
    Usage
    exit 1
fi

#
# Push code to production
#
if [ -f $2 ]
then
    for Hostname in `cat ${Keyname}-hosts.txt | sed -e's%.* %%'`
    do
        echo "\t${Hostname}"
        scp -p -i ${HOME}/.ssh/${Keyname}.pem $2 ubuntu@${Hostname}:/var/www
    done
else
    echo "$1 does not exist"
fi
exit
