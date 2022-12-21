#!/bin/bash

# Set the AWS region
export AWS_REGION=$1

# List all the S3 buckets

function usage(){
echo "Usage: $0 <REGION NAME>"
}
# Check if the required number of arguments was provided
if [ $# -lt 1 ]; then
    usage
    echo " The REGION should be provided, the defualt value is us-east-1"
    export AWS_REGION=us-east-1
fi

aws s3 ls
