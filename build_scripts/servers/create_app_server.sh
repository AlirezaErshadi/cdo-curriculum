#!/bin/bash

GIT_ROOT=`git rev-parse --show-toplevel`
SERVERS="$GIT_ROOT/build_scripts/servers"

if [ $# -lt 1 ]
then
  echo "usage: $0 <name>"
  echo "a human readable name to call the machine by"
  echo "You must have the production pem file. Please contact a system ops dev for this."
  exit 0
fi

region="us-east-1"

# Accepts json as stdin and one argument for the key.
json_value() {
  grep $1 | perl -pe 's/.*: ("?)(.*)\1,/\2/'
}

instance_id=`aws ec2 run-instances --image-id ami-a73264ce --count 1 \
--instance-type m1.medium --key-name production-code-org \
--security-groups website-dashboard --region $region | json_value InstanceId`

#ec2-create-tags $instance_id --tag name=$1
aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=$1 --region $region > /dev/null

echo "Machine created with instance id: $instance_id and name: $1"
echo "Pinging aws for dns, this may take a minute..."

public_dns="null"
while [ $public_dns = "null" ] ; do
  ret_val=`aws ec2 describe-instances --region $region \
  --instance-ids $instance_id`
  public_dns=`echo "$ret_val" | json_value PublicDnsName`
  sleep 2
done

echo "Installing dependencies on $public_dns"

ssh_cmd="ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/production-code-org.pem"

until $ssh_cmd $public_dns echo 'sshed successfully'
do
 echo "Waiting for $public_dns to respond."
 sleep 3
done
$ssh_cmd $public_dns 'sudo bash -s' < $SERVERS/apt_packages.sh
$ssh_cmd $public_dns 'sudo bash -s' < $SERVERS/packages.sh

echo $public_dns
