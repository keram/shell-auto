### Dependencies

gawk - for strftime function
aws-cli - for uploading reports to s3
msmtp - for sending emails
psql - for db access

### Installation

TODO

```cron
PATH="/usr/local/bin:/usr/bin:/bin"
45 8 * * MON /home/pi/shell-auto/run_report /home/pi/syft-auto-support-sql/weekly_failed_card_transactions.report.cfg
47 8 * * WED /home/pi/shell-auto/run_report /home/pi/syft-auto-support-sql/weekly_agency_timesheet_data.report.cfg
50 8 * * * /home/pi/shell-auto/run_report /home/pi/syft-auto-support-sql/daily_phones_of_workers_on_not_confirmed_shifts.report.cfg
```
