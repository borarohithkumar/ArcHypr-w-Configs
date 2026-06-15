#!/bin/bash

REC_DIR="$HOME/Videos"
mkdir -p "$REC_DIR"
PID_FILE="/tmp/gpu_screen_record.pid"

if [ -f "$PID_FILE" ]; then
    # If the PID file exists, kill that exact process and delete the file
    kill -INT $(cat "$PID_FILE") 2>/dev/null
    rm -f "$PID_FILE"
    notify-send -u normal "Recording Stopped" "Saved to $REC_DIR"
else
    # Otherwise, generate filename and start recording
    FILENAME="$REC_DIR/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
    AUDIO_SINK="$(pactl get-default-sink).monitor"

    notify-send -u normal "Recording Started" "Audio: System | Encoder: GPU Hardware"
    
    gpu-screen-recorder \
        -w screen \
        -f 60 \
        -a "$AUDIO_SINK" \
        -q ultra \
        -o "$FILENAME" &
        
    # Save the exact Process ID of the recorder we just launched
    echo $! > "$PID_FILE"
fi

    # Start recording
    # -f: Output file
    # -c: Video Codec (libx264 - CPU based)
    # -C: Audio Codec (AAC)
    # -a: Audio Source (Your specific monitor device)
    # -x: Pixel Format (yuv420p for max compatibility)
    # -p crf=20: High quality, decent size
    # -p preset=veryfast: The best balance for live recording on mobile CPUs
    
#    wf-recorder \
#        -f "$FILENAME" \
#        -c libx264 \
#        -C aac \
#        -a alsa_output.pci-0000_00_1f.3.analog-stereo.monitor \
#        -x yuv420p \
#        -p crf=0 \
#        -p preset=medium &

