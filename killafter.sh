#!/bin/sh

# Script to kill a process if it has been running after a certain number of minutes (inclusive) 
# This script is provided "as is", without warranty of any kind, express or implied.
# 
# Author: Lup Peng (https://github.com/davidloke/useful-scripts)
#
# Usage 
# This script takes in two parameters - the application CMD (based on the ps command), and threshold (in minutes).
#
# Example: 
#
#    $ ./killafter.sh firefox 5 
#
#    Process ID: 3414
#    Time Created: 09:07:46
#    Mins Passed: 7
#    Exceeded allowable time - killed PID 3414
#

pid="0"
time="00:00:00"

for line in $(ps -C $1 -o pid,start --no-headers --sort=start); do
    if [ $pid == "0" ]; then
        pid=$line
	echo ""
        echo "Process ID:" $pid
    else
        time=$line
	echo "Time Created:" $time
        START=$(date -u -d "$time" +"%s")
	END=$(date +%s)
	minpass=$(((END-START)/60%60))
	echo "Mins Passed:" $minpass
	if [ $minpass -ge $2 ]; then 
		kill $pid
		echo "Exceeded allowable time - killed PID" $pid
	fi
        pid="0"  # Reset here for next line
    fi

done
