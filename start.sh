#!/bin/bash

export DISPLAY=:0

if [ "$1" = "xvfb" ]; then
    # Start virtual display first
    Xvfb :0 -screen 0 1024x768x16 &
    sleep 3
fi

if [ "$1" = "vnc" ]; then
    # Start VNC server after Xvfb
    x11vnc -display :0 -nopw -forever -shared &
    sleep 3
fi

if [ "$1" = "novnc" ]; then
    # Start noVNC web server
    websockify --web=/usr/share/novnc/ 10000 localhost:5900 &
    sleep 2
fi

if [ "$1" = "chromium" ]; then
    # Launch Chromium only after display and VNC are ready
    chromium-browser \
        --no-sandbox \
        --disable-gpu \
        --disable-dev-shm-usage \
        --disable-software-rasterizer \
        --single-process \
        --renderer-process-limit=1 \
        --disable-extensions \
        --disable-background-networking \
        --disable-sync \
        --disable-translate \
        --disable-component-update \
        --disk-cache-size=1 \
        --media-cache-size=1 \
        --memory-pressure-off \
        --no-first-run \
        --no-default-browser-check \
        about:blank
fi
