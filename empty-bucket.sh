#!/bin/sh

buckets="$(aws s3api list-buckets | jq -r ".Buckets[].Name")"

for bk in $buckets;
do
        echo "${bk}"
        echo "-----"
	echo "$(aws s3 rm s3://${bk} --recursive)"
        echo ""
done
