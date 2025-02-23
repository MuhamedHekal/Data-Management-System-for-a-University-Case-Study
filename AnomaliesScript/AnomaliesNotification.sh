#!/bin/bash

# Log file
LOG_FILE="/var/log/anomaly_check.log"
THRESHOLD=90
EMAIL="hh*******@gmail.com"

# Get CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Check if CPU usage is high
if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )); then
    echo "$(date): High CPU Usage detected: ${CPU_USAGE}%" >> $LOG_FILE
    echo "High CPU Usage detected: ${CPU_USAGE}%" | mail -s "CPU Usage Alert" $EMAIL
fi