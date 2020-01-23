#!/bin/bash

homedir=./
script_path=test.sql
source $homedir/.env
source report_helpers.sh

email_subject='REPORT (daily): test data'
email_from=$EMAIL_FROM
expire_time_in_seconds=86400
expire_time_human='24 hours'
reply_to=$EMAIL_FROM
recipients=$REPORT_TEST_RECIPIENTS

log_state $script_path 'initialised'
process_report $script_path
log_state $script_path 'generated'
upload_report $report_path
log_state $script_path 'uploaded'
build_email_body "$download_link" "$expire_time_human" "$reply_to"
send_email "$email_subject" "$email_body" "$recipients"
log_state $script_path 'sent'
