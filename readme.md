### Dependencies

gawk - for strftime function
aws-cli - for uploading reports to s3
msmtp - for sending emails
psql - for db access

### Installation

TODO

```cron
PATH="/usr/local/bin:/usr/bin:/bin"
45 8 * * MON /home/pi/shell-auto/run_report /home/pi/shell-auto/test.report.cfg
```
