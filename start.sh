#!/bin/bash

rm -f /tmp/.X99-lock || true

export DISPLAY=:99

# DAHA KÜÇÜK ekran
Xvfb :99 -screen 0 720x1280x24 &
sleep 5

xsetroot -cursor_name left_ptr || true

chromium-browser \
  --no-sandbox \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-dev-shm-usage \
  --single-process \
  --no-zygote \
  --disable-background-networking \
  --disable-extensions \
  --disable-sync \
  --no-first-run \
  --window-size=720,1280 \
  --kiosk \
  --hide-scrollbars \
  --mute-audio \
  "https://macsavasi.github.io/macsavasi/" &

sleep 12

ffmpeg -re \
  -f x11grab -video_size 720x1280 -framerate 15 -i :99 \
  -f lavfi -i anullsrc \
  -c:v libx264 -preset ultrafast \
  -pix_fmt yuv420p \
  -b:v 1500k -maxrate 1500k -bufsize 3000k \
  -g 30 \
  -c:a aac -b:a 96k \
  -f flv \
  rtmp://a.rtmp.youtube.com/live2/rwbf-by2t-h4xe-39rg-ahz7
