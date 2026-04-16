#!/bin/bash

# 1. Check if the process is running (case-insensitive)
if ! pgrep -ix "legcord" > /dev/null; then
    echo "{\"text\": \"\", \"tooltip\": \"Discord is closed\", \"class\": \"stopped\"}"
    exit 0
fi

# 2. Get the window title
# We select the class 'legcord', but crucially, we filter out empty titles
# and take the top one.
STATUS=$(hyprctl clients -j | jq -r '.[] | select(.class == "legcord" and .title != "") | .title' | head -n 1)

# 3. Logic for VC and Activity
if [[ -z "$STATUS" || "$STATUS" == "legcord" || "$STATUS" == "Discord" ]]; then
    INFO="Online"
    CLASS="online"
# Legcord often shows "Voice" or "RTC" in the title when in a call
elif [[ "$STATUS" == *"Voice"* || "$STATUS" == *"RTC"* || "$STATUS" == *"Connected"* ]]; then
    INFO="In Voice Channel"
    CLASS="vc"
else
    # Removes "Discord | " or "Legcord | " prefixes if they exist
    CLEAN_STATUS=$(echo "$STATUS" | sed -E 's/^(Discord |Legcord |#)//g')
    INFO="$CLEAN_STATUS"
    CLASS="active"
fi

echo "{\"text\": \"\", \"tooltip\": \"$INFO\", \"class\": \"$CLASS\"}"