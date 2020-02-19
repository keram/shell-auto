# tail -f reports.log | awk '/ERROR/ { $0 = "\033[29m" $0 "\033[39m" }; 1'
# Set working directory to dir of this file
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)" || return

tail -f reports.log | awk '/ERROR/ { $0 = "\033[31m" $0 "\033[39m" };/Email Sent/ { $0 = "\033[32m" $0 "\033[39m" }; 1'
