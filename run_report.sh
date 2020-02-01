#!/usr/bin/env bash

# Fail quickly Fail safe
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Set working directory to dir of this file
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)" || return
echo "$(pwd)"

# Load default env config
source .env

# Load default env config
source lib/report_helpers.sh

# Sanity checks on passed config file
if [ ! -r "$1" ]; then
  error_msg="Error: $1 is not readable file."

  log_error_with_tee "$error_msg"
  exit 1
fi

if [[ "$1" =~ .*\.report\.cfg ]]; then
  config_file=$1
else
  error_msg="Error: $1 is not a report config file."
  log_error_with_tee "$error_msg"
  exit 1
fi

# Load script specific config and override defaults
# TODO: replace source config file with parsing
source "$config_file"


# Test that all necessary variables are set
# and also check that global options are still present
config_options=( EMAIL_SUBJECT EMAIL_FROM EMAIL_RECIPIENTS
                 EXPIRE_TIME_IN_SECONDS EXPIRE_TIME_HUMAN
                 SCRIPT_PATH
                 LOG_FILE )

for opt_name in ${config_options[@]}
do
  if [ -z ${!opt_name} ]; then
    error_msg="Error: $1 Missing $opt_name definition or is empty."
    log_error_with_tee "$error_msg"
    exit 1
  fi
done

# Unsure script_path is readable file
if [ ! -r "$SCRIPT_PATH" ]; then
  error_msg="Error: $SCRIPT_PATH is not readable file."
  log_error_with_tee "$error_msg"
  exit 1
fi

script_name=$(basename "$config_file")

echo $script_name
# log_info "$script_name initialised"
log_info_with_tee "$script_name initialised"
# process_report $script_path
# log_state $script_path 'generated'
# upload_report $report_path
# log_state $script_path 'uploaded'
# build_email_body "$download_link" "$expire_time_human" "$reply_to"
# send_email "$email_subject" "$email_body" "$recipients"
# log_state $script_path 'sent'
