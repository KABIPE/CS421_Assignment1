#!/bin/bash

LOG_FILE="/var/log/backup.log"
TIMESTAMP=$(date +%Y-%m-%d_%H:%M:%S)
API_DIR="/var/www/your_api" # Replace with your API project directory
BACKUP_DIR="/home/ubuntu/backups"
DB_EXPORT_FILE="$BACKUP_DIR/db_backup_$(date +%F).sql"
API_BACKUP_FILE="$BACKUP_DIR/api_backup_$(date +%F).tar.gz"
RETENTION_DAYS=7

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Function to log messages with a timestamp
log_message() {
  echo "$TIMESTAMP: $1" >> "$LOG_FILE"
}

# Backup API Project Directory
if tar -czvf "$API_BACKUP_FILE" "$API_DIR"; then
  log_message "API project backed up successfully to $API_BACKUP_FILE"
else
  log_message "ERROR: Failed to backup API project."
fi

# Backup Database (assuming MySQL - adjust command if using a different database)
if which mysql >/dev/null 2>&1; then
  DB_USER="your_db_user"   # Replace with your database username
  DB_PASSWORD="your_db_password" # Replace with your database password
  DB_NAME="your_db_name"     # Replace with your database name

  mysqldump -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$DB_EXPORT_FILE"
  if [ $? -eq 0 ]; then
    log_message "Database backed up successfully to $DB_EXPORT_FILE"
  else
    log_message "WARNING: Failed to backup database."
  fi
else
  log_message "WARNING: MySQL client not found. Skipping database backup."
fi

# Remove old backups
find "$BACKUP_DIR" -type f -mtime +"$RETENTION_DAYS" -delete
log_message "Old backups (older than $RETENTION_DAYS days) deleted."

echo "Backup process completed. See logs in $LOG_FILE"
