#!/bin/bash

echo "Starting RBK's Arch & Hyprland Restore Script..."

# Define the exact path to our backup folder
BACKUP_DIR="$HOME/.mydotfiles/com.ml4w.dotfiles.stable"

# ==========================================
# 1. HOME DIRECTORY FILES
# ==========================================
echo "Restoring .zshrc and .bash_profile..."

# -s makes it a symlink, -f forces it to overwrite existing default files
ln -sf "$BACKUP_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$BACKUP_DIR/.bash_profile" "$HOME/.bash_profile"
ln -sfn "$BACKUP_DIR/ai_tool" "$HOME/ai_tool"

# ==========================================
# 2. SSH DIRECTORY
# ==========================================
# We check if the backed-up SSH folder exists before trying to copy it
if [ -d "$BACKUP_DIR/.ssh" ]; then
    echo "Restoring SSH configuration..."
    
    # Copy the folder back to the home directory
    cp -r "$BACKUP_DIR/.ssh" "$HOME/"
    
    # Strictly lock down permissions so SSH doesn't block the keys
    chmod 700 "$HOME/.ssh"
    find "$HOME/.ssh" -type f -exec chmod 600 {} \;
    echo "SSH permissions secured."
else
    echo "No .ssh backup found, skipping."
fi

echo "Part 1 complete!"

# ==========================================
# 3. .CONFIG DIRECTORY SYMLINKS
# ==========================================
echo "Restoring ~/.config symlinks..."

# Ensure the main ~/.config directory exists
mkdir -p "$HOME/.config"

# Loop through every single file and folder in our backup .config
for config_item in "$BACKUP_DIR/.config/"*; do
    # Get just the name of the folder/file (e.g., 'waybar', 'mpv', 'mimeapps.list')
    item_name=$(basename "$config_item")
    
    # Skip the 'Code' folder because we handle it carefully below
    if [ "$item_name" = "Code" ]; then
        continue
    fi
    
    # Create the symlink (force overwrite if a default folder already exists)
    ln -sfn "$config_item" "$HOME/.config/$item_name"
done

echo "Main .config apps successfully linked!"

# ==========================================
# 4. VS CODE CONFIGURATION
# ==========================================
echo "Restoring VS Code settings for MERN stack..."

# Ensure the exact VS Code User directory exists on the new machine
mkdir -p "$HOME/.config/Code/User"

# Symlink settings and keybindings if they exist in the backup
if [ -f "$BACKUP_DIR/.config/Code/User/settings.json" ]; then
    ln -sf "$BACKUP_DIR/.config/Code/User/settings.json" "$HOME/.config/Code/User/settings.json"
fi

if [ -f "$BACKUP_DIR/.config/Code/User/keybindings.json" ]; then
    ln -sf "$BACKUP_DIR/.config/Code/User/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
fi

echo "Part 2 complete!"

# ==========================================
# 5. SYSTEM FILES (REQUIRES SUDO)
# ==========================================
echo "Restoring system files (TLP & SDDM)... You will be prompted for your password."

# TLP Power Management
if [ -f "$BACKUP_DIR/tlp.conf" ]; then
    echo "Linking TLP config..."
    sudo ln -sf "$BACKUP_DIR/tlp.conf" /etc/tlp.conf
fi

# SDDM Login Screen & Sugar-Candy Theme
if [ -d "$BACKUP_DIR/sddm-backup" ]; then
    echo "Restoring SDDM & Sugar-Candy theme files..."
    
    # 1. Restore main SDDM config
    if [ -f "$BACKUP_DIR/sddm-backup/sddm.conf" ]; then
        sudo cp "$BACKUP_DIR/sddm-backup/sddm.conf" /etc/sddm.conf
    fi
    
    # 2. Restore Sugar-Candy theme configurations
    if [ -f "$BACKUP_DIR/sddm-backup/theme.conf" ]; then
        sudo cp "$BACKUP_DIR/sddm-backup/theme.conf" /usr/share/sddm/themes/sugar-candy/theme.conf
    fi
    
    # 3. Restore custom background images (copies any jpg or png in the backup folder)
    sudo cp "$BACKUP_DIR/sddm-backup/"*.jpg /usr/share/sddm/themes/sugar-candy/ 2>/dev/null
    sudo cp "$BACKUP_DIR/sddm-backup/"*.png /usr/share/sddm/themes/sugar-candy/ 2>/dev/null
fi

echo "=========================================="
echo "Restore Script Complete! Your environment is ready."
echo "=========================================="
