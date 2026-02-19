#!/usr/bin/env bash

# --- TUNING SECTION ---
# Top/Bottom Margin (Vertical Squeeze)
# 200 = Standard
#tb_margin=200

# Left/Right Margin (Horizontal Squeeze)
# If it's cropped on the right, INCREASE this number (e.g., try 400 or 500)
#lr_margin=100
# ----------------------

#wlogout --protocol layer-shell -b 5 -T $tb_margin -B $tb_margin -L $lr_margin -R $lr_margin

# 1. Get current resolution and scaling
# We use 'focused==true' so it grabs whatever rotation you are currently in.
res_w=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
res_h=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale')

# 2. Calculate logical size (Resolution / Scale)
# We use awk because bash can't do decimals
width=$(awk "BEGIN {print $res_w / $scale}")
height=$(awk "BEGIN {print $res_h / $scale}")

# 3. Set Margins to 15% of the screen size
# This ensures it looks good whether wide or tall
x_margin=$(awk "BEGIN {printf \"%.0f\", $width * 0.08}")
y_margin=$(awk "BEGIN {printf \"%.0f\", $height * 0.2}")

# 4. Launch
wlogout --protocol layer-shell -b 5 -T $y_margin -B $y_margin -L $x_margin -R $x_margin
