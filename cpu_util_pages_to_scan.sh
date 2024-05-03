#!/bin/bash

# Number of iterations for each pages_to_scan value
ITERATIONS=10

# Interval between iterations (in seconds)
INTERVAL=1

# Cooldown for CPU utilzation to settle down
COOLDOWN_PERIOD=10

# Values for pages_to_scan
PAGES_TO_SCAN_VALUES=(100 500 1000 2000 4000 8000 10000)

# PID of the ksmd process
KSMD_PID=$(pgrep ksmd)


CSV_OUTPUT_FILE=cpu_util.csv


echo "pages_to_scan,CPU Utilization" > $CSV_OUTPUT_FILE

echo "Monitoring CPU utilization of ksmd (PID: $KSMD_PID)"
echo "-----------------------------------------"


# The sleep for ms will be constant
KSM_SLEEP=10
echo $KSM_SLEEP > /sys/kernel/mm/ksm/sleep_millisecs


for pages_to_scan in "${PAGES_TO_SCAN_VALUES[@]}"
do
    echo "Setting pages_to_scan to $pages_to_scan"
    echo $pages_to_scan > /sys/kernel/mm/ksm/pages_to_scan

    sleep $COOLDOWN_PERIOD

    total_cpu=0
    for ((i=1; i<=$ITERATIONS; i++))
    do
        # Get the CPU utilization of ksmd
        CPU=$(top -b -n 1 -p $KSMD_PID | grep $KSMD_PID | awk '{print $9}')
        
        # Print the CPU utilization
        echo "pages_to_scan=$pages_to_scan, Iteration $i - CPU Utilization: $CPU%"

        total_cpu=$(echo "$total_cpu + $CPU" | bc)
        
        # Wait for the specified interval
        sleep $INTERVAL
    done

    avg_cpu=$(echo "scale=2; $total_cpu / $ITERATIONS" | bc)


    echo "Average CPU Utilization for pages_to_scan=$pages_to_scan: $avg_cpu%"
    echo

    echo "$pages_to_scan,$avg_cpu" >> $CSV_OUTPUT_FILE

done
