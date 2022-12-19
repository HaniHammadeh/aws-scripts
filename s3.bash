#!/bin/bash


function usage(){
echo "Usage: $0 bucket_name command [arguments]"
exit 1
}
# Check if the required number of arguments was provided
if [ $# -lt 2 ]; then
    usage
fi

# Set the name of the S3 bucket
BUCKET_NAME=$1

# Shift the arguments to access the command and any additional arguments
shift

COMMAND=$1

case $COMMAND in
    "ls")
        # List the objects in the bucket
        aws s3 ls s3://$BUCKET_NAME
        ;;
    "upload")
        # Check if the required number of arguments was provided
        if [ $# -lt 3 ]; then
            echo "Usage: $0 bucket_name upload local_file remote_file"
            exit 1
        fi

        # Upload a local file to the bucket
        aws s3 cp $2 s3://$BUCKET_NAME/$3
        ;;
    "download")
        # Check if the required number of arguments was provided
        if [ $# -lt 3 ]; then
            echo "Usage: $0 bucket_name download remote_file local_file"
            exit 1
        fi

        # Download a file from the bucket
        aws s3 cp s3://$BUCKET_NAME/$2 $3
        ;;
    "delete")
        # Check if the required number of arguments was provided
        if [ $# -lt 2 ]; then
            echo "Usage: $0 bucket_name delete remote_file"
            exit 1
        fi

        # Delete an object from the bucket
        aws s3 rm s3://$BUCKET_NAME/$2
        ;;
    "create")
        # Create a new bucket
        echo $BUCKET_NAME will be created
        aws s3 mb s3://$BUCKET_NAME
        ;;
    "delete-bucket")
        # Delete an empty bucket
        aws s3 rb s3://$BUCKET_NAME
        ;;
    "sync")
        # Check if the required number of arguments was provided
        if [ $# -lt 3 ]; then
            echo "Usage: $0 bucket_name sync local_dir remote_dir"
            exit 1
        fi

        # Sync a local directory with a bucket
        aws s3 sync $2 s3://$BUCKET_NAME/$3
        ;;
    "copy")
        # Check if the required number of arguments was provided
        if [ $# -lt 4 ]; then
            echo "Usage: $0 bucket_name copy source_file destination_file"
            exit 1
        fi

        # Copy an object within the same bucket
        aws s3 cp s3://$BUCKET_NAME/$2 s3://$BUCKET_NAME/$3
        ;;
    "info")
        # Check if the required number of arguments was provided
        if [ $# -lt 2 ]; then
            echo "Usage: $0 bucket_name info remote_file"
            exit 1
        fi
        aws s3api get-object-attributes \
            --bucket my-bucket \
            --key doc1.rtf \
            --object-attributes "StorageClass" "ETag" "ObjectSize"
        # Display information about an object
        ;;
    *)
        usage
        ;;
esac
