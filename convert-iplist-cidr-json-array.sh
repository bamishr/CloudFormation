#!/usr/bin/env bash
# This script converts an IPv4 iplist to CIDR block notation and JSON array format, sorting and de-duplicating IPs

# Set Variables
filename="iplist"
DEBUGMODE="0"


# Cleanup list
function cleanup {
	sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 $filename | uniq > iplist2
	mv iplist2 $filename
	# echo "iplist cleanup completed."
}

