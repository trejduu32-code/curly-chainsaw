FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    chromium-browser \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    supervisor \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 10000

CMD ["/usr/bin/supervisord"]
