FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    ffmpeg \
    chromium-browser \
    xvfb \
    x11-xserver-utils \
    ca-certificates \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libdrm2 \
    libgbm1 \
    libasound2

WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
