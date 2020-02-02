#!/bin/bash

function build_email {
  local email_recipients=$1
  local email_from=$2
  local email_subject=$3
  local email_body=$4

  printf "To: %s\nFrom: %s\nSubject: %s\n\n%s\n" $email_recipients "$email_from" "$email_subject" "$email_body"
}

function build_email_path {
  local report_path=$1
  local email_dir=$EMAILS_DIR/$(date +"%m-%d-%y")
  local filename=$(basename "$report_path")
  local filename=${filename%.*}.txt
  local email_path=$email_dir/$filename

  mkdir -p $email_dir
  echo $email_path
}

function save_email {
  local email=$1
  local email_path=$2

  echo $email > $email_path
}

function send_email {
  email_path=$1
  email_recipients=$2
  # cat $email_path | msmtp -a reports "$email_recipients"
}

function build_email_body {
  local download_url=$1
  local email_body=$(<report_email_body_template.txt)
  printf "$email_body" "$download_url"
}

function generate_report {
  local script_path="$1"
  local report_path="$2"
  # echo "$DATABASE_READONLY_URL -f $script_path > $report_path"
  # psql $DATABASE_READONLY_URL -f $script_path > $report_path
  touch $report_path
  echo "bla" > $report_path
}

function build_report_path {
  local script_name="$1"
  local report_dir="$2/$(date +"%d-%m-%y")"
  local report_file_name="script_name_$(date +"%d-%m-%Y_%H-%M").csv"
  local report_path="$report_dir/$report_file_name"

  mkdir -p "$report_dir"
  echo "$report_path"
}

function build_bucket_report_path {
  local report_path=$1
  echo "s3://$REPORTS_S3_BUCKET/$(date +"%m-%d-%Y")/$(basename -- "$1")"
}

function upload_report {
  local report_path=$1
  local bucket_report_path=$2

  # aws s3 cp $report_path $bucket_report_path
}

function generate_download_url {
  local bucket_report_path=$1

  # download_link=$(aws s3 presign $bucket_report_path --expires-in $expire_time_in_seconds)

  echo "https://s3.eu-west-2.amazonaws.com/support.reports.test/foo.test"
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
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")

  if [ "$VERBOSE" = "0" ] && [ "$DEBUG_SCRIPT" = "0" ]; then
    printf "%s %s: %s\n" "$timestamp" "$type" "$message" >> "$LOG_FILE"
  else
    printf "%s %s: %s\n" "$timestamp" "$type" "$message" | tee -a "$LOG_FILE"
  fi
}
