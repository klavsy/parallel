#!/bin/bash

set -e

echo "🚀 Installing Parallel Universe AI..."

apt update -y
apt install -y git curl

# Docker install
curl -fsSL https://get.docker.com | sh

systemctl enable docker
systemctl start docker

# clone repo
rm -rf parallel
git clone https://github.com/klavsy/parallel.git
cd parallel

# start stack
docker compose up -d --build

echo "⏳ Waiting for Ollama..."
sleep 20

until curl -s http://localhost:11434 >/dev/null; do
  sleep 3
done

echo "📦 Pulling AI model..."
docker exec ollama ollama pull qwen3:8b

IP=$(curl -s ifconfig.me)

echo ""
echo "=============================="
echo "✅ DEPLOYED SUCCESSFULLY"
echo "=============================="
echo "🌐 Website: http://$IP"
echo "⚙️ API: http://$IP/api/generate"
echo "🤖 Ollama: http://$IP:11434"
echo "=============================="
