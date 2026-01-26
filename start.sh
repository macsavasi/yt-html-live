#!/bin/bash

export DISPLAY=:99

echo "Xvfb baslatiliyor..."
Xvfb :99 -ac -screen 0 1080x1920x24 &
sleep 5

# İmleci gizle
xsetroot -cursor_name left_ptr || true

echo "Google Chrome aciliyor..."

# Chrome'u root olarak çalıştırmak için --no-sandbox ŞARTTIR.
google-chrome \
  --no-sandbox \
  --disable-gpu \
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
  "https://macsavasi.github.io/macsavasi/" &

sleep 15

echo "Yayin basliyor..."

# FFmpeg komutu
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
  rtmp://a.rtmp.youtube.com/live2/x6ab-az9c-v2a1-dedc-fhr5
