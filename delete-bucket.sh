#!/bin/sh

buckets="$(aws s3api list-buckets | jq -r ".Buckets[].Name")"

for bk in $buckets;
do
        echo "${bk}"
        echo "-----"
	echo "$(aws s3api delete-bucket --bucket ${bk})"
        echo ""
done
