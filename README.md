# ipscan
Takes a list of hosts, resolves their IP and performs a port scan using masscan.
This script needs root privileges to run.

Since masscan does not accept domain names as input, this script resolves DNS using **dig** and then runs **masscan** over the result. It generates a easily grepable output file with format

**hostname : ip : ports**

## Example usage: 
``` bash
sudo ./ipscan.sh hosts.txt
```
