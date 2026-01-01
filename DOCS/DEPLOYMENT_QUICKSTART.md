# 🚀 Quick Start - Deploy to VPS

## Prerequisites Checklist

- [ ] Flutter SDK installed locally
- [ ] Docker installed locally (for building)
- [ ] SSH access to AlmaLinux VPS
- [ ] Docker installed on VPS
- [ ] Ports 80 and 443 open on VPS firewall
- [ ] (Optional) Domain name pointing to VPS IP

---

## Option 1: Automated Deployment (Recommended)

### Step 1: Configure deployment script

Edit `deploy.sh` and update:

```bash
VPS_HOST="root@your-vps-ip"  # Your VPS IP or domain
VPS_PORT="22"                 # SSH port (usually 22)
```

### Step 2: Make script executable and run

```bash
chmod +x deploy.sh
./deploy.sh
```

That's it! The script will:

- Build Flutter web app
- Create Docker image
- Upload to VPS
- Deploy and start container

---

## Option 2: Manual Deployment

### Step 1: Build Flutter web

```bash
flutter build web --release
```

### Step 2: Build Docker image

```bash
docker build -t barter-app-web:latest .
```

### Step 3: Transfer to VPS

```bash
# Save image
docker save barter-app-web:latest | gzip > barter-app-web.tar.gz

# Upload to VPS
scp barter-app-web.tar.gz root@your-vps-ip:/tmp/
```

### Step 4: Deploy on VPS

```bash
# SSH to VPS
ssh root@your-vps-ip

# Load image
docker load < /tmp/barter-app-web.tar.gz

# Run container
docker run -d \
  --name barter-app \
  --restart unless-stopped \
  -p 80:80 \
  barter-app-web:latest

# Verify it's running
docker ps
```

### Step 5: Test

Visit `http://your-vps-ip` in a browser

---

## Option 3: Using Docker Compose

### Step 1: Transfer files to VPS

```bash
# From your local machine
rsync -avz --exclude='.git' --exclude='build' \
  . root@your-vps-ip:/opt/barter-app/
```

### Step 2: Build and deploy on VPS

```bash
# SSH to VPS
ssh root@your-vps-ip

# Navigate to project
cd /opt/barter-app

# Deploy with Docker Compose
docker-compose up -d --build

# View logs
docker-compose logs -f
```

---

## Enable HTTPS (Let's Encrypt)

### Prerequisites

- Domain name pointing to your VPS IP
- Ports 80 and 443 open

### Step 1: Update docker-compose.ssl.yml

Edit these lines in `docker-compose.ssl.yml`:

```yaml
VIRTUAL_HOST=yourdomain.com,www.yourdomain.com
LETSENCRYPT_HOST=yourdomain.com,www.yourdomain.com
LETSENCRYPT_EMAIL=your-email@example.com
```

### Step 2: Deploy with SSL

```bash
# On VPS
cd /opt/barter-app
docker-compose -f docker-compose.ssl.yml up -d
```

SSL certificate will be automatically obtained from Let's Encrypt!

---

## Useful Commands

### View logs

```bash
docker logs barter-app
docker logs -f barter-app  # Follow logs in real-time
```

### Restart application

```bash
docker restart barter-app
```

### Stop application

```bash
docker stop barter-app
```

### Update/Redeploy

```bash
# Stop and remove old container
docker stop barter-app
docker rm barter-app

# Run new version
docker run -d \
  --name barter-app \
  --restart unless-stopped \
  -p 80:80 \
  barter-app-web:latest
```

### Check container resource usage

```bash
docker stats barter-app
```

### Access container shell

```bash
docker exec -it barter-app sh
```

---

## Firewall Configuration (AlmaLinux)

If your app isn't accessible, check firewall:

```bash
# Check current rules
sudo firewall-cmd --list-all

# Allow HTTP and HTTPS
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

# Verify
sudo firewall-cmd --list-services
```

---

## Troubleshooting

### App not accessible

```bash
# 1. Check if container is running
docker ps

# 2. Check logs for errors
docker logs barter-app

# 3. Check if port 80 is listening
sudo netstat -tulpn | grep :80

# 4. Check firewall
sudo firewall-cmd --list-all

# 5. Test from VPS itself
curl http://localhost
```

### Container keeps restarting

```bash
# Check logs
docker logs barter-app

# Check if port 80 is already in use
sudo netstat -tulpn | grep :80

# If something is using port 80, stop it or use different port
docker run -d --name barter-app -p 8080:80 barter-app-web:latest
```

### Out of disk space

```bash
# Clean up Docker resources
docker system prune -a

# Check disk usage
df -h
```

### SSL certificate issues

```bash
# View certificate status
docker exec nginx-proxy-acme cat /etc/acme.sh/yourdomain.com/yourdomain.com.cer

# Force certificate renewal
docker exec nginx-proxy-acme acme.sh --renew -d yourdomain.com --force
```

---

## Update Checklist

When deploying updates:

- [ ] Test locally first: `flutter run -d chrome`
- [ ] Build and test Docker image locally
- [ ] Backup current deployment (optional)
- [ ] Deploy new version
- [ ] Test on VPS
- [ ] Monitor logs for errors

---

## Performance Tips

### 1. Use canvaskit renderer for better graphics

```bash
flutter build web --release --web-renderer canvaskit
```

### 2. Enable Gzip compression

Already configured in `nginx.conf` ✅

### 3. Use CDN for static assets

Consider using CloudFlare or similar CDN in front of your VPS

### 4. Optimize Docker image size

```dockerfile
# Use multi-stage build (already implemented) ✅
# Clean up build cache ✅
```

---

## Security Checklist

- [ ] Use HTTPS (Let's Encrypt)
- [ ] Keep Docker updated: `sudo dnf update docker-ce`
- [ ] Use non-root user for SSH (best practice)
- [ ] Configure fail2ban for SSH protection
- [ ] Regular backups
- [ ] Monitor logs for suspicious activity
- [ ] Keep Flutter and dependencies updated

---

## Next Steps

1. ✅ Deploy basic HTTP version
2. ✅ Test thoroughly
3. 🔒 Enable HTTPS with Let's Encrypt
4. 📊 Set up monitoring (Portainer, etc.)
5. 💾 Configure backups
6. 🚀 Set up CI/CD (GitHub Actions, GitLab CI, etc.)

---

## Support

If you encounter issues:

1. Check logs: `docker logs barter-app`
2. Review `DOCKER_WEB_DEPLOYMENT_GUIDE.md` for detailed info
3. Check Docker documentation
4. Verify firewall settings

Good luck! 🎉
