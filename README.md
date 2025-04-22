## Bash Scripts for Server Management

This directory (`bash_scripts`) contains scripts to automate server management tasks for the deployed API.

### Script Descriptions

* **`health_check.sh`**: This script monitors the server's resource usage (CPU, memory, disk space) and the status of the web server (Apache or Nginx). It also tests the API endpoints (`/students` and `/subjects`) to ensure they return a 200 OK status. The results are logged to `/var/log/server_health.log`. Warnings are generated for high resource usage or API downtime.

* **`backup_api.sh`**: This script creates a backup of the API project directory (`/var/www/your_api`) and the associated database (MySQL). Backups are stored in `/home/ubuntu/backups/` with a timestamp. Backups older than 7 days are automatically deleted. Logs are written to `/var/log/backup.log`.

* **`update_server.sh`**: This script automates the process of updating the Ubuntu server packages, pulling the latest changes from the API's GitHub repository, and restarting the web server. The update process is logged to `/var/log/update.log`. The script will exit if the `git pull` fails.

### Setup and Usage

1.  **Clone the repository** to your AWS Ubuntu server (if you haven't already).
2.  **Navigate to the `bash_scripts` directory:**
    ```bash
    cd CS421_Assignment1/bash_scripts
    ```
3.  **Set execute permissions for all scripts:**
    ```bash
    chmod +x *.sh
    ```
4.  **Run the scripts manually** to test them:
    ```bash
    ./health_check.sh
    ./backup_api.sh
    ./update_server.sh
    ```
5.  **Check the log files** in `/var/log/` to verify the scripts ran successfully.

### Dependencies

* **`curl`**: Used by `health_check.sh` to test API endpoints. It should be installed by default on most Ubuntu systems. If not, you can install it with: `sudo apt update && sudo apt install curl -y`
* **`tar`**: Used by `backup_api.sh` for creating compressed archives. It's usually installed by default.
* **`gzip`**: Used by `tar` for compression. Usually installed by default.
* **`mysql-client`** (or equivalent for your database): Required by `backup_api.sh` if you are using MySQL. Install with: `sudo apt update && sudo apt install mysql-client -y`. If you are using PostgreSQL, you'll need `postgresql-client`: `sudo apt update && sudo apt install postgresql-client -y`.
* **`git`**: Used by `update_server.sh` to pull changes from your repository. Install with: `sudo apt update && sudo apt install git -y`

### Cron Scheduling

To automate the scripts, you can use cron. Open the crontab editor:

```bash
crontab -e
