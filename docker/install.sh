#!/bin/sh
# Instalasi Siuji lewat Docker -- 1 perintah:
#
#   curl -fsSL https://raw.githubusercontent.com/arrido92/siuji-releases/main/docker/install.sh | sudo bash
#
# Skrip ini: (1) pasang Docker kalau belum ada, (2) siapkan folder instalasi
# + docker-compose.yml + .env dengan secret/password ACAK unik per instalasi
# (bukan default yang sama di semua instalasi), (3) docker compose up -d,
# (4) tampilkan & simpan kredensial admin awal.
#
# Untuk yang mau baca dulu isinya sebelum jalan (tanpa curl|bash), lihat
# docker-compose.yml + .env.docker.example di repo ini -- caranya di README.

set -eu

INSTALL_DIR="${SIUJI_INSTALL_DIR:-/opt/siuji}"
SIUJI_VERSION="${SIUJI_VERSION:-latest}"
COMPOSE_URL="https://raw.githubusercontent.com/arrido92/siuji-releases/main/docker/docker-compose.yml"

log() { printf '%s\n' "--> $*"; }
err() { printf '%s\n' "!!! $*" >&2; }

if [ "$(id -u)" -ne 0 ]; then
  err "Skrip ini perlu root (pasang Docker & tulis ke /opt). Jalankan pakai sudo."
  exit 1
fi

# 1. Pasang Docker kalau belum ada -- pakai skrip resmi Docker (get.docker.com),
#    bukan tulis ulang deteksi distro sendiri.
if ! command -v docker >/dev/null 2>&1; then
  log "Docker belum terpasang, memasang lewat skrip resmi get.docker.com..."
  curl -fsSL https://get.docker.com | sh
else
  log "Docker sudah terpasang, lanjut."
fi

if ! docker compose version >/dev/null 2>&1; then
  err "Docker Compose plugin tidak ditemukan walau Docker sudah terpasang. Pasang manual: https://docs.docker.com/compose/install/"
  exit 1
fi

# 2. Siapkan folder instalasi.
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

log "Mengunduh docker-compose.yml..."
curl -fsSL "$COMPOSE_URL" -o docker-compose.yml

# Pin ke versi tertentu kalau SIUJI_VERSION di-set eksplisit (default
# "latest") -- sed aman karena docker-compose.yml resmi selalu pakai
# placeholder literal ini, bukan nilai yang berubah-ubah.
if [ "$SIUJI_VERSION" != "latest" ]; then
  sed -i "s/siuji:latest/siuji:$SIUJI_VERSION/" docker-compose.yml
fi

# 3. Generate .env kalau belum ada -- JANGAN timpa instalasi yang sudah
#    pernah di-setup sebelumnya (mis. re-run skrip ini buat update Docker).
if [ -f .env ]; then
  log ".env sudah ada, tidak ditimpa (dianggap instalasi lama)."
else
  log "Membuat .env dengan secret & password acak (unik untuk instalasi ini)..."
  RANDOM_JWT_SECRET="$(openssl rand -hex 32)"
  RANDOM_ADMIN_PASSWORD="$(openssl rand -base64 12 | tr -d '=+/')"

  cat > .env <<EOF
DB_USER=siuji
DB_PASSWORD=$(openssl rand -hex 16)
JWT_SECRET=$RANDOM_JWT_SECRET
ADMIN_EMAIL=admin@siuji.local
ADMIN_PASSWORD=$RANDOM_ADMIN_PASSWORD
APP_PORT=8080
APP_ENV=production
EOF
  chmod 600 .env
fi

# 4. Jalankan.
log "Menjalankan docker compose up -d..."
docker compose up -d

# 5. Tunggu health check app siap (maks ~2 menit) sebelum kasih tahu selesai.
log "Menunggu server siap..."
i=0
while [ "$i" -lt 60 ]; do
  status="$(docker inspect --format='{{.State.Health.Status}}' "$(docker compose ps -q app)" 2>/dev/null || echo starting)"
  if [ "$status" = "healthy" ]; then
    break
  fi
  i=$((i + 1))
  sleep 2
done

SERVER_IP="$(curl -fsSL -4 https://ifconfig.me 2>/dev/null || echo "<IP-SERVER-ANDA>")"
ADMIN_EMAIL_SHOWN="$(grep '^ADMIN_EMAIL=' .env | cut -d= -f2)"
ADMIN_PASSWORD_SHOWN="$(grep '^ADMIN_PASSWORD=' .env | cut -d= -f2)"

# Simpan juga ke file terpisah -- terminal bisa ter-scroll/tertutup sebelum
# sempat dicatat, file ini jadi cadangan yang bisa dibuka kapan saja nanti.
cat > "$INSTALL_DIR/kredensial-awal.txt" <<EOF
Siuji -- kredensial admin awal (dibuat: $(date))
URL   : http://$SERVER_IP:8080
Email : $ADMIN_EMAIL_SHOWN
Sandi : $ADMIN_PASSWORD_SHOWN

Segera login & ganti email/password lewat menu Profil.
File ini boleh dihapus setelah kredensial dicatat di tempat aman.
EOF
chmod 600 "$INSTALL_DIR/kredensial-awal.txt"

echo ""
echo "============================================================"
echo " Instalasi selesai!"
echo ""
echo "   URL   : http://$SERVER_IP:8080"
echo "   Email : $ADMIN_EMAIL_SHOWN"
echo "   Sandi : $ADMIN_PASSWORD_SHOWN"
echo ""
echo "   (kredensial ini juga tersimpan di $INSTALL_DIR/kredensial-awal.txt)"
echo ""
echo "   Segera login & ganti email/password lewat menu Profil."
echo "============================================================"
