# DigitalOcean Ubuntu 25.04 Deployment Talimatları

## 1. Sunucu Hazırlığı

### Node.js ve NPM Kurulumu
```bash
# Node.js 20.x kurulumu
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Versiyonu kontrol et
node --version
npm --version
```

### PM2 Kurulumu (Process Manager)
```bash
sudo npm install -g pm2
```

### Git Kurulumu
```bash
sudo apt update
sudo apt install git -y
```

## 2. Proje Deployment

### Proje Dizini Oluştur
```bash
sudo mkdir -p /var/www
cd /var/www
```

### Projeyi Klonla
```bash
# Git repository'den klonla (kendi repository'nizi kullanın)
sudo git clone YOUR_REPOSITORY_URL finder
cd finder

# Veya dosyaları manuel olarak yükle
sudo chown -R $USER:$USER /var/www/finder
```

### Bağımlılıkları Yükle
```bash
cd /var/www/finder
npm install
```

### Projeyi Build Et
```bash
npm run build
```

## 3. PM2 ile Çalıştır

### Log Dizini Oluştur
```bash
sudo mkdir -p /var/log/pm2
sudo chown -R $USER:$USER /var/log/pm2
```

### PM2 ile Başlat
```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

### PM2 Komutları
```bash
# Durumu kontrol et
pm2 status

# Logları görüntüle
pm2 logs finder

# Restart et
pm2 restart finder

# Stop et
pm2 stop finder

# Sil
pm2 delete finder
```

## 4. Firewall Ayarları

### UFW ile Port 3000'i Aç
```bash
sudo ufw allow 3000
sudo ufw enable
sudo ufw status
```

## 5. Nginx Reverse Proxy (Opsiyonel - Önerilir)

### Nginx Kurulumu
```bash
sudo apt install nginx -y
```

### Nginx Konfigürasyonu
```bash
sudo nano /etc/nginx/sites-available/finder
```

Aşağıdaki içeriği ekle:
```nginx
server {
    listen 80;
    server_name YOUR_DOMAIN_OR_IP;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Nginx'i Aktif Et
```bash
sudo ln -s /etc/nginx/sites-available/finder /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

# Port 80'i aç
sudo ufw allow 80
```

## 6. SSL Sertifikası (Opsiyonel)

### Certbot Kurulumu
```bash
sudo apt install certbot python3-certbot-nginx -y
```

### SSL Sertifikası Al
```bash
sudo certbot --nginx -d YOUR_DOMAIN
```

## 7. Otomatik Deployment Script

Proje güncellemeleri için:
```bash
#!/bin/bash
cd /var/www/finder
git pull origin main
npm install
npm run build
pm2 restart finder
```

## 8. Erişim Testi

### Doğrudan Next.js (Port 3000)
```
http://YOUR_DIGITALOCEAN_IP:3000
```

### Nginx üzerinden (Port 80)
```
http://YOUR_DIGITALOCEAN_IP
```

## Önemli Notlar

1. **YOUR_DIGITALOCEAN_IP** yerine gerçek IP adresinizi kullanın
2. **YOUR_DOMAIN** yerine domain adınızı kullanın (varsa)
3. **YOUR_REPOSITORY_URL** yerine Git repository URL'nizi kullanın
4. Güvenlik için production'da environment variable'ları kullanın
5. Log dosyalarını düzenli olarak temizleyin
6. PM2'yi sistem başlangıcında otomatik başlatmak için `pm2 startup` kullanın

## Sorun Giderme

### Portun Açık Olup Olmadığını Kontrol Et
```bash
sudo netstat -tlnp | grep :3000
```

### PM2 Loglarını Kontrol Et
```bash
pm2 logs finder --lines 100
```

### Nginx Loglarını Kontrol Et
```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```