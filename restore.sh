#!/bin/bash

echo "Starting RBK's Arch, Hyprland, MERN & CloudOps+DevOps Restore Script..."

# ==========================================
# 0. PRE-FLIGHT & REPOSITORY CLONE
# ==========================================
# Ensure git is installed first
sudo pacman -Syu --needed git --noconfirm

REPO_URL="https://github.com/borarohithkumar/archypr-w-configs.git"
REPO_DIR="$HOME/.mydotfiles"
BACKUP_DIR="$REPO_DIR/com.ml4w.dotfiles.stable"

if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning backup repository..."
    git clone "$REPO_URL" "$REPO_DIR"
else
    echo "Backup repository already exists at $REPO_DIR. Pulling latest changes..."
    cd "$REPO_DIR" && git pull && cd "$HOME"
fi

# ==========================================
# 1. PACKAGE INSTALLATION
# ==========================================
echo "Starting system package installation..."

# 1. Ensure system has build tools
sudo pacman -S --needed base-devel curl wget --noconfirm

# 2. Install yay (AUR Helper) if it doesn't exist
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    rm -rf /tmp/yay
fi

# 3. Core Desktop & Hyprland Ecosystem
echo "Installing Core Desktop Environment..."
yay -S --needed hyprland waybar foot rofi-wayland swaync wl-clipboard fastfetch cliphist imagemagick jq grim slurp --noconfirm
yay -S --needed hypridle hyprlock polkit-gnome --noconfirm

# 4. Wallpaper Engine (awww)
echo "Installing wallpaper engine..."
yay -S --needed awww waypaper python-imageio --noconfirm

# --- THE ARCH LINUX BUG FIX ---
# Create symlinks because Waypaper still looks for the old 'swww' command
echo "Applying awww to swww symlink patches..."
sudo ln -sf /usr/bin/awww /usr/bin/swww
sudo ln -sf /usr/bin/awww-daemon /usr/bin/swww-daemon

# 5. SDDM & Login Screen
echo "Installing SDDM and themes..."
yay -S --needed sddm sddm-theme-sugar-candy-git --noconfirm

# 6. Web Development & Shell (MERN Stack + Zsh)
echo "Installing Dev Tools..."
yay -S --needed nodejs-lts-krypton npm neovim zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions --noconfirm

# 7. CloudOps & DevOps Ecosystem
echo "Installing CloudOps & DevOps Tools..."
yay -S --needed \
    docker \
    docker-compose \
    aws-cli-v2 \
    kubectl \
    minikube \
    terraform \
    prometheus \
    grafana \
    nginx \
    certbot \
    certbot-nginx \
    --noconfirm

# Post-install: Setup Docker permissions & enable services
sudo systemctl enable docker.service
sudo systemctl enable nginx.service
sudo usermod -aG docker $USER

# 8. Media & Utilities
echo "Installing Media and Utils..."
yay -S --needed mpv transmission-cli tremc ffmpeg github-cli --noconfirm

# Enable SDDM service to start on boot
sudo systemctl enable sddm.service

echo "✅ Package installation complete!"
echo "Proceeding to configuration restore..."

# ==========================================
# 2. HOME DIRECTORY FILES
# ==========================================
echo "Restoring .zshrc and .bash_profile..."

# -s makes it a symlink, -f forces it to overwrite existing default files
ln -sf "$BACKUP_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$BACKUP_DIR/.bash_profile" "$HOME/.bash_profile"
ln -sfn "$BACKUP_DIR/ai_tool" "$HOME/ai_tool"
ln -sfn "$BACKUP_DIR/tg_tool" "$HOME/tg_tool"

# CloudOps Project Folders
echo "Restoring CloudOps & DevOps project folders..."
CLOUDOPS_DIR="$BACKUP_DIR/CloudOps+DevOps"
mkdir -p "$CLOUDOPS_DIR" # Ensure it exists so symlinks don't break if repo is empty

ln -sfn "$CLOUDOPS_DIR/termind-api-infra" "$HOME/termind-api-infra"
ln -sfn "$CLOUDOPS_DIR/observability" "$HOME/observability"
ln -sfn "$CLOUDOPS_DIR/kubernetes" "$HOME/kubernetes"

# ==========================================
# 3. SECRETS & SSH VAULT
# ==========================================
SECRETS_DIR="$HOME/.mysecrets"

if [ -d "$SECRETS_DIR/.ssh" ]; then
    echo "Restoring SSH configuration from private vault..."
    cp -r "$SECRETS_DIR/.ssh" "$HOME/"
    chmod 700 "$HOME/.ssh"
    find "$HOME/.ssh" -type f -exec chmod 600 {} \;
    echo "SSH permissions secured."
else
    echo "No private .ssh vault found in ~/.mysecrets, skipping."
fi

if [ -f "$SECRETS_DIR/.ai_secrets" ]; then
    echo "Restoring AI API secrets..."
    cp "$SECRETS_DIR/.ai_secrets" "$HOME/.ai_secrets"
fi

if [ -f "$SECRETS_DIR/.tg_secrets" ]; then
    echo "Restoring Telegram API secrets..."
    cp "$SECRETS_DIR/.tg_secrets" "$HOME/.tg_secrets"
fi

# ==========================================
# 4. .CONFIG DIRECTORY SYMLINKS
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
# 5. VS CODE CONFIGURATION
# ==========================================
echo "Restoring VS Code settings..."

# Ensure the exact VS Code User directory exists on the new machine
mkdir -p "$HOME/.config/Code/User"

# Symlink settings and keybindings if they exist in the backup
if [ -f "$BACKUP_DIR/.config/Code/User/settings.json" ]; then
    ln -sf "$BACKUP_DIR/.config/Code/User/settings.json" "$HOME/.config/Code/User/settings.json"
fi

if [ -f "$BACKUP_DIR/.config/Code/User/keybindings.json" ]; then
    ln -sf "$BACKUP_DIR/.config/Code/User/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
fi


# ==========================================
# 6. SYSTEM FILES (REQUIRES SUDO)
# ==========================================
echo "Restoring system files (TLP & SDDM)... You will be prompted for your password."

# TLP Power Management
if [ -f "$BACKUP_DIR/tlp.conf" ]; then
    echo "Copying TLP config (avoiding symlink race conditions)..."

	# Use cp instead of ln to put a physical file on the root partition
    sudo cp "$BACKUP_DIR/tlp.conf" /etc/tlp.conf

	# Automatically uncomment the enable flag
    sudo sed -i 's/^#TLP_ENABLE=1/TLP_ENABLE=1/' /etc/tlp.conf

	# Ensure the systemd radio override is masked
    sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

	# Enable the service to start on boot
    sudo systemctl enable tlp.service
fi

# SDDM Login Screen & Sugar-Candy Theme
if [ -d "$BACKUP_DIR/sddm-backup" ]; then
    echo "Restoring SDDM & Sugar-Candy theme files..."
    
	# Restore main SDDM config
    if [ -f "$BACKUP_DIR/sddm-backup/sddm.conf" ]; then
        sudo cp "$BACKUP_DIR/sddm-backup/sddm.conf" /etc/sddm.conf
    fi
    
    # Restore Sugar-Candy theme configurations
	if [ -f "$BACKUP_DIR/sddm-backup/theme.conf" ]; then
        sudo cp "$BACKUP_DIR/sddm-backup/theme.conf" /usr/share/sddm/themes/sugar-candy/theme.conf
    fi
    
	# Restore custom background images (copies any jpg or png in the backup folder)
    sudo cp "$BACKUP_DIR/sddm-backup/"*.jpg /usr/share/sddm/themes/sugar-candy/ 2>/dev/null
    sudo cp "$BACKUP_DIR/sddm-backup/"*.png /usr/share/sddm/themes/sugar-candy/ 2>/dev/null
fi

# SSH Daemon Config
if [ -f "$SECRETS_DIR/sshd_config" ]; then
    echo "Restoring SSH Daemon configuration..."
    sudo cp "$SECRETS_DIR/sshd_config" /etc/ssh/sshd_config
    sudo chmod 644 /etc/ssh/sshd_config
    sudo systemctl enable sshd.service
fi

echo "=========================================="
echo "Restore Script Complete! Your environment is ready."
echo "Note: You will need to log out and log back or reboot the system for everything to take effect."
echo "=========================================="
