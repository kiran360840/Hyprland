#!/bin/bash

# Check if spotify is running at all
if ! pgrep -x "spotify" >/dev/null; then
    echo "{\"text\": \"\", \"tooltip\": \"Spotify is closed\", \"class\": \"stopped\"}"
    exit 0
fi
# If it is running, get the status
status=$(playerctl -p spotify status 2>/dev/null)
if [ "$status" = "Playing" ]; then
    title=$(playerctl -p spotify metadata title 2>/dev/null)
    artist=$(playerctl -p spotify metadata artist 2>/dev/null)
    echo "{\"text\": \"\", \"tooltip\": \"$title - $artist\", \"class\": \"playing\"}"
elif [ "$status" = "Paused" ]; then
    echo "{\"text\": \"\", \"tooltip\": \"Paused\", \"class\": \"paused\"}"
else
    # Fallback for stopped/idle status
    echo "{\"text\": \"\", \"tooltip\": \"Stopped\", \"class\": \"stopped\"}"
fi
