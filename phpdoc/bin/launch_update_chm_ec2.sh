#!/bin/bash

yesterday=`date -d '1 days ago' +%Y-%m-%d`
echo $yesterday

period='86400'
statistics='Maximum'

billing=`aws --region us-east-1 cloudwatch get-metric-statistics \
  --namespace 'AWS/Billing' \
  --dimensions 'Name=Currency,Value=USD' \
  --metric-name EstimatedCharges \
  --start-time "${yesterday} 00:00:00" \
  --end-time "${yesterday} 23:59:59" \
  --period ${period} --statistics "${statistics}" \
  | jq ".Datapoints[].${statistics}"`

if [ $(echo "${billing}>10"| bc) -eq 0 ]; then
    echo "current aws total cost : ${billing} USD"
    aws ec2 start-instances --instance-ids i-0ec97f3ae41431164
else
    echo "we cannot launch chm update instance, because aws costs too much!!!! : ${billing} USD"
    exit 1;
fi
