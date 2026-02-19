#!/bin/bash

# Define filename with timestamp
FILENAME="$HOME/Videos/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"

# Check if recording is running
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -INT wf-recorder
    notify-send "Recording Stopped" "Saved to $FILENAME"
else
    notify-send "Recording Started" "Audio: System Output Only"
    
    # Start recording
    # -f: Output file
    # -c: Video Codec (libx264 - CPU based)
    # -C: Audio Codec (AAC)
    # -a: Audio Source (Your specific monitor device)
    # -x: Pixel Format (yuv420p for max compatibility)
    # -p crf=20: High quality, decent size
    # -p preset=veryfast: The best balance for live recording on mobile CPUs
    
    wf-recorder \
        -f "$FILENAME" \
        -c libx264 \
        -C aac \
        -a alsa_output.pci-0000_00_1f.3.analog-stereo.monitor \
        -x yuv420p \
        -p crf=0 \
        -p preset=medium &
fi
