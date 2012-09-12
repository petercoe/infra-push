#!/bin/sh

createInstance()
{
    Instance=`ec2-run-instances ami-43ddf806 --instance-type t1.micro --region us-west-1 -k ${Keyname}.keypair | egrep INSTANCE | awk '{print $2}'`

    Seconds=0
    until [ "`ec2-describe-instance-status ${Instance} | egrep SYSTEMSTATUS | awk '{print $3}'`" == 'passed' ]
    do
        echo "Waiting for startup - ${Seconds} Seconds"
        sleep 5
        Seconds=`expr ${Seconds} + 5`
    done

    ec2addtag --region us-west-1 ${Instance} -t Name=Host-${Host}
    Hostname=`ec2-describe-instances ${Instance} | egrep INSTANCE | awk '{print $4}'`
    ssh -i ${HOME}/.ssh/${Keyname}.pem -o "StrictHostKeyChecking no" ubuntu@${Hostname} sudo chown -R ubuntu /var/www
    sed "s%HOSTNAME%${Hostname}%g" < home.shtml > home.html
    scp -p -i ${HOME}/.ssh/${Keyname}.pem home.html ubuntu@${Hostname}:/var/www
    echo ${Instance} ${Hostname} >> hosts.txt
    echo "Host-${Host} - ${Hostname} Complete"
}

Keyname=$1
Instances=$2
loadBalancer=infra-push

if [ -z "${Keyname}" ]
then
    echo "You must specify a key name"
    exit 1
fi

if [ -z "${Instances}" ]
then
    Instances=0
fi

Host=1
cat /dev/null > hosts.txt
rm home.html

while [ ${Host} -le ${Instances} ]
do
    createInstance ${Keyname} ${Host} 
    Host=`expr ${Host} + 1`
done
instanceIds=`cat hosts.txt | sed -e's% .*%,%'`
elb-create-lb ${loadBalancer} -region us-west-1 -availability-zones us-west-1a,us-west-1b -listener "protocol=http,lb-port=80,instance-port=80"
elb-register-instances-with-lb ${loadBalancer} -region us-west-1 -instances ${instanceIds}
