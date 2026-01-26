FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Temel araçları güncelle ve kur
RUN apt-get update && apt-get install -y \
    wget \
    ffmpeg \
    xvfb \
    ca-certificates \
    pulseaudio \
    --no-install-recommends

# 2. Google Chrome'u .deb olarak indir ve kur
# Not: apt install ./dosya.deb komutu gerekli tüm yan kütüphaneleri (libgtk, alsa vb.) otomatik çeker.
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
