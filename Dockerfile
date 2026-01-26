FROM alpine:3.19

RUN apk add --no-cache \
    ffmpeg \
    fontconfig \
    ttf-dejavu

WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
