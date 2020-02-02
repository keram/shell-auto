#!/usr/bin/env bash

# Fail quickly Fail safe
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Set working directory to dir of this file
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)" || return

# Load default env config
source .env

# Load default env config
source lib/report_helpers.sh

# Sanity checks on passed config file
# f - regular file
# r - read permission
# s - size greater than zero
if [ ! -f "$1" ] || [ ! -r "$1" ] || [ ! -s "$1" ]; then
  error_msg="$1 is not readable file."

  log_error "$error_msg"
  exit 1
fi

if [[ "$1" =~ .*\.report\.cfg ]]; then
  config_file=$1
else
  error_msg="$1 is not a report config file."
  log_error "$error_msg"
  exit 1
fi


# Load script specific config and override defaults
# TODO: replace source config file with parsing
source "$config_file"

# create script name from config file name
script_name=$(basename "$config_file")
script_name=${script_name%.*}

# Test that all necessary variables are set
# and also check that global options are still present
config_options=( EMAIL_SUBJECT EMAIL_FROM EMAIL_RECIPIENTS
                 EXPIRE_TIME_IN_SECONDS EXPIRE_TIME_HUMAN
                 SCRIPT_PATH
                 LOG_FILE )

for opt_name in ${config_options[@]}
do
  if [ -z ${!opt_name} ]; then
    error_msg="$script_name : $1 Missing $opt_name definition or is empty."
    log_error "$error_msg"
    exit 1
  fi
done

# Unsure script_path is readable file
if [ ! -r "$SCRIPT_PATH" ]; then
  error_msg="$script_name : $SCRIPT_PATH is not readable file."
  log_error "$error_msg"
  exit 1
fi

report_path=$(build_report_path "$script_name" "$REPORTS_DIR")
bucket_report_path=$(build_bucket_report_path "$report_path")

log_info "$script_name : Initialised"

generate_report "$SCRIPT_PATH" "$report_path"

if [ ! "$?" -eq "0" ]; then
  log_error "$script_name : Something went wrong with generate_report $SCRIPT_PATH $REPORTS_DIR"
  exit 1
fi

if [ ! -r "$report_path" ]; then
  error_msg="$script_name : $report_path was not created."
  log_error "$error_msg"
  exit 1
elif [ ! -s "$report_path" ]; then
  error_msg="$script_name : $report_path is empty."
  log_error "$error_msg"
  exit 1
fi

log_info "$script_name : Generated"

upload_report "$report_path" "$bucket_report_path"

if [ ! "$?" -eq "0" ]; then
  log_error "$script_name : Something went wrong with upload_report $report_path"
  exit 1
fi

log_info "$script_name : Uploaded"

download_url=$(generate_download_url "$bucket_report_path")

if [ ! "$?" -eq "0" ]; then
  log_error "$script_name : Something went wrong with generating url for $bucket_report_path"
  exit 1
fi

log_info "$script_name : Url generated"

email_body=$(build_email_body "$download_url")
email_subject="$EMAIL_SUBJECT - $(date +"%m.%d.%Y")"
email_recipients="$EMAIL_RECIPIENTS"
email_from="$EMAIL_FROM"
email=$(build_email "$email_subject" "$email_body" "$email_recipients" "$email_from")
email_path=$(build_email_path "$report_path")
save_email "$email" "$email_path"
log_info "$script_name : $email_path"

log_info "$script_name : Email generated"

send_email "$email_path" "$email_recipients"

log_info "$script_name : Email Sent"
