#!/bin/bash

# Output CSV file
output_file="ksm_monitor.csv"

# Interval in seconds
interval=5

# Duration in seconds
duration=36000

# Header for CSV file
echo "Timestamp,Pages_shared,Pages_sharing,Pages_unshared,Pages_volatile,full_scans,general_profit,pages_to_scan" > $output_file

# Function to get KSM statistics
get_ksm_stats() {
    pages_shared=$(cat /sys/kernel/mm/ksm/pages_shared)
    pages_sharing=$(cat /sys/kernel/mm/ksm/pages_sharing)
    pages_unshared=$(cat /sys/kernel/mm/ksm/pages_unshared)
    pages_volatile=$(cat /sys/kernel/mm/ksm/pages_volatile)
    full_scans=$(cat /sys/kernel/mm/ksm/full_scans)
    general_profit=$(cat /sys/kernel/mm/ksm/general_profit)
    pages_to_scan=$(cat /sys/kernel/mm/ksm/pages_to_scan)


    timestamp=$(date +%s)
    echo "$timestamp,$pages_shared,$pages_sharing,$pages_unshared,$pages_volatile,$full_scans,$general_profit,$pages_to_scan"
}

# Main loop
end_time=$((SECONDS+$duration))
while [ $SECONDS -lt $end_time ]; do
    stats=$(get_ksm_stats)
    echo "$stats" >> $output_file
    sleep $interval
done
