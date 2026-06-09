#!/bin/bash

set -e

REPO_URL="https://github.com/klavsy/parallel.git"
PROJECT="parallel"

DOMAIN="YOUR_DOMAIN"
EMAIL="your-email@example.com"

echo "======================================"
echo "🌌 Parallel Universe AI Installer"
echo "======================================"

# -------------------------
# 1. System check
# -------------------------
echo "[1/10] System check..."

if ! command -v apt >/dev/null; then
    echo "❌ Only Ubuntu/Debian supported"
    exit 1
fi

apt update -y
apt install -y git curl ca-certificates

# -------------------------
# 2. Docker install
# -------------------------
echo "[2/10] Docker check..."

if ! command -v docker >/dev/null; then
    curl -fsSL https://get.docker.com | sh
fi

systemctl enable docker
systemctl start docker

# -------------------------
# 3. Clean old stack
# -------------------------
echo "[3/10] Cleaning old stack..."

docker compose down 2>/dev/null || true
docker system prune -f || true

# -------------------------
# 4. Clone / repair repo
# -------------------------
echo "[4/10] Fetching repo..."

if [ -d "$PROJECT" ]; then
    cd $PROJECT
    git reset --hard
    git pull
else
    git clone $REPO_URL
    cd $PROJECT
fi

# -------------------------
# 5. Validate structure
# -------------------------
echo "[5/10] Validating project..."

REQUIRED=(
  "index.html"
  "docker-compose.yml"
  "backend/app.py"
  "backend/Dockerfile"
  "backend/requirements.txt"
)

for file in "${REQUIRED[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Missing: $file"
        exit 1
    fi
done

echo "Structure OK ✔"

# -------------------------
# 6. Start Docker stack
# -------------------------
echo "[6/10] Starting Docker..."

docker compose up -d --build || {
    echo "❌ Build failed → retry clean rebuild"
    docker compose down
    docker compose build --no-cache
    docker compose up -d
}

# -------------------------
# 7. Wait for Ollama
# -------------------------
echo "[7/10] Waiting for Ollama..."

sleep 10

for i in {1..20}; do
    if curl -s http://localhost:11434 >/dev/null; then
        echo "Ollama ready ✔"
        break
    fi
    echo "Waiting..."
    sleep 3
done

echo "Pulling model..."
docker exec ollama ollama pull qwen3:8b || {
    sleep 5
    docker exec ollama ollama pull qwen3:8b
}

# -------------------------
# 8. Install Nginx + Certbot
# -------------------------
echo "[8/10] Installing HTTPS stack..."

apt install -y nginx certbot python3-certbot-nginx

# Stop nginx if already running
systemctl stop nginx || true

# -------------------------
# 9. Configure Nginx reverse proxy
# -------------------------
echo "[9/10] Configuring Nginx..."

cat > /etc/nginx/sites-available/parallel <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /api/ {
        proxy_pass http://localhost:8000;
    }
}
EOF

ln -sf /etc/nginx/sites-available/parallel /etc/nginx/sites-enabled/

nginx -t && systemctl restart nginx

# -------------------------
# 10. SSL (Let's Encrypt)
# -------------------------
echo "[10/10] Enabling HTTPS..."

certbot --nginx \
  -d $DOMAIN \
  --non-interactive \
  --agree-tos \
  -m $EMAIL || {
    echo "⚠ SSL failed (check domain DNS pointing to server)"
}

systemctl enable certbot.timer
systemctl start certbot.timer

# -------------------------
# FINAL OUTPUT
# -------------------------
IP=$(curl -s ifconfig.me)

echo ""
echo "======================================"
echo "🚀 DEPLOYMENT COMPLETE"
echo "======================================"
echo "🌐 HTTP:  http://$IP"
echo "🔐 HTTPS: https://$DOMAIN"
echo "⚙️ API:   https://$DOMAIN/api/generate"
echo "======================================"
echo ""
echo "Logs:"
echo "docker compose logs -f"
echo "======================================"
