#!/bin/bash

STATUS=`aws ec2 describe-instance-status --instance-id i-0ec97f3ae41431164 | jq -r '.InstanceStatuses[0].InstanceState.Name'`

if [ ${STATUS} = 'running' ]; then
    echo "error!! still running chm builder instances!!!!"
    exit 1
fi
