#!/bin/bash

export DISPLAY=:99

# DİKEY sanal ekran (9:16)
Xvfb :99 -screen 0 1080x1920x24 &
sleep 4

# Cursor gizle
xsetroot -cursor_name left_ptr || true

# Chromium DİKEY açılıyor
chromium-browser \
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
  --force-device-scale-factor=1 \
  --kiosk \
  --hide-scrollbars \
  --mute-audio \
  "https://macsavasi.github.io/macsavasi/" &

sleep 10

# YouTube Shorts akışı
ffmpeg -re \
  -f x11grab -video_size 1080x1920 -framerate 30 -i :99 \
  -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 \
  -c:v libx264 -preset veryfast -tune zerolatency \
  -pix_fmt yuv420p \
  -profile:v high -level 4.2 \
  -b:v 4500k -maxrate 4500k -bufsize 9000k \
  -g 60 \
  -c:a aac -b:a 128k \
  -f flv \
  rtmp://a.rtmp.youtube.com/live2/YOUTUBE_STREAM_KEY
