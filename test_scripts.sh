#!/bin/bash

SCRIPTS=("health_check.sh" "backup_api.sh" "update_server.sh")
LOG_DIR="/var/log"
BACKUP_DIR="/home/ubuntu/backups"

echo "Running automated tests..."

# Check script existence and permissions
for script in "${SCRIPTS[@]}"; do
  if [ -f "./$script" ]; then
    echo "[OK] $script exists."
    [ -x "./$script" ] && echo "[OK] $script is executable." || echo "[WARN] $script is not executable."
  else
    echo "[ERROR] $script is missing."
  fi
done

# Test health_check.sh
./health_check.sh
grep -q "Health Check" $LOG_DIR/server_health.log && echo "[OK] health_check.sh log generated." || echo "[ERROR] health_check.sh log missing."

# Test backup_api.sh
./backup_api.sh
BACKUP_FILE=$(ls $BACKUP_DIR/api_backup_*.tar.gz 2>/dev/null | tail -n 1)
[ -f "$BACKUP_FILE" ] && echo "[OK] Backup file created." || echo "[ERROR] Backup file missing."

# Test update_server.sh
./update_server.sh
grep -q "Starting update" $LOG_DIR/update.log && echo "[OK] update_server.sh log generated." || echo "[ERROR] update_server.sh log missing."

echo "Automated tests completed."
