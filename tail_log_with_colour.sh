# tail -f reports.log | awk '/ERROR/ { $0 = "\033[29m" $0 "\033[39m" }; 1'
tail -f reports.log | awk '/ERROR/ { $0 = "\033[31m" $0 "\033[39m" };/Email Sent/ { $0 = "\033[32m" $0 "\033[39m" }; 1'
