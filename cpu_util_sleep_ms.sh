#!/bin/bash

# Number of iterations for each sleep_ms value
ITERATIONS=10

# Interval between iterations (in seconds)
INTERVAL=1

# Cooldown for CPU utilzation to settle down
COOLDOWN_PERIOD=10

# Values for sleep_ms
SLEEP_MS=(200 100 50 20 10)

# PID of the ksmd process
KSMD_PID=$(pgrep ksmd)


CSV_OUTPUT_FILE=cpu_util.csv


echo "sleep_ms,CPU Utilization" > $CSV_OUTPUT_FILE

echo "Monitoring CPU utilization of ksmd (PID: $KSMD_PID)"
echo "-----------------------------------------"


# The sleep for ms will be constant
KSM_PAGES_TO_SCAN=1000
echo $KSM_PAGES_TO_SCAN > /sys/kernel/mm/ksm/pages_to_scan


for sleep_ms in "${SLEEP_MS[@]}"
do
    echo "Setting sleep_ms to $sleep_ms"
    echo $sleep_ms > /sys/kernel/mm/ksm/sleep_millisecs

    sleep $COOLDOWN_PERIOD

    total_cpu=0
    for ((i=1; i<=$ITERATIONS; i++))
    do
        # Get the CPU utilization of ksmd
        CPU=$(top -b -n 1 -p $KSMD_PID | grep $KSMD_PID | awk '{print $9}')
        
        # Print the CPU utilization
        echo "sleep_ms=$sleep_ms, Iteration $i - CPU Utilization: $CPU%"

        total_cpu=$(echo "$total_cpu + $CPU" | bc)
        
        # Wait for the specified interval
        sleep $INTERVAL
    done

    avg_cpu=$(echo "scale=2; $total_cpu / $ITERATIONS" | bc)


    echo "Average CPU Utilization for sleep_ms=$sleep_ms: $avg_cpu%"
    echo

    echo "$sleep_ms,$avg_cpu" >> $CSV_OUTPUT_FILE

done

echo 100 > /sys/kernel/mm/ksm/pages_to_scan
echo 200 > /sys/kernel/mm/ksm/sleep_millisecs

