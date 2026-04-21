# Flutter Web App - Docker Deployment Guide (AlmaLinux VPS)

This guide explains how to deploy your Flutter web application to a VPS server running AlmaLinux
using Docker.

---

## Prerequisites

### On Your Local Machine:

- Flutter SDK installed
- Docker installed (for testing)
- SSH access to your VPS

### 1. Server Setup on the VPS (e.g. AlmaLinux):

```bash
1. Docker

sudo dnf update -y
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl enable --now docker

2. Certificates

sudo dnf update -y ca-certificates
sudo update-ca-trust
sudo update-ca-trust extract

3. Firewall

sudo yum install firewalld -y
sudo systemctl enable --now firewalld.service

docker network ls
sudo firewall-cmd --permanent --zone=trusted --add-interface=br-xxxxxx
sudo firewall-cmd --zone=trusted --add-port=5432/tcp --permanent

sudo firewall-cmd --zone=public --add-port=8081/tcp --permanent
sudo firewall-cmd --reload

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

4. Nginx, certbot

sudo dnf install -y epel-release
sudo dnf install -y nginx
sudo dnf install -y certbot python3-certbot-nginx

5. Make backend config dir

mkdir /opt/barterappbackend
mkdir /opt/barterappbackend/deploy

6. Install certificates, configure nginx for domain

sudo mkdir -p /var/www/bartering.app
sudo chmod -R 755 /var/www/bartering.app
sudo chown -R nginx:nginx /var/www/bartering.app

sudo chmod 755 /var/www/bartering.app/assets/packages/
sudo chmod 755 /var/www/bartering.app/assets/packages/flutter_osm_web

Delete AAAA Record, if not explicitly configured for IPv6
Wait ~6 minutes

sudo certbot certonly --standalone \
-d bartering.app \
-d www.bartering.app \
--non-interactive \
--agree-tos \
-m ajezi101@gmail.com

sudo nano /etc/nginx/conf.d/bartering-app.conf
Paste from barter_app_backend/livedeployment/nginx.conf

sudo systemctl stop nginx

sudo nginx -t
sudo systemctl start nginx
sudo systemctl enable nginx

7 ENVIRONMENT Variables

nano .env if needed - check barter_app_backend docker-compose for environment variables to set

```

## 2. Local Setup - Build Flutter Web

### Step 1: Build the Flutter Web App

```bash
In project root:

flutter build web --release --dart-define=FLAVOR=prod

WASM:
flutter build web --wasm --release --dart-define=FLAVOR=prod

This creates optimized files in `build/web/` directory.

cd bartering_app
scp -r build/web/* root@VPS.IP:/var/www/bartering.app/

On VPS:

cd /opt/barterappbackend/deploy
docker compose up --build

```

#### 3. Update nginx.conf for HTTPS in the Backend:

