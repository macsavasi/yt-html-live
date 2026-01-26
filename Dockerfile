FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

# 1. Gerekli araçları ve Chrome bağımlılıklarını kur
RUN apt-get update && apt-get install -y \
    wget \
    ffmpeg \
    xvfb \
    x11-xserver-utils \
    dbus-x11 \
    libasound2 \
    libgbm1 \
    ca-certificates \
    fonts-liberation \
    --no-install-recommends

# 2. Google Chrome'u .deb olarak indir ve kur
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && rm -rf /var/lib/apt/lists/*

# 3. DBus ve izin düzeltmeleri (Hata almamak için gerekli)
RUN mkdir -p /var/run/dbus && \
    dbus-uuidgen > /var/lib/dbus/machine-id

WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
