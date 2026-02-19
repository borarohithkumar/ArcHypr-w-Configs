# ⚡ Arch Linux & Hyprland Dotfiles

![Arch Linux](https://img.shields.io/badge/OS-Arch_Linux-33C1D6?style=for-the-badge&logo=arch-linux&logoColor=white)
![WM](https://img.shields.io/badge/WM-Hyprland-00a6c7?style=for-the-badge)
![Shell](https://img.shields.io/badge/Shell-Zsh-black?style=for-the-badge&logo=zsh)
![Editor](https://img.shields.io/badge/Editor-Neovim-57A143?style=for-the-badge&logo=neovim)

> *A minimal, lightning-fast, and heavily customized Arch Linux environment tailored for Full-Stack Web Development.*

<div align="center">
  <img src="https://via.placeholder.com/800x450.png?text=Screenshot+Coming+Soon" alt="Desktop Screenshot">
</div>

## 🚀 Overview
Welcome to my personal dotfiles. This repository holds the exact blueprints for my daily-driver Linux environment. Built on top of **Arch Linux** and the **Hyprland** compositor, this setup is designed to be completely keyboard-driven, visually clean, and highly optimized for building web applications.

## ✨ Core Tech Stack
* **Compositor:** [Hyprland](https://hyprland.org/) (Fluid, dynamic tiling on Wayland)
* **Terminal:** Foot (Ultra-lightweight and fast)
* **Shell:** Zsh (Agnoster theme + auto-suggestions)
* **Status Bar:** Waybar 
* **Editor:** Neovim
* **Dev Environment:** Native optimizations for Node.js, the MERN stack, and custom AI CLI tools.

## 📂 Repository Architecture
This repository utilizes a surgical symlinking strategy. Instead of cluttering version control with bloated cache files, only vital application configurations are tracked. 

All sensitive data (SSH keys, API tokens) is strictly omitted from this public repository and managed locally via a `.zsh_secrets` vault, ensuring total security without compromising portability.

## 🛠️ 1-Click Disaster Recovery
I engineered a custom `restore.sh` script to automate system installation and configuration. On a fresh Arch Linux system, my entire environment rebuilds itself automatically.

**The Recovery Sequence:**
```bash
# 1. Clone the repository
gh repo clone borarohithkumar/ArcHypr-w-Configs ~/.mydotfiles

# 2. Make the script executable
chmod +x ~/.mydotfiles/restore.sh

# 3. Execute the automated installer and symlinker
~/.mydotfiles/restore.sh

🤝 Acknowledgments
Built upon the foundational scripts from ML4W.
