#!/usr/bin/env bash

## Error Handling
##   Append '|| true' to commands that you need to allow to fail.
set -o errexit
set -o pipefail
set -o nounset

## Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

## Include our shell library
. ${__dir}/_setup.sh


#####
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  error "CTRL-C Detected. Exiting...."
  do_exit 255
}

function usage() {
  echo -e "\n${Yel}"
  echo -e "Usage:\n"
  echo -e "    -p | --profile <profile>         Set AWS profile (otherwise uses environment set up)"
  echo -e "    -t | --target <resource_name>    Target individual resource"
  echo -e "    -f | --format <output format>    Output as json | text | table | yaml | yaml-stream"
  echo -e "    -all                             Fetch info all resources"
  echo -e "    -h | --help                      Show this help screen"
  echo -e "${RCol}\n"
  exit 254
}

################################################################################
# Parameters
AWS_PROFILE=${AWS_PROFILE-} ## Could exist in outside env
TARGET=
FORMAT=
FETCH_ALL=false

EXTRA_PARAMS=""
while (( "$#" )); do
  case "$1" in
    -p|--profile)
      ## Immediately export the profile
      export AWS_PROFILE=$(sanitise_string $2)
      info "Using AWS Profile ${AWS_PROFILE}"
      shift 2
      ;;

    -t|--target)
      TARGET=$(sanitise_string $2)
      shift 2
      ;;

    -f|--format)
      FORMAT=$(sanitise_string $2)
      shift 2
      ;;

    --all)
      FETCH_ALL=true
      shift
      ;;

    -h|--help)
      usage
      shift
      ;;

    --) # end argument parsing
      shift ; break
      ;;

    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;

    *)
      error "No trailing arguments expected. See help (-h) for more information."
      ;;

  esac
done

if [[ ${FETCH_ALL} == true && ! -z ${TARGET} ]]; then
    echo "Specify one of --target or --all, but not both" >&2
    exit 1
fi

################################################################################
# Main Execution
#

## Format is either 'text' or 'json'
FORMAT="${FORMAT:-text}"

if [[ -z ${TARGET} ]]; then
    buckets="$(aws s3api list-buckets --query 'Buckets[].[Name]' --output text)"
else
    buckets=${TARGET}
fi

for bk in $buckets;
do
	echo "$(aws s3api get-public-access-block --bucket "${bk}" \
		--query "{Bucket: '${bk}',
            Config_BlockPublicAcls: PublicAccessBlockConfiguration.BlockPublicAcls, \
            Config_IgnorePublicAcls: PublicAccessBlockConfiguration.IgnorePublicAcls, \
            Config_BlockPublicPolicy: PublicAccessBlockConfiguration.BlockPublicPolicy, \
            Config_RestrictPublicBuckets: PublicAccessBlockConfiguration.RestrictPublicBuckets \
		    }" \
		--output ${FORMAT})"
done
