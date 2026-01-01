# Flutter Web App - Docker Deployment Guide (AlmaLinux VPS)

This guide explains how to deploy your Flutter web application to a VPS server running AlmaLinux
using Docker.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Setup - Build Flutter Web](#local-setup)
3. [Docker Setup](#docker-setup)
4. [VPS Server Setup](#vps-server-setup)
5. [Deployment Options](#deployment-options)
6. [HTTPS/SSL Setup](#httpsssl-setup)
7. [Monitoring & Maintenance](#monitoring--maintenance)

---

## Prerequisites

### On Your Local Machine:

- Flutter SDK installed
- Docker installed (for testing)
- SSH access to your VPS

### On Your VPS (AlmaLinux):

- Docker installed
- Docker Compose installed (optional but recommended)
- Ports 80 (HTTP) and 443 (HTTPS) open in firewall
- Domain name pointed to your VPS IP (optional, for HTTPS)

---

## 1. Local Setup - Build Flutter Web

### Step 1: Build the Flutter Web App

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build for web (production mode)
flutter build web --release --web-renderer html

# Or use canvaskit renderer (better performance but larger size)
# flutter build web --release --web-renderer canvaskit
```

This creates optimized files in `build/web/` directory.

### Step 2: Test Locally (Optional)

```bash
# Install a simple HTTP server
dart pub global activate dhttpd

# Serve the built files
dhttpd --path=build/web --port=8080

# Or use Python
cd build/web
python3 -m http.server 8080
```

Visit `http://localhost:8080` to test.

---

## 2. Docker Setup

### Option A: Simple Nginx Dockerfile

Create `Dockerfile` in your project root:

```dockerfile
# Stage 1: Build Flutter web app
FROM debian:bookworm-slim AS build

# Install Flutter dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME
RUN flutter doctor -v
RUN flutter config --enable-web

# Copy project files
WORKDIR /app
COPY . .

# Get dependencies and build
RUN flutter pub get
RUN flutter build web --release --web-renderer html

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy built web files to nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx config (see below)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
```

### Create `nginx.conf`:

```nginx
server {
    listen 80;
    server_name _;  # Replace with your domain name

    root /usr/share/nginx/html;
    index index.html;

    # Gzip compression for better performance
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript 
               application/x-javascript application/xml+rss 
               application/javascript application/json;

    # Handle Flutter web routing
    location / {
        try_files $uri $uri/ /index.html;
        
        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Disable access to hidden files
    location ~ /\. {
        deny all;
    }
}
```

### Create `.dockerignore`:

```
.dart_tool/
.packages
.pub/
build/
.flutter-plugins
.flutter-plugins-dependencies
.idea/
.vscode/
*.iml
*.log
.DS_Store
android/
ios/
linux/
macos/
windows/
test/
.git/
.gitignore
README.md
```

---

## 3. VPS Server Setup

### Step 1: Connect to VPS

```bash
ssh root@your-vps-ip
```

### Step 2: Ensure Docker is Installed

```bash
# Check if Docker is installed
docker --version

# If not installed:
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
```

### Step 3: Install Docker Compose (Optional but Recommended)

```bash
# Download latest version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

### Step 4: Configure Firewall

```bash
# Allow HTTP and HTTPS
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

# Verify
sudo firewall-cmd --list-all
```

---

## 4. Deployment Options

### Option A: Build Locally, Deploy Image

#### 1. Build Docker image locally:

```bash
docker build -t barter-app-web:latest .
```

#### 2. Save and transfer to VPS:

```bash
# Save image to tar file
docker save barter-app-web:latest | gzip > barter-app-web.tar.gz

# Transfer to VPS
scp barter-app-web.tar.gz root@your-vps-ip:/tmp/

# On VPS, load the image
ssh root@your-vps-ip
docker load < /tmp/barter-app-web.tar.gz
```

#### 3. Run container:

```bash
docker run -d \
  --name barter-app \
  --restart unless-stopped \
  -p 80:80 \
  barter-app-web:latest
```

### Option B: Build on VPS (Recommended for CI/CD)

#### 1. Transfer project files to VPS:

```bash
# Create directory on VPS
ssh root@your-vps-ip "mkdir -p /opt/barter-app"

# Use rsync to transfer files
rsync -avz --exclude='.git' \
  --exclude='build' \
  --exclude='android' \
  --exclude='ios' \
  . root@your-vps-ip:/opt/barter-app/
```

#### 2. Build on VPS:

```bash
ssh root@your-vps-ip
cd /opt/barter-app
docker build -t barter-app-web:latest .
```

#### 3. Run with Docker Compose (Recommended):

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  web:
    build: .
    image: barter-app-web:latest
    container_name: barter-app
    restart: unless-stopped
    ports:
      - "80:80"
    environment:
      - TZ=America/New_York  # Set your timezone
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

Run:

```bash
docker-compose up -d
```

### Option C: Use Docker Registry (Best for Production)

#### 1. Set up private registry or use Docker Hub:

```bash
# Login to Docker Hub
docker login

# Tag image
docker tag barter-app-web:latest your-dockerhub-username/barter-app-web:latest

# Push to registry
docker push your-dockerhub-username/barter-app-web:latest
```

#### 2. On VPS, pull and run:

```bash
docker pull your-dockerhub-username/barter-app-web:latest
docker run -d \
  --name barter-app \
  --restart unless-stopped \
  -p 80:80 \
  your-dockerhub-username/barter-app-web:latest
```

---

## 5. HTTPS/SSL Setup

### Option A: Using Let's Encrypt with Certbot + Nginx

#### 1. Install Certbot on VPS:

```bash
sudo dnf install epel-release
sudo dnf install certbot python3-certbot-nginx
```

#### 2. Stop Docker container temporarily:

```bash
docker stop barter-app
```

#### 3. Get SSL certificate:

```bash
sudo certbot certonly --standalone -d yourdomain.com -d www.yourdomain.com
```

#### 4. Update nginx.conf for HTTPS:

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;

    # SSL certificates (will be mounted as volumes)
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
    
    # SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    root /usr/share/nginx/html;
    index index.html;

    # ... rest of nginx config (same as above)
}
```

#### 5. Run container with SSL volumes:

```bash
docker run -d \
  --name barter-app \
  --restart unless-stopped \
  -p 80:80 \
  -p 443:443 \
  -v /etc/letsencrypt:/etc/letsencrypt:ro \
  barter-app-web:latest
```

### Option B: Using Reverse Proxy (Recommended)

Create `docker-compose-with-ssl.yml`:

```yaml
version: '3.8'

services:
  web:
    build: .
    image: barter-app-web:latest
    container_name: barter-app
    restart: unless-stopped
    expose:
      - "80"
    networks:
      - app-network

  nginx-proxy:
    image: nginxproxy/nginx-proxy:latest
    container_name: nginx-proxy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - nginx-certs:/etc/nginx/certs:ro
      - nginx-vhost:/etc/nginx/vhost.d
      - nginx-html:/usr/share/nginx/html
    networks:
      - app-network

  acme-companion:
    image: nginxproxy/acme-companion:latest
    container_name: nginx-proxy-acme
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - nginx-certs:/etc/nginx/certs
      - nginx-vhost:/etc/nginx/vhost.d
      - nginx-html:/usr/share/nginx/html
      - acme-state:/etc/acme.sh
    environment:
      - DEFAULT_EMAIL=your-email@example.com
    depends_on:
      - nginx-proxy
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  nginx-certs:
  nginx-vhost:
  nginx-html:
  acme-state:
```

Update your app's docker-compose:

```yaml
services:
  web:
    # ... existing config
    environment:
      - VIRTUAL_HOST=yourdomain.com,www.yourdomain.com
      - LETSENCRYPT_HOST=yourdomain.com,www.yourdomain.com
      - LETSENCRYPT_EMAIL=your-email@example.com
```

Run:

```bash
docker-compose -f docker-compose-with-ssl.yml up -d
```

---

## 6. Monitoring & Maintenance

### Useful Docker Commands

```bash
# View running containers
docker ps

# View logs
docker logs barter-app
docker logs -f barter-app  # Follow logs

# Restart container
docker restart barter-app

# Stop container
docker stop barter-app

# Remove container
docker rm barter-app

# View resource usage
docker stats barter-app

# Execute command in container
docker exec -it barter-app sh
```

### Update/Redeploy

```bash
# Stop and remove old container
docker stop barter-app
docker rm barter-app

# Remove old image
docker rmi barter-app-web:latest

# Rebuild and run
docker build -t barter-app-web:latest .
docker run -d --name barter-app --restart unless-stopped -p 80:80 barter-app-web:latest
```

### Automated Backups

Create a backup script `/opt/scripts/backup-app.sh`:

```bash
#!/bin/bash
BACKUP_DIR="/backups/barter-app"
DATE=$(date +%Y%m%d-%H%M%S)

mkdir -p $BACKUP_DIR

# Backup Docker image
docker save barter-app-web:latest | gzip > $BACKUP_DIR/barter-app-$DATE.tar.gz

# Keep only last 7 backups
ls -t $BACKUP_DIR/barter-app-*.tar.gz | tail -n +8 | xargs rm -f

echo "Backup completed: $BACKUP_DIR/barter-app-$DATE.tar.gz"
```

Add to cron:

```bash
# Edit crontab
crontab -e

# Add daily backup at 2 AM
0 2 * * * /opt/scripts/backup-app.sh >> /var/log/barter-backup.log 2>&1
```

### Health Check

Add to `docker-compose.yml`:

```yaml
services:
  web:
    # ... existing config
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

### Monitor with Portainer (Optional)

```bash
docker volume create portainer_data

docker run -d \
  -p 9000:9000 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

Access at `http://your-vps-ip:9000`

---

## 7. Troubleshooting

### App not accessible

```bash
# Check if container is running
docker ps

# Check nginx logs
docker logs barter-app

# Check if port is listening
sudo netstat -tulpn | grep :80

# Check firewall
sudo firewall-cmd --list-all
```

### Performance issues

```bash
# Check resource usage
docker stats

# Increase container resources if needed
docker update --memory="1g" --cpus="2" barter-app
```

### SSL issues

```bash
# Check certificate expiry
sudo certbot certificates

# Renew manually
sudo certbot renew

# Test renewal
sudo certbot renew --dry-run
```

---

## Quick Deploy Script

Create `deploy.sh` in your project:

```bash
#!/bin/bash
set -e

echo "🚀 Deploying Barter App to VPS..."

VPS_HOST="root@your-vps-ip"
DEPLOY_DIR="/opt/barter-app"

echo "📦 Building Flutter web app..."
flutter build web --release

echo "🔧 Building Docker image..."
docker build -t barter-app-web:latest .

echo "💾 Saving Docker image..."
docker save barter-app-web:latest | gzip > barter-app-web.tar.gz

echo "📤 Uploading to VPS..."
scp barter-app-web.tar.gz $VPS_HOST:/tmp/

echo "🔄 Deploying on VPS..."
ssh $VPS_HOST << 'EOF'
  docker load < /tmp/barter-app-web.tar.gz
  docker stop barter-app || true
  docker rm barter-app || true
  docker run -d \
    --name barter-app \
    --restart unless-stopped \
    -p 80:80 \
    barter-app-web:latest
  rm /tmp/barter-app-web.tar.gz
EOF

echo "🧹 Cleaning up..."
rm barter-app-web.tar.gz

echo "✅ Deployment complete!"
echo "🌐 Your app is now live at http://your-domain.com"
```

Make executable and run:

```bash
chmod +x deploy.sh
./deploy.sh
```

---

## Summary Checklist

- [ ] Flutter web build tested locally
- [ ] Dockerfile and nginx.conf created
- [ ] Docker installed on VPS
- [ ] Firewall configured (ports 80, 443)
- [ ] Domain DNS pointed to VPS IP
- [ ] Docker image built and deployed
- [ ] Container running and accessible
- [ ] SSL certificate configured
- [ ] Health checks working
- [ ] Backup strategy implemented
- [ ] Monitoring set up

---

## Additional Resources

- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Docker Documentation](https://docs.docker.com/)
- [Let's Encrypt](https://letsencrypt.org/)
- [Nginx Documentation](https://nginx.org/en/docs/)

Good luck with your deployment! 🚀
