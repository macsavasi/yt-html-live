#!/bin/bash

# Önceki çalışmadan kalan kilit dosyalarını temizle (Çökme sonrası yeniden başlatmalarda önemlidir)
rm -f /tmp/.X99-lock

echo "Xvfb sanal ekran baslatiliyor..."
# Xvfb'yi başlat
Xvfb :99 -ac -screen 0 1080x1920x24 &

# Xvfb'nin gerçekten hazır olmasını bekle (Maksimum 30 saniye dener)
echo "Ekranın hazir olmasi bekleniyor..."
for i in {1..30}; do
  if xdpyinfo -display :99 >/dev/null 2>&1; then
    echo "Ekran (X11) hazir!"
    break
  fi
  echo "Ekran bekleniyor... ($i/30)"
  sleep 1
done

# İmleci gizle
xsetroot -cursor_name left_ptr || true

echo "Google Chrome baslatiliyor..."

# Chrome Başlatma (Hataları önlemek için dbus-launch eklendi)
dbus-launch google-chrome \
  --no-sandbox \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-dev-shm-usage \
  --disable-background-networking \
  --disable-default-apps \
  --disable-extensions \
  --disable-sync \
  --no-first-run \
  --autoplay-policy=no-user-gesture-required \
  --window-size=1080,1920 \
  --start-maximized \
  --kiosk \
  --hide-scrollbars \
  --mute-audio \
  --user-data-dir=/tmp/chrome-data \
  --check-for-update-interval=31536000 \
  "https://macsavasi.github.io/macsavasi/" &

# Sayfanın yüklenmesi için güvenli bir bekleme süresi
sleep 10

echo "FFmpeg yayini basliyor..."

# YAYIN KOMUTU (Verdiğin yeni RTMP linki ile)
ffmpeg -y \
  -f x11grab -draw_mouse 0 -video_size 1080x1920 -framerate 30 -thread_queue_size 512 -i :99 \
  -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 \
  -c:v libx264 -preset veryfast -tune zerolatency \
  -pix_fmt yuv420p \
  -profile:v high -level 4.2 \
  -b:v 4000k -maxrate 4000k -bufsize 8000k \
  -g 60 \
  -c:a aac -b:a 128k \
  -f flv \
  rtmp://a.rtmp.youtube.com/live2/rwbf-by2t-h4xe-39rg-ahz7
