#!/bin/bash

# DigitalOcean Deployment Script
echo "🚀 Finder projesini deploy ediliyor..."

# Renklendirme
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Hata durumunda dur
set -e

# Proje dizinine git
PROJECT_DIR="/var/www/finder"
echo -e "${YELLOW}📁 Proje dizinine gidiliyor: $PROJECT_DIR${NC}"
cd $PROJECT_DIR

# Git pull
echo -e "${YELLOW}📥 En son değişiklikler çekiliyor...${NC}"
git pull origin main

# Bağımlılıkları güncelle
echo -e "${YELLOW}📦 Bağımlılıklar güncelleniyor...${NC}"
npm install

# Projeyi build et
echo -e "${YELLOW}🔨 Proje build ediliyor...${NC}"
npm run build

# PM2'yi restart et
echo -e "${YELLOW}🔄 PM2 restart ediliyor...${NC}"
pm2 restart finder

# Status kontrol et
echo -e "${YELLOW}📊 PM2 durumu kontrol ediliyor...${NC}"
pm2 status

echo -e "${GREEN}✅ Deployment tamamlandı!${NC}"
echo -e "${GREEN}🌐 Site erişilebilir: http://YOUR_IP:3000${NC}"