#!/bin/bash

# Threshold for alert
THRESHOLD=80
EMAIL="hh******@gmail.com"

# Check disk usage
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ $USAGE -gt $THRESHOLD ]; then
    echo "Disk usage is at ${USAGE}% on $(hostname). Consider freeing up space." | mail -s "Disk Space Alert" $EMAIL
fi