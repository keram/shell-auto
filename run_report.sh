#!/usr/bin/env bash

# Fail quickly Fail safe
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Set working directory to dir of this file
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)" || return
echo "$(pwd)"

if [ ! -r "$1" ]; then
  error_msg="Error: $1 is not readable file."
  echo `date` "$error_msg" >> error.log
  echo "$error_msg"
  exit 1
fi

if [[ "$1" =~ .*\.report\.cfg ]]; then
  config_file=$1
else
  error_msg="Error: $1 is not a report config file."
  echo `date` "$error_msg" >> error.log
  echo "$error_msg"
  exit 1
fi

# TODO: replace source config file with parsing
source "$config_file"

config_options=( EMAIL_SUBJECT EMAIL_FROM EMAIL_RECIPIENTS )

for opt_name in ${config_options[@]}
do
  if [ -z ${!opt_name} ]; then
    error_msg="Error: $1 Missing $opt_name definition or is empty."
    echo `date` "$error_msg" >> error.log
    echo "$error_msg"
    exit 1
  fi
done

# # if [[ ${#EMAIL_SUBJECT} = 0 ]]; then
# if [ -z $EMAIL_SUBJECT ]; then
#   error_msg="Error: $1 Missing configuration definition."
#   echo `date` "$error_msg" >> error.log
#   echo "$error_msg"
#   exit 1
# fi


# log_state $script_path 'initialised'
# process_report $script_path
# log_state $script_path 'generated'
# upload_report $report_path
# log_state $script_path 'uploaded'
# build_email_body "$download_link" "$expire_time_human" "$reply_to"
# send_email "$email_subject" "$email_body" "$recipients"
# log_state $script_path 'sent'
