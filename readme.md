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

if a reports needs to run agains different databases you can add multiple db
variables with prefix for example

```shell
DATABASE_URL='postgres://foo:bar@localhost/baz'
TEST_DATABASE_URL='postgres://lui:dui@localhost/hui'
```
and in the report.cfg specify variable `DB_PREFIX`
In example if we wanted to use the test db we would add

```shell
DB_PREFIX='TEST'
```
