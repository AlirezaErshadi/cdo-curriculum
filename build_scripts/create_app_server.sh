#!/bin/bash

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
--instance-type t1.micro --key-name production-code-org \
--security-groups website-dashboard --region $region | json_value InstanceId`

#ec2-create-tags $instance_id --tag name=$1
aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=$1 --region $region > /dev/null

public_dns="null"
while [ $public_dns = "null" ] ; do
  ret_val=`aws ec2 describe-instances --region $region \
  --instance-ids $instance_id`
  public_dns=`echo "$ret_val" | json_value PublicDnsName`
  sleep 2
done

echo "Launched new machine with public dns: $public_dns"
