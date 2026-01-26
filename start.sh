#!/bin/bash

export DISPLAY=:99

Xvfb :99 -screen 0 1280x720x24 &
sleep 3

chromium-browser \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --autoplay-policy=no-user-gesture-required \
  --window-size=1280,720 \
  --kiosk \
  --hide-scrollbars \
  --mute-audio \
  "https://macsavasi.github.io/macsavasi/" &

sleep 6

ffmpeg -re \
  -f x11grab -video_size 1280x720 -framerate 30 -i :99 \
  -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 \
  -c:v libx264 -preset veryfast -tune zerolatency -pix_fmt yuv420p \
  -b:v 2500k -maxrate 2500k -bufsize 5000k \
  -g 60 \
  -c:a aac -b:a 128k \
  -f flv \
  rtmp://a.rtmp.youtube.com/live2/rwbf-by2t-h4xe-39rg-ahz7
