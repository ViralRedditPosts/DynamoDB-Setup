#!/bin/bash
# For copying a file to S3
# 
# Example:
#   ./copyFileToS3.sh -f ../reddit.cfg -b viralredditposts-dev
# if not executable run
#   chmod +x ./gitmerge.sh

while getopts f:b: flag
do
    case "${flag}" in
        f) filename=${OPTARG};;  # ie ../reddit.cfg
        b) bucketname=${OPTARG};;  # ie viralredditposts-dev
    esac
done
: ${filename:?Missing -f} ${bucketname:?Missing -b}  # checks if these have been set https://unix.stackexchange.com/questions/621004/bash-getopts-mandatory-arguments
echo "filename: $filename";
echo "bucketname: $bucketname";

aws s3 cp ${filename} s3://${bucketname}/
