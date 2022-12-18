#!/bin/bash
##
#LINK="https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-instances.html"
######################
VERSION="1.0"
AWS_CONFIG_FILE="$HOME/.aws/credentials"


function test_aws_credentials(){

  if [[ ! -s "${AWS_CONFIG_FILE}" ]]; then
    echo "input the AWS ACCESS KEY ID:"
    read aws_access_key_id
    echo "input the AWS SECRET ACCESS KEY:"
    read aws_secret_access_key
  fi
  export AWS_ACCESS_KEY_ID="${aws_access_key_id}"
  export AWS_SECRET_ACCESS_KEY="${aws_secret_access_key}"
}

function usage
{
    echo -e "aws ec2 list instances v$VERSION"
    echo -e "Hani @hanihammadeh\n"
    echo -e "Usage: $0 [PARAMETERS]..."
    echo -e "\nPARAMETERS:"

    echo -e "\t --type   for example t2.micro"
    echo -e "\t --status running|stopped|pending|terminated"
    echo -e "\t --name   ec2 instance name"
    exit 1
}

#########################################
##### START #############################
#########################################

# Check if the AWS CLI is installed
if ! command -v aws > /dev/null; then
  echo "AWS CLI is not installed. Please install it and try again."
  exit 1
fi
test_aws_credentials
echo $AWS_ACCESS_KEY_ID
# Set default values for filtering options
name_filter=""
type_filter=""
status_filter=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --name)
      name_filter="$2"
      shift 2
      ;;
    --type)
      type_filter="$2"
      shift 2   
      ;;
    --status)
      status_filter="$2"
      shift 2
      ;;
    --help)
      usage
      ;;
    *) # unknown option
      echo "Invalid option -: $key"
      usage
      exit 1
      ;;
  esac
done

# Set the filters for the AWS CLI command
filters=""
if [[ -n $name_filter ]]; then
  filters="$filters Name=tag:Name,Values=$name_filter"
fi
if [[ -n $type_filter ]]; then
  filters="$filters Name=instance-type,Values=$type_filter"
fi
if [[ -n $status_filter ]]; then
  filters="$filters Name=instance-state-name,Values=$status_filter"
fi

# Get a list of all EC2 instances
aws ec2 describe-instances --filters $filters --query \
"Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key=='Name']|[0].Value,\
Status:State.Name,Type:InstanceType,Environment:Tags[?Key=='env']|[0].Value}" \
--output table

