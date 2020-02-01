#!/bin/bash

function send_email {
  email_subject=$1
  email_subject="${email_subject} - $(date +"%m.%d.%Y")"
  email_body=$2
  email_recipients=$3
  email_dir=$EMAILS_DIR/$(date +"%m-%d-%y")
  email_path=$email_dir/$(basename -- "$report_path")
  mkdir -p $email_dir
  printf "To: %s\nFrom: %s\nSubject: %s\n\n%s" $email_recipients "$email_from" "$email_subject" "$email_body" > $email_path

#  cat $email_path | msmtp -a reports "$recipients"
  cat $email_path # | msmtp -a reports "$recipients"
}

function build_email_body {
  download_link=$1
  expire_time_human=$2
  reply_to=$3
  email_body=$(<report_email_body_template.txt)
  email_body=$(printf "$email_body" $download_link "$expire_time_human" $reply_to)
}

function process_report {
  script_path=$1
  report_dir=$REPORTS_DIR/$(date +"%m-%d-%y")
  file_prefix=$(basename -- "$script_path")
  file_prefix="${file_prefix%.*}"
  report_path=$report_dir/${file_prefix}_$(date +"%m-%d-%Y_%H-%M").csv

  mkdir -p $report_dir
  echo "$DATABASE_READONLY_URL -f $script_path > $report_path"
  echo $DATABASE_READONLY_URL -f $script_path > $report_path
}


function upload_report {
  report_path=$1
  bucket_report_path="s3://$REPORTS_S3_BUCKET/$(date +"%m-%d-%Y")/$(basename -- "$report_path")"
  # aws s3 cp $report_path $bucket_report_path
  # download_link=$(aws s3 presign $bucket_report_path --expires-in $expire_time_in_seconds)

  download_link="https://s3.eu-west-2.amazonaws.com/support.reports.test/01-22-2020/test_01-22-2020_23-41.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJRAGJ4UKTGKQLTDA%2F20200122%2Feu-west-2%2Fs3%2Faws4_request&X-Amz-Date=20200122T234153Z&X-Amz-Expires=60&X-Amz-SignedHeaders=host&X-Amz-Signature=fd28ea15b8ee53689192225414f3b57a28d0baeb41b4368421da520d53582d67"

}

function log_state {
  script_path=$1
  log_status=$2
  script_name=$(basename -- "$script_path")
  printf "%s %s %s\n" $(date +"%Y-%m-%d_%H-%M-%S") "$script_name" "$log_status" >> log.txt
}

function log_info {
  local message=$1
  local type='INFO'
  # printf "%s %s: %s\n" $(date +"%Y-%m-%d %H:%M:%S") "$type" "$message" >> "$LOG_FILE"
  log_message "$message" "$type"
}

function log_error {
  local message=$1
  local type='ERROR'
  log_message "$message" "$type"
}

function log_message {
  local message=$1
  local type=$2
  printf "%s %s: %s\n" $(date +"%Y-%m-%d %H:%M:%S") "$type" "$message" >> "$LOG_FILE"
}


function log_info_with_tee {
  local message=$1
  local type='INFO'
  log_message_with_tee "$message" "$type"
}

function log_error_with_tee {
  local message=$1
  local type='ERROR'
  log_message_with_tee "$message" "$type"
}

function log_message_with_tee {
  local message=$1
  local type=$2
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  printf "%s %s: %s\n" "$timestamp" "$type" "$message" | tee -a "$LOG_FILE"
}
