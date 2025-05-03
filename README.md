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
#   Your API Project Name

##  Description

[Provide a brief description of your API and its purpose.]

##  Prerequisites

Before you begin, ensure you have the following installed:

-   [ ]  Docker
-   [ ]  Docker Compose
-   [ ]  AWS Account (for deployment)
-   [ ]  AWS CLI (Optional, for advanced deployment)

##  Getting Started

###   Building Docker Images

1.  Navigate to the root directory of the API project, where the \`Dockerfile\` is located.

2.  Run the following command to build the Docker image:

    ```bash
    docker build -t <your-image-name> .
    ```

    * Replace \`<your-image-name>\` with a descriptive name for your image (e.g., \`my-api\`).
    * The '.' at the end is important, it specifies the build context.

###   Deploying with Docker Compose

1.  Ensure you have the \`docker-compose.yml\` file in the root directory of your project.

2.  Open a terminal in the root directory and run:

    ```bash
    docker-compose up -d
    ```

    * This command starts the containers defined in the \`docker-compose.yml\` file in detached mode.

###  Accessing the API

Once the containers are running, your API should be accessible at \`http://localhost:<port>\`, where \`<port>\` is the port you exposed in the \`docker-compose.yml\` file (e.g., 3000).

##  Deployment on AWS EC2

1.  **Launch an EC2 Instance:**

    * Follow the steps in the provided guide to launch an Ubuntu EC2 instance on AWS. Remember to configure the security group to allow traffic on the necessary ports (e.g., 3000 for your API, 22 for SSH).
    * Download the key pair and keep it secure.
2.  **Connect to the EC2 Instance:**

    * Use SSH to connect to the instance using its public IP and your key pair.
3.  **Install Docker and Docker Compose:**

    * Install Docker and Docker Compose on the EC2 instance.
4.  **Transfer Your Files:**
    * Use \`scp\` to copy your project files to the EC2 instance.
5.  **Deploy:**
    * On the EC2 instance, navigate to the directory where you copied your files and run  \`docker-compose up -d\`.
6.  **Verify:**
    * Ensure that your application is running by accessing it through the EC2 instance's public IP address.

##  Troubleshooting

###   Common Issues and Solutions

* **"docker: command not found" or "docker-compose: command not found"**:
    * Ensure that Docker and Docker Compose are installed correctly. Follow the installation instructions again.
    * If you installed Docker Compose separately, make sure its binary is in your system's \`PATH\`.
* **"Cannot connect to the Docker daemon" or "ERROR: error during connect: ..."**:
    * Make sure the Docker daemon is running. Try restarting Docker Desktop (if you're using it) or the Docker service.
    * Check the troubleshooting steps in the Canvas document for more detailed instructions.
* **API not accessible on the EC2 instance:**
    * **Security Groups:** Double-check the EC2 security group settings to ensure that inbound traffic is allowed on the port your API is using.
    * **Firewall:** Check if there's a firewall on the EC2 instance that's blocking traffic. You might need to configure the firewall to allow connections on the API port.
    * **Docker Port Mapping:** Verify that the port mapping in your \`docker-compose.yml\` file is correct.
    * **Instance is running**: Verify that the instance is running
* **Data not persisting:**
    * Ensure that you have defined volumes correctly in your \`docker-compose.yml\` file, and that the database is configured to store data in the volume.
    * Verify that the volume is correctly mounted to the container
* **Docker Engine Starts and Stops Suddenly**:
         * Check the troubleshooting steps in the Canvas document for more detailed instructions.
* **Permission denied (publickey) error when connecting to EC2:**
    * This error indicates that SSH is unable to authenticate you with the key pair you provided.  This can happen for several reasons:
        * **Incorrect Key Pair Path:** The `-i` option in the `ssh` command specifies the path to your private key file.  If the path is incorrect, SSH won't be able to find the key.
        * **Incorrect Permissions on the Key Pair File:** Private key files should have very restrictive permissions.  If the permissions are too open, SSH will reject the key.
        * **Key Pair Mismatch:** The private key you're providing doesn't match the public key that's configured on the EC2 instance.
        * **SSH Agent Issues:** If you're using an SSH agent, there might be a conflict or issue with the keys it's managing.


##  Important Notes

* **Security:** This setup is for development and testing purposes. For production deployments, you should take additional security measures, such as:
            * Using a managed database service (e.g., Amazon RDS) instead of running a database container in EC2.
            * Securing your EC2 instance with appropriate firewall rules and security groups.
            * Using HTTPS for your API.
            * Implementing proper authentication and authorization for your API.
            * Storing sensitive information (e.g., database passwords) using Docker secrets or a secrets management service.
* **Scalability:** For production, consider using a more scalable solution, such as Amazon ECS or Kubernetes, to manage your containers.
* **Free Tier Limitations**: Be mindful of the free tier limitations.


