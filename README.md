Description
Inception is a system administration project that focuses on containerization using Docker. The goal is to set up a small infrastructure composed of Docker containers running various services: NGINX, WordPress with php-fpm, and MariaDB. The project must be done in a virtual machine and respects specific rules about Docker usage.

Project Goal
Create a multi-container Docker environment that runs:

NGINX as a web server with TLS/SSL

WordPress with php-fpm

MariaDB as a database

All services must run in separate Docker containers

Data must persist using Docker volumes

Design Choices & Comparisons
Virtual Machines vs Docker
Virtual Machines	Docker
Full OS with kernel	Shares host kernel
Heavyweight (GBs)	Lightweight (MBs)
Slow startup	Fast startup
Full isolation	Process isolation
Hardware virtualization	OS-level virtualization
Choice: Docker was chosen for its lightweight nature, fast startup times, and efficient resource usage, making it ideal for development and deployment of microservices.

Secrets vs Environment Variables
Secrets	Environment Variables
Stored in /run/secrets/	Stored in container environment
Encrypted at rest	Plaintext in container
Mounted as files	Available as strings
Better for passwords	Better for configuration
Choice: Secrets are used for sensitive data (database passwords) while environment variables are used for non-sensitive configuration (database names, usernames).

Docker Network vs Host Network
Docker Network	Host Network
Isolated network namespace	Shares host network
Port mapping required	Direct port access
Better security	Less secure
Service discovery via DNS	Localhost access
Choice: Docker Bridge Network is used for isolation and security, with proper port mapping for external access.

Docker Volumes vs Bind Mounts
Docker Volumes	Bind Mounts
Managed by Docker	Link to host directory
Better performance	Direct host access
Portable across systems	Host-dependent
Backed up via Docker	Manual backup needed
Choice: Docker Volumes are used for database and WordPress data to ensure persistence and better performance.

Instructions
Prerequisites
Docker

Docker Compose

Make (optional)

Virtual Machine (recommended)

Installation & Execution
bash
# Clone the repository
git clone <repository-url>
cd inception

# Build and start containers
make

# Or manually
docker compose -f srcs/docker-compose.yml up -d --build

# Stop containers
make down
# or
docker compose -f srcs/docker-compose.yml down
Access
Website: https://abdennac.42.fr

WordPress Admin: https://abdennac.42.fr/wp-admin

MariaDB: localhost:3306 (from containers)

Resources
Documentation
Docker Documentation

Docker Compose Documentation

NGINX Documentation

WordPress Documentation

MariaDB Documentation

AI Usage
AI was used for:

Debugging Docker configuration issues

Understanding Docker networking concepts

Generating script templates for container initialization

Explaining technical concepts for documentation

Note: All code and configurations were written manually. AI was used only as a learning and debugging aid.

