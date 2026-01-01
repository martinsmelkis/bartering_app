#!/bin/bash
set -e

# Configuration - Update these variables
VPS_HOST="root@your-vps-ip"  # Change to your VPS IP or hostname
VPS_PORT="22"                 # SSH port
DEPLOY_DIR="/opt/barter-app"
APP_NAME="barter-app"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting deployment of Barter App...${NC}"

# Step 1: Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean

# Step 2: Get dependencies
echo -e "${YELLOW}📦 Getting Flutter dependencies...${NC}"
flutter pub get

# Step 3: Build Flutter web app
echo -e "${YELLOW}🔨 Building Flutter web app...${NC}"
flutter build web --release --web-renderer html

# Step 4: Build Docker image
echo -e "${YELLOW}🐳 Building Docker image...${NC}"
docker build -t ${APP_NAME}-web:latest .

# Step 5: Save Docker image to tar
echo -e "${YELLOW}💾 Saving Docker image...${NC}"
docker save ${APP_NAME}-web:latest | gzip > ${APP_NAME}-web.tar.gz

# Step 6: Upload to VPS
echo -e "${YELLOW}📤 Uploading image to VPS...${NC}"
scp -P ${VPS_PORT} ${APP_NAME}-web.tar.gz ${VPS_HOST}:/tmp/

# Step 7: Deploy on VPS
echo -e "${YELLOW}🔄 Deploying on VPS...${NC}"
ssh -p ${VPS_PORT} ${VPS_HOST} << EOF
  set -e
  
  echo "Loading Docker image..."
  docker load < /tmp/${APP_NAME}-web.tar.gz
  
  echo "Stopping existing container..."
  docker stop ${APP_NAME} 2>/dev/null || true
  docker rm ${APP_NAME} 2>/dev/null || true
  
  echo "Starting new container..."
  docker run -d \
    --name ${APP_NAME} \
    --restart unless-stopped \
    -p 80:80 \
    ${APP_NAME}-web:latest
  
  echo "Cleaning up..."
  rm /tmp/${APP_NAME}-web.tar.gz
  
  echo "Pruning old Docker images..."
  docker image prune -f
  
  echo "Checking container status..."
  docker ps | grep ${APP_NAME}
EOF

# Step 8: Clean up local files
echo -e "${YELLOW}🧹 Cleaning up local files...${NC}"
rm ${APP_NAME}-web.tar.gz

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${GREEN}🌐 Your app should now be accessible at:${NC}"
echo -e "${GREEN}   http://$(echo ${VPS_HOST} | cut -d'@' -f2)${NC}"
echo ""
echo -e "${YELLOW}📊 To check logs, run:${NC}"
echo -e "   ssh ${VPS_HOST} 'docker logs ${APP_NAME}'"
echo ""
echo -e "${YELLOW}🔍 To check container status, run:${NC}"
echo -e "   ssh ${VPS_HOST} 'docker ps'"