```nginx
# Nginx configuration for Barter App - bartering.app
# For Rocky Linux/RHEL: Place this file in /etc/nginx/conf.d/barter-app.conf
# For Debian/Ubuntu: Place in /etc/nginx/sites-available/ and symlink to sites-enabled/
# Then reload: sudo systemctl reload nginx

upstream barter_backend {
    server 127.0.0.1:8081;
    keepalive 32;
}

# ============================================================================
# RATE LIMITING ZONES - Industry Standard Configuration
# ============================================================================
# Based on OWASP recommendations and production best practices

# General API - Moderate limits for standard operations (300 req/min per IP)
# Increased for SPA apps that make multiple simultaneous requests on page load
limit_req_zone $binary_remote_addr zone=api_general:10m rate=300r/m;

# Authentication - Strict limits to prevent brute force (5 req/min per IP)
# OWASP recommends 3-5 attempts per minute for auth endpoints
limit_req_zone $binary_remote_addr zone=api_auth:10m rate=5r/m;

# File uploads - Very strict to prevent resource exhaustion (2 req/min per IP)
limit_req_zone $binary_remote_addr zone=api_upload:10m rate=2r/m;

# Search/Query - Moderate limits for expensive operations (30 req/min per IP)
# Prevents database overload from complex queries
limit_req_zone $binary_remote_addr zone=api_search:10m rate=30r/m;

# Profile updates - Moderate limits (60 req/min per IP)
# Increased because profile-info is called frequently during navigation
limit_req_zone $binary_remote_addr zone=api_profile:10m rate=60r/m;

# Read-only data endpoints - Higher limits for frequent access (200 req/min per IP)
# For relationships, blocking status, favorites - called on every profile/chat view
limit_req_zone $binary_remote_addr zone=api_readonly:10m rate=240r/m;

# Chat/WebSocket - Connection-based limits (allow more frequent reconnects)
# Messages limited by application layer
# Increased to handle rapid reconnections during development/debugging
limit_req_zone $binary_remote_addr zone=api_websocket:10m rate=180r/m;

# Connection limiting - Max concurrent connections per IP
limit_conn_zone $binary_remote_addr zone=addr:10m;

server {
    listen 80;
    listen [::]:80;
    server_name bartering.app www.bartering.app;

    # Allow certbot validation for SSL certificate renewal
    location ^~ /.well-known/acme-challenge/ {
        default_type "text/plain";
        root /var/www/certbot;
    }

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

# Redirect www to non-www (optional but recommended)
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name www.bartering.app;

    ssl_certificate /etc/letsencrypt/live/bartering.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/bartering.app/privkey.pem;

    return 301 https://bartering.app$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name bartering.app;

    # SSL Configuration (use Let's Encrypt)
    ssl_certificate /etc/letsencrypt/live/bartering.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/bartering.app/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # OCSP Stapling - improves SSL performance
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/letsencrypt/live/bartering.app/chain.pem;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;

    # Compression
    # Brotli (better compression ratio) + gzip fallback for older clients/proxies
    brotli on;
    brotli_comp_level 5;
    brotli_min_length 1024;
    brotli_static on;
    brotli_types text/plain text/css text/xml text/javascript application/javascript application/x-javascript application/xml+rss application/json image/svg+xml;

    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Logging
    access_log /var/log/nginx/barter-app-access.log;
    error_log /var/log/nginx/barter-app-error.log warn;

    # Max body size for file uploads (default - overridden in specific locations)
    client_max_body_size 5M;

    # Custom error page for rate limiting
    limit_req_status 429;
    limit_conn_status 429;

    # For HTML files - NO caching (always fresh)
    location ~ \.html$ {
        expires -1;
        add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";
    }

    # For index page - NO caching
    location = / {
        expires -1;
        add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";
    }

    # ========================================================================
    # HEALTH CHECK - Light rate limits (for monitoring)
    # ========================================================================
    # Allow frequent checks but prevent abuse
    # 300 req/min = 5 req/sec (plenty for monitoring, prevents spam)
    location /health {
        limit_req zone=api_general burst=50 nodelay;

        proxy_pass http://barter_backend;
        access_log off;
    }

    # ========================================================================
    # AUTHENTICATION ENDPOINTS - STRICTEST LIMITS
    # ========================================================================
    # Protects against brute force attacks on login/registration
    # Industry standard: 3-5 attempts per minute

    location ~ ^/api/v1/authentication/(login|register|verify) {
        # Very strict: 5 requests per minute, allow burst of 3
        limit_req zone=api_auth burst=3 nodelay;
        limit_req_status 429;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Shorter timeout for auth to prevent hanging
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # User deletion - Very sensitive, strict limits
    location ~ ^/api/v1/authentication/user/[^/]+$ {
        limit_req zone=api_auth burst=2 nodelay;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # ========================================================================
    # FILE UPLOAD ENDPOINTS - VERY STRICT LIMITS
    # ========================================================================
    # Prevents resource exhaustion from large uploads
    # Industry standard: 1-3 uploads per minute
    # Note: Individual file upload endpoints are configured separately below

    # Posting creation with multiple images
    location = /api/v1/postings/with-images {
        # Very strict: 2 uploads per minute, burst of 1
        limit_req zone=api_upload burst=1 nodelay;

        # Allow larger files for image uploads
        client_max_body_size 50M;
        client_body_timeout 300s;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Longer timeout for file uploads
        proxy_connect_timeout 120s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
        proxy_request_buffering off;
    }

    # ========================================================================
    # SEARCH/QUERY ENDPOINTS - MODERATE LIMITS
    # ========================================================================
    # Expensive database operations (semantic search, nearby queries)
    # Increased to 30 per minute for better UX when browsing nearby users/offers

    location ~ ^/api/v1/profiles/(nearby|search) {
        # Moderate: 30 per minute, burst of 15 (3x increase for better UX)
        limit_req zone=api_search burst=15 nodelay;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Longer timeout for complex queries
        proxy_connect_timeout 60s;
        proxy_send_timeout 90s;
        proxy_read_timeout 90s;
    }

    # Similar and complementary profiles (computationally expensive)
    location ~ ^/api/v1/(similar|complementary)-profiles {
        # Moderate: 30 per minute, burst of 15 (3x increase for better UX)
        limit_req zone=api_search burst=15 nodelay;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 60s;
        proxy_send_timeout 90s;
        proxy_read_timeout 90s;
    }

    location ~ ^/api/v1/postings/(search|nearby) {
        # Moderate: 30 per minute, burst of 15 (3x increase for better UX)
        limit_req zone=api_search burst=15 nodelay;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 60s;
        proxy_send_timeout 90s;
        proxy_read_timeout 90s;
    }

    # ========================================================================
    # PROFILE UPDATE ENDPOINTS - MODERATE LIMITS
    # ========================================================================

    location ~ ^/api/v1/profile-(update|create|info|info-extended)$ {
        # Moderate: 60 per minute, burst of 20
        limit_req zone=api_profile burst=20 nodelay;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # ========================================================================
    # NOTIFICATION ENDPOINTS - MODERATE LIMITS
    # ========================================================================

    location /api/v1/notifications/ {
        limit_req zone=api_general burst=20 nodelay;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # ========================================================================
    # REVIEWS, TRANSACTIONS, REPUTATION ENDPOINTS - MODERATE LIMITS
    # ========================================================================

    location ~ ^/api/v1/(reviews|transactions|reputation)/ {
        limit_req zone=api_general burst=15 nodelay;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # ========================================================================
    # CHAT FILE UPLOAD/DOWNLOAD - ENCRYPTED FILES
    # ========================================================================

    # Encrypted file upload
    location = /chat/files/upload {
        limit_req zone=api_upload burst=2 nodelay;

        # Allow larger files (encrypted files may be bigger)
        client_max_body_size 100M;
        client_body_timeout 300s;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Longer timeout for file uploads
        proxy_connect_timeout 120s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
        proxy_request_buffering off;
    }

    # Encrypted file download
    location ~ ^/chat/files/download/ {
        limit_req zone=api_general burst=10 nodelay;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Long timeout for large downloads
        proxy_connect_timeout 60s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }

    # ========================================================================
    # WEBSOCKET ENDPOINTS - CONNECTION + MESSAGE LIMITS
    # ========================================================================
    # Industry standard: 3-5 connections per IP, message rate handled by app
    # IMPORTANT: Path is /chat (not /ws) to match ChatRoutes.kt

    location /chat {
        limit_req zone=api_websocket burst=35 nodelay;
        limit_conn addr 16;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 60s;
        proxy_send_timeout 86400s;
        proxy_read_timeout 86400s;

        proxy_buffering off;
        tcp_nodelay on;
    }

    # ========================================================================
    # READ-ONLY DATA ENDPOINTS - HIGHER LIMITS
    # ========================================================================
    # Frequently accessed read-only endpoints (relationships, blocking, favorites)

    location ~ ^/api/v1/(relationships|users/isBlocked|favorites)/ {
        # Higher limits for read-only data: 200 per minute, burst of 30
        limit_req zone=api_readonly burst=30 nodelay;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # ========================================================================
    # GENERAL API ENDPOINTS - DEFAULT LIMITS
    # ========================================================================
    # Catch-all for other API endpoints

    location /api/ {
        # General rate limiting: 300 per minute, burst of 40
        limit_req zone=api_general burst=40 nodelay;
        limit_conn addr 10;

        proxy_pass http://barter_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Standard timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # ========================================================================
    # UPLOADED IMAGES - User Content
    # ========================================================================
    # Serve user-uploaded images (posting images, profile pictures, etc.)
    # Path must match docker volume mount location

    location /uploads/ {
        alias /opt/barterappbackend/deploy/uploads/;

        # Security: Block files without allowed extensions
        if ($request_uri !~* \.(jpg|jpeg|png|gif|webp|svg|si)$) {
            return 403;
        }

        # Cache uploaded images
        expires 30d;
        add_header Cache-Control "public, immutable";

        # CORS for images (if needed by external clients)
        add_header Access-Control-Allow-Origin "*";

        # Security headers
        add_header X-Content-Type-Options "nosniff" always;
    }

    # ========================================================================
    # FLUTTER WEB ASSETS - Specific location for assets directory
    # ========================================================================
    # Handle assets with proper directory indexing for subdirectories like avatars

    location /assets/ {
        alias /var/www/bartering.app/assets/;  # Note: ends with /assets/

        autoindex off;
        try_files $uri $uri/ =404;

        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|si|html)$ {
                expires 0;
                add_header Cache-Control "public, immutable";
                access_log off;
        }

        # SVG MIME type
        location ~* \.svg$ {
                add_header Content-Type image/svg+xml;
                expires 1y;
                add_header Cache-Control "public, immutable";
                access_log off;
        }

        # HTML assets (like map.html)
        location ~* \.html$ {
                add_header Content-Type text/html;
                expires 0;
                add_header Cache-Control "public, immutable";
                access_log off;
        }
    }

    # ========================================================================
    # FLUTTER WEB APP - Static Files
    # ========================================================================
    # Serve Flutter web application (build/web directory)

    location / {
        root /var/www/bartering.app;
        index index.html;
        try_files $uri $uri/ /index.html;

        # Cache static assets
        location ~* \.(si|js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            root /var/www/bartering.app;
            expires 0;
            add_header Cache-Control "public, immutable";
        }

        # Don't cache index.html (for deployments)
        location = /index.html {
            root /var/www/bartering.app;
            add_header Cache-Control "no-cache, no-store, must-revalidate";
            expires 0;
        }
    }
}
```

---

## 4. Monitoring & Maintenance

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

## 5. Troubleshooting

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

VPS_HOST="root@VPS.IP"

echo "📦 Building Flutter web app..."
flutter build web --release

echo "📤 Uploading to VPS..."
scp -r build/web/* VPS_HOST:/var/www/bartering.app/

echo "🔄 Deploying on VPS..."
ssh $VPS_HOST << 'EOF'
  ./start-barter-app.sh
EOF

echo "✅ Deployment complete!"
echo "🌐 Your app is now live at https://bartering.app"
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
