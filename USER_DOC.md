User Documentation
Services Provided
This stack provides a complete web hosting environment with:

NGINX: Web server handling HTTP/HTTPS requests

WordPress: Content Management System for the website

MariaDB: Database storing website content and user data

SSL/TLS: Secure encrypted connections

Starting and Stopping the Project
Start Services
bash
# From project root directory
make
This will:

Create necessary directories

Build Docker images

Start all containers in the background

Stop Services
bash
# Stop and remove containers
make down

# Stop containers but preserve data
docker compose -f srcs/docker-compose.yml stop
Restart Services
bash
make re
Accessing the Website
Website Access
Add to your /etc/hosts file:

text
127.0.0.1    abdennac.42.fr
Open browser and visit:

Main site: https://abdennac.42.fr

WordPress admin: https://abdennac.42.fr/wp-admin

If HTTPS doesn't work
Try accessing via HTTP: http://abdennac.42.fr:80

Credentials Management
Default Credentials
Credentials are stored in secrets/ directory:

Database root password: secrets/db_root_password.txt

WordPress database user password: secrets/db_password.txt

WordPress Admin Credentials
Set during first installation or in .env file:

Username: l3arbi

Password: strongpass

Changing Credentials
Edit the secret files:

bash
nano secrets/db_password.txt
nano secrets/db_root_password.txt
Rebuild containers:

bash
make re
Service Monitoring
Check Service Status
bash
# List running containers
docker ps

# Check container logs
docker logs nginx
docker logs wordpress
docker logs mariadb

# Follow logs in real-time
docker logs -f nginx
Verify Services are Working
bash
# Check website response
curl -I https://abdennac.42.fr

# Check database connectivity
docker exec wordpress mysql -h mariadb -u wpuser -p"$(cat secrets/db_password.txt)" -e "SHOW DATABASES;"
Troubleshooting
If services aren't accessible:

Check containers are running: docker ps

Check ports are open: netstat -tulpn | grep :443

Check /etc/hosts entry exists

Check browser isn't caching old DNS

Data Backup
Your website data is automatically persisted in Docker volumes:

WordPress files: srcs_wp_data volume

Database data: srcs_db_data volume

To backup:

bash
# Create backup directory
mkdir -p backup

# Backup WordPress volume
docker run --rm -v srcs_wp_data:/data -v $(pwd)/backup:/backup alpine tar czf /backup/wp_backup.tar.gz -C /data .

# Backup database
docker exec mariadb mysqldump -u root -p"$(cat secrets/db_root_password.txt)" wordpress > backup/database.sql