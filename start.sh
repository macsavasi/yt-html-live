#!/bin/bash

export DISPLAY=:99

# Virtual ekran
Xvfb :99 -screen 0 1280x720x24 &
sleep 4

# Cursor gizle (siyah ekrandaki işaret gider)
xsetroot -cursor_name left_ptr || true

# Chromium’u render zorlayarak başlat
chromium-browser \
  --no-sandbox \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-dev-shm-usage \
  --disable-background-networking \
  --disable-default-apps \
  --disable-extensions \
  --disable-sync \
  --metrics-recording-only \
  --no-first-run \
  --autoplay-policy=no-user-gesture-required \
  --window-size=1280,720 \
  --force-device-scale-factor=1 \
  --kiosk \
  --hide-scrollbars \
  --mute-audio \
  "https://macsavasi.github.io/macsavasi/" &

# Chromium’un gerçekten çizmesi için bekle
sleep 10

# YouTube yayını
ffmpeg -re \
  -f x11grab -video_size 1280x720 -framerate 30 -i :99 \
  -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 \
  -c:v libx264 -preset veryfast -tune zerolatency \
  -pix_fmt yuv420p \
  -b:v 3000k -maxrate 3000k -bufsize 6000k \
  -g 60 \
  -c:a aac -b:a 128k \
  -f flv \
  rtmp://a.rtmp.youtube.com/live2/rwbf-by2t-h4xe-39rg-ahz7
