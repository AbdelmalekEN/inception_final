Environment Setup
Prerequisites
bash
# Install Docker
sudo apt-get update
sudo apt-get install docker.io docker-compose make

# Add user to docker group (optional)
sudo usermod -aG docker $USER
newgrp docker
Clone and Prepare
bash
git clone <repository-url>
cd inception

# Create secrets directory
mkdir -p secrets

# Create password files
echo "your_root_password" > secrets/db_root_password.txt
echo "your_wp_password" > secrets/db_password.txt

# Set proper permissions
chmod 600 secrets/*.txt

# Create .env file
cp .env.example .env
# Edit .env with your configuration
Project Structure
text
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            └── tools/
Build and Launch
Using Makefile
bash
# Build and start all services
make

# Stop and remove containers
make down

# Rebuild and restart
make re

# Clean everything (containers, images, volumes)
make fclean

# View logs
make logs
Using Docker Compose Directly
bash
# Build and start
docker compose -f srcs/docker-compose.yml up -d --build

# Start without rebuild
docker compose -f srcs/docker-compose.yml up -d

# View logs
docker compose -f srcs/docker-compose.yml logs

# Stop containers
docker compose -f srcs/docker-compose.yml down

# Stop and remove volumes
docker compose -f srcs/docker-compose.yml down -v
Container Management
Common Commands
bash
# List all containers
docker ps -a

# Enter container shell
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash

# View container logs
docker logs nginx
docker logs --tail 50 -f wordpress  # Follow last 50 lines

# Restart specific service
docker compose -f srcs/docker-compose.yml restart nginx

# View resource usage
docker stats
Database Operations
bash
# Access MariaDB
docker exec -it mariadb mysql -u root -p

# From host, connect to database
docker exec mariadb mysql -u wpuser -p"$(cat secrets/db_password.txt)" wordpress

# Backup database
docker exec mariadb mysqldump -u root -p"$(cat secrets/db_root_password.txt)" wordpress > backup.sql

# Restore database
docker exec -i mariadb mysql -u root -p"$(cat secrets/db_root_password.txt)" wordpress < backup.sql
Data Persistence
Volume Locations
WordPress data: srcs_wp_data volume → /var/www/html/ in container

Database data: srcs_db_data volume → /var/lib/mysql/ in container

Volume Management
bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect srcs_wp_data

# Backup volume data
docker run --rm -v srcs_wp_data:/data -v $(pwd):/backup alpine tar czf /backup/wp_data.tar.gz -C /data .

# Restore volume data
docker run --rm -v srcs_wp_data:/data -v $(pwd):/backup alpine sh -c "rm -rf /data/* && tar xzf /backup/wp_data.tar.gz -C /data"

# Remove volumes
docker volume rm srcs_wp_data srcs_db_data
Development Workflow
Modifying Configuration
Edit configuration files in srcs/requirements/<service>/conf/

Rebuild the service:

bash
docker compose -f srcs/docker-compose.yml build nginx
docker compose -f srcs/docker-compose.yml up -d nginx
Adding New Services
Create new directory in srcs/requirements/

Add Dockerfile and configuration

Update srcs/docker-compose.yml

Rebuild:

bash
docker compose -f srcs/docker-compose.yml up -d --build
Debugging
bash
# Check service connectivity
docker exec wordpress curl -I mariadb:3306

# Check DNS resolution
docker exec wordpress nslookup mariadb

# Check process status inside container
docker exec nginx ps aux

# Check file permissions
docker exec wordpress ls -la /var/www/html/
SSL Certificate Management
SSL certificates are automatically generated on first run:

Location: Inside nginx container /etc/nginx/ssl/

Regeneration: Delete certificates and restart nginx

Network Configuration
Network: srcs_inception_net (bridge network)

Services communicate via service names: nginx, wordpress, mariadb

External access via port mapping: 80→80, 443→443

Cleanup
bash
# Complete cleanup
make fclean
# or
docker compose -f srcs/docker-compose.yml down -v --rmi all --remove-orphans
docker system prune -a -f
docker volume prune -f
Testing
bash
# Run quick health check
./health_check.sh  # If available

# Test website functionality
curl -k https://abdennac.42.fr

# Test database connection
docker exec wordpress wp db check