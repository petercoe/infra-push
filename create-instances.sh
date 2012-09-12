#!/bin/sh

#
# Script to create a somewhat arbitary number of EC2 instances
# and place them behind an Elastic Load Balancer
#

createInstance()
{
    #
    # Create an instance on EC2 
    #   ami-43ddf806 is a 64 bit Ubuntu 12.04 LTS server preconfigured with
    #   Apche
    #
    Instance=`ec2-run-instances ami-43ddf806 --instance-type t1.micro --region us-west-1 -k ${Keyname}.keypair | egrep INSTANCE | awk '{print $2}'`

    # 
    # Check status of Instance, and wait until the server is up 
    # and running
    #
    Seconds=0
    until [ "`ec2-describe-instance-status ${Instance} | egrep SYSTEMSTATUS | awk '{print $3}'`" = 'passed' ]
    do
        echo "Waiting for startup - ${Seconds} Seconds"
        sleep 5
        Seconds=`expr ${Seconds} + 5`
    done

    #
    # Add a descriptive tag to the server
    #
    ec2addtag --region us-west-1 ${Instance} -t Name=${Keyname}-${Host}
    Hostname=`ec2-describe-instances ${Instance} | egrep INSTANCE | awk '{print $4}'`
    #
    # Change permissions on the DocumentRoot for easy pushing
    #
    ssh -i ${HOME}/.ssh/${Keyname}.pem -o "StrictHostKeyChecking no" ubuntu@${Hostname} sudo chown -R ubuntu /var/www

    #
    # Copy the html up to the server, and tag it with hostname
    #
    sed "s%HOSTNAME%${Hostname}%g" < home.shtml > home.html
    scp -p -i ${HOME}/.ssh/${Keyname}.pem home.html ubuntu@${Hostname}:/var/www
    echo ${Instance} ${Hostname} >> ${Keyname}-hosts.txt
    echo "${Keyname}-${Host} - ${Hostname} Complete"
}

#
# MAIN
#
Keyname=$1
Instances=$2

if [ -z "${EC2_KEYPAIR_NAME}" ]
then
    echo "Error: Set $EC2_KEYPAIR_NAME in environment to your registered keypair from create-keypair.sh"
fi

if [ -z "${Keyname}" ]
then
    echo "You must specify a key name"
    echo "Usage: create-instances.sh <Keyname> [Instances (defaults to 4)]"
    exit 1
fi

if [ -z "${Instances}" ]
then
    Instances=4
fi

loadBalancer=${Keyname}
Host=1
cat /dev/null > ${Keyname}-hosts.txt
rm -f home.html

#
# Create the specified number of instances
#
while [ ${Host} -le ${Instances} ]
do
    createInstance ${Keyname} ${Host} 
    Host=`expr ${Host} + 1`
done

#
# Create the Elastic Load Balancer
#
instanceIds=`cat ${Keyname}-hosts.txt | sed -e's% .*%,%'`
loadBalancerDNSName=`elb-create-lb ${loadBalancer} --region us-west-1 --availability-zones us-west-1a,us-west-1b --listener "protocol=http,lb-port=80,instance-port=80" | sed 's%.* %%'`

#
# Register Instances with Load Balancer
#
echo "Creating Loadbalancer: ${loadBalancer}"
elb-register-instances-with-lb ${loadBalancer} --region us-west-1 --instances ${instanceIds}

echo "Waiting for Loadbalancer to be ready"
elb-describe-instance-health --region us-west-1 --headers --lb ${loadBalancer}
echo elb-describe-instance-health --region us-west-1 --headers --lb ${loadBalancer}
echo "Loadbalancer ready"
echo "Hosts:"

for host in `cat ${Keyname}-hosts.txt | sed -e's%.* %%'`
do
    echo "\t${host}"
done

echo "Loadbalancer: ${loadBalancerDNSName}"
echo "Loadbalancer not yet in service.  Use following command to check status:"
echo "\telb-describe-instance-health --region us-west-1 --lb ${loadBalancer}"
exit
