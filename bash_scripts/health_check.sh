#!/bin/bash

LOG_FILE="/var/log/server_health.log"
TIMESTAMP=$(date +%Y-%m-%d_%H:%M:%S)
WEB_SERVER_STATUS=$(systemctl is-active apache2 nginx 2>/dev/null) # Check for Apache or Nginx
API_STUDENTS_URL="http://localhost/students" # Adjust if your API is on a different port/path
API_SUBJECTS_URL="http://localhost/subjects" # Adjust if your API is on a different port/path
DISK_THRESHOLD=10 # Percentage

# Function to log messages with a timestamp
log_message() {
  echo "$TIMESTAMP: $1" >> "$LOG_FILE"
}

# Check CPU Usage
CPU_USAGE=$(vmstat 1 2 | awk 'NR==3{print 100 - $15}')
log_message "CPU Usage: ${CPU_USAGE}%"

# Check Memory Usage
TOTAL_MEMORY=$(free -m | awk 'NR==2{print $2}')
USED_MEMORY=$(free -m | awk 'NR==2{print $3}')
MEMORY_USAGE=$(( (USED_MEMORY * 100) / TOTAL_MEMORY ))
log_message "Memory Usage: ${MEMORY_USAGE}% ($USED_MEMORY/$TOTAL_MEMORY MB)"

# Check Disk Space for the root partition
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
FREE_DISK=$(df -h / | awk 'NR==2{print $4}')
log_message "Disk Usage on /: ${DISK_USAGE}% (Free: ${FREE_DISK})"
if [[ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]]; then
  log_message "WARNING: Disk space on / is above ${DISK_THRESHOLD}%"
fi

# Check Web Server Status
if [[ "$WEB_SERVER_STATUS" == "active" ]]; then
  log_message "Web Server ($WEB_SERVER_STATUS) is running."
else
  log_message "ERROR: Web Server ($WEB_SERVER_STATUS) is NOT running!"
fi

# Check API Endpoints
API_STUDENTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$API_STUDENTS_URL")
if [[ "$API_STUDENTS_STATUS" -eq 200 ]]; then
  log_message "API Endpoint (/students) status: ${API_STUDENTS_STATUS} OK"
else
  log_message "ERROR: API Endpoint (/students) status: ${API_STUDENTS_STATUS}"
fi

API_SUBJECTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$API_SUBJECTS_URL")
if [[ "$API_SUBJECTS_STATUS" -eq 200 ]]; then
  log_message "API Endpoint (/subjects) status: ${API_SUBJECTS_STATUS} OK"
else
  log_message "ERROR: API Endpoint (/subjects) status: ${API_SUBJECTS_STATUS}"
fi

echo "Health check completed. See logs in $LOG_FILE"
