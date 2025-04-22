#!/bin/bash

LOG_FILE="/var/log/update.log"
TIMESTAMP=$(date +%Y-%m-%d_%H:%M:%S)
API_REPO_PATH="/var/www/your_api" # Replace with the local path of your API repository
WEB_SERVER_SERVICE=$(systemctl list-unit-files --state=enabled | grep -E 'apache2\.service|nginx\.service' | awk '{print $1}' | head -n 1)

# Function to log messages with a timestamp
log_message() {
  echo "$TIMESTAMP: $1" >> "$LOG_FILE"
}

log_message "Starting server update process..."

# Update package list and upgrade packages
log_message "Updating package list and upgrading installed packages..."
sudo apt update && sudo apt upgrade -y
if [ $? -eq 0 ]; then
  log_message "Package update and upgrade completed successfully."
else
  log_message "ERROR: Failed to update and upgrade packages. Exiting."
  exit 1
fi

# Navigate to the API repository and pull latest changes
log_message "Navigating to API repository: $API_REPO_PATH"
cd "$API_REPO_PATH" || {
  log_message "ERROR: Could not navigate to API repository. Exiting."
  exit 1
}

log_message "Pulling latest changes from GitHub..."
git pull origin main # Assuming your main branch is 'main' - adjust if needed
if [ $? -eq 0 ]; then
  log_message "Successfully pulled latest changes from GitHub."
else
  log_message "ERROR: Failed to pull latest changes from GitHub. Exiting."
  exit 1
fi

# Restart the web server
if [ -n "$WEB_SERVER_SERVICE" ]; then
  log_message "Restarting web server: $WEB_SERVER_SERVICE"
  sudo systemctl restart "$WEB_SERVER_SERVICE"
  if [ $? -eq 0 ]; then
    log_message "Web server restarted successfully."
  else
    log_message "ERROR: Failed to restart web server."
  fi
else
  log_message "WARNING: No active web server (Apache or Nginx) found to restart."
fi

log_message "Server update process completed."
