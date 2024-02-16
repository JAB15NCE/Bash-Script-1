#Jon Bennett
#Auth.log check
#01/28/2024
#CISS 360

#!/bin/bash

# Calculate the start timestamp for the last hour. 
start_timestamp=$(date +"%b %e %H")

echo "Start Timestamp: $start_timestamp"

#Checks auth.log for any user id (UID) that is not my computers root UID and provides a date and 
#time within the last hour, IF any are found it will grab columns 1,2,3,4,7,8,9,10,11.
filtered_logs=$(zgrep -E "$start_timestamp" /var/log/auth.log 2>&1 | awk '{ match($0, /uid=([0-9]+)/, arr); if (arr[1] != 0 && arr[1] != "0") print $1, $2, $3, $4, $7, $8, $9, $10, $11, arr[1], $NF }')

#Checks if any entries were found
if [ -z "filtered_logs" ]; then
	echo "No other UID found within the last hour." >&1
else
	#Display and save UID if not = 0 to login_logs.txt while aslo displaying user permission level.
	echo "$filtered_logs" | tee lasthour_logs.txt
	echo " Authentication logs not UID 0 found!!! Review auth.log if more then 5 authentications failures found!" >&1
fi

