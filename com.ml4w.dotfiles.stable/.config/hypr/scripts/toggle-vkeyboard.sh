#!/bin/bash
# Check if keyboard is running
if pgrep -x "wvkbd-mobintl" > /dev/null; then
    # If running, kill it
    pkill wvkbd-mobintl
else
    # If not running, start it
    # -L 300 = Height 300px (Good for 1280p screen)
    # --landscape-layers = Better layout for landscape
    wvkbd-mobintl -L 300 --landscape-layers landscape,special &
fi
