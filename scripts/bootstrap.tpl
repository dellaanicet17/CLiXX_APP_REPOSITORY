#!/bin/bash
# Use the passed-in variables
file_system_id=${file_system_id}
mount_point=${mount_point}
record_name=${record_name}
region=${region}

# Switch to root user
sudo su -

# Update packages and install necessary utilities
yum update -y
yum install -y nfs-utils aws-cli

# Fetch the session token and region information for metadata
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
AVAILABILITY_ZONE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/placement/availability-zone")
#REGION=${region}

# Ensure DNS resolution and DNS hostnames are enabled (for VPC)
echo "nameserver 169.254.169.253" >> /etc/resolv.conf

# Install the NFS utilities for mounting EFS
yum install -y nfs-utils

# Wait until the EFS file system is available
while true; do
    status=$(aws efs describe-file-systems --file-system-id $file_system_id --query "FileSystems[0].LifeCycleState" --output text --region $region)
    if [ "$status" == "available" ]; then
        echo "EFS FileSystem is available."
        break
    else
        echo "Waiting for EFS FileSystem to become available. Retrying in 10 seconds..."
    fi
    sleep 10
done

# Ensure the mount target exists in the same availability zone as the EC2 instance
while true; do
    mount_target=$(aws efs describe-mount-targets --file-system-id $file_system_id --region $region --query 'MountTargets[?AvailabilityZoneName==`'$AVAILABILITY_ZONE'`].MountTargetId' --output text)
    if [ -n "$mount_target" ]; then
        echo "Mount target found in availability zone $AVAILABILITY_ZONE."
        break
    else
        echo "Waiting for mount target in availability zone $AVAILABILITY_ZONE. Retrying in 10 seconds..."
    fi
    sleep 10
done

# Restart network service to ensure DNS resolution
sudo service network restart

# Create mount point and set permissions
mount_point=${mount_point}
mkdir -p $mount_point
chown ec2-user:ec2-user $mount_point

# Add EFS to fstab and attempt to mount
echo "${file_system_id}.efs.${region}.amazonaws.com:/ $mount_point nfs4 defaults,_netdev 0 0" >> /etc/fstab

sleep 120
# Attempt to mount, retrying if it fails
attempt=0
max_attempts=5
while (( attempt < max_attempts )); do
    mount -a -t nfs4 && echo "EFS mounted successfully." && break
    echo "Mount failed, retrying after network restart..."
    sudo service network restart
    sleep 10
    attempt=$((attempt + 1))
done

# Check if mount was successful
if ! mount | grep -q $mount_point; then
    echo "Error: EFS mount failed after $max_attempts attempts. Continuing with the rest of the script."
else
    echo "EFS successfully mounted at $mount_point."
fi

chmod -R 755 $mount_point

# Switch back to ec2-user
sudo su - ec2-user

# Proceed with the rest of the CLiXX setup
# Variables for WordPress Setup
CLiXX_GIT_REPO_URL="https://github.com/stackitgit/CliXX_Retail_Repository.git"
WordPress_DB_NAME="wordpressdb"
WordPress_DB_USER="wordpressuser"
WordPress_DB_PASS="W3lcome123"
WordPress_DB_HOST="wordpressdbclixx.cj0yi4ywm61r.us-east-1.rds.amazonaws.com"
record_name=${record_name}
WP_CONFIG_PATH="/var/www/html/wp-config.php"

# Install the needed packages and enable the services
sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd

# Check if wp-config.php exists before cloning the repository
if [ ! -f "/var/www/html/wp-config.php" ]; 
then
    echo "Cloning CliXX Retail repository..."
    git clone $CLiXX_GIT_REPO_URL /var/www/html
else
    echo "WordPress already installed, skipping clone..."
fi

# Configure the wp-config.php file
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/database_name_here/$WordPress_DB_NAME/" $WP_CONFIG_PATH
sudo sed -i "s/username_here/$WordPress_DB_USER/" $WP_CONFIG_PATH
sudo sed -i "s/password_here/$WordPress_DB_PASS/" $WP_CONFIG_PATH
sudo sed -i "s/localhost/$WordPress_DB_HOST/" $WP_CONFIG_PATH

# Add HTTPS enforcement to wp-config.php
sudo sed -i "81i if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') { \$_SERVER['HTTPS'] = 'on'; }" $WP_CONFIG_PATH

# Allow WordPress to use Permalinks
sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf

# Grant file ownership of /var/www to apache user
echo "Change ownership of /var/www to apache group"
sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
echo "Setting permissions for WordPress"
find /var/www -type d -print0 | xargs -0 -n 2000 sudo chmod 2775
echo "Changing permissions for all files under /var/www"
find /var/www -type f -print0 | xargs -0 -n 2000 sudo chmod 0644

# Restart Apache
sudo systemctl restart httpd
sudo service httpd restart
sudo systemctl enable httpd

# Wait for the database to be up
until mysqladmin ping -h $WordPress_DB_HOST -u $WordPress_DB_USER -p$WordPress_DB_PASS --silent; do
    echo "Waiting for database to be available..."
    sleep 10
done

# Check and update WordPress options
existing_value=$(mysql -u $WordPress_DB_USER -p$WordPress_DB_PASS -h $WordPress_DB_HOST -D $WordPress_DB_NAME -sse "SELECT COUNT(*) FROM wp_options WHERE (option_name = 'home' OR option_name = 'siteurl' OR option_name = 'ping_sites' OR option_name = 'open_shop_header_retina_logo') AND option_value = '${record_name}';")

if [ "$existing_value" -eq 4 ]; 
then
    echo "All relevant options are already set to $record_name. No update needed."
else
    echo "Updating the options with the new record name value."
    mysql -u $WordPress_DB_USER -p$WordPress_DB_PASS -h $WordPress_DB_HOST -D $WordPress_DB_NAME <<EOF
    UPDATE wp_options SET option_value = "https://${record_name}" WHERE option_name = "home";
    UPDATE wp_options SET option_value = "https://${record_name}" WHERE option_name = "siteurl";
    UPDATE wp_options SET option_value = "https://${record_name}" WHERE option_name = "ping_sites";
    UPDATE wp_options SET option_value = "https://${record_name}" WHERE option_name = "open_shop_header_retina_logo";
EOF
    echo "Update queries executed successfully."
fi







