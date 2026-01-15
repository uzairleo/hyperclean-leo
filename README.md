# 🚀 HyperClean (Leo Edition)

**The Ultimate macOS Maintenance Script for Developers.**
*Authored by Uzair Leo*

Is your Mac freezing? Is VS Code taking up 10GB of RAM? HyperClean is a bash script designed to aggressively clean system caches, purge inactive RAM, and fix the "Out of Memory" freeze on M1/M2/M3 Macs.

**✅ What it does:**
- **Purges RAM:** Instantly releases inactive memory (sudo purge).
- **Fixes VS Code Lag:** Kills memory leaks and wipes Code caches.
- **Deep Clean:** Cleans System Caches, Logs, and Xcode DerivedData.
- **Sandboxed Apps:** Cleans containers for App Store apps.

## 🚀 How to Use

### 1. Clone the Repository
Since this is a private tool, clone it using SSH:

```bash
git clone git@github.com:uzairleo/hyperclean-leo.git
cd hyperclean-leo
```

### 2. Run the Cleaner
Once inside the folder, simply run:
```bash
./hyperclean-leo run
```
That's it! The script will handle permissions, ask for your sudo password, and start the cleaning engine.

### 🌍 Optional: Install Globally  
Want to use this command from any folder without navigating here? Run this once:
```bash
./hyperclean-leo install
```
Now you can simply type `hyperclean-leo run` from anywhere in your terminal!

⚡️ What It Does

| Feature        | Description |
| -------------- | ----------- |
| ❄️ Anti-Freeze | Kills memory leaks in Chrome/VS Code & runs `sudo purge` to free RAM. |
| 🧹 Deep Clean  | Wipes System Caches, Log files, and temporary swap files. |
| 📦 Dev Tools   | Cleans Xcode DerivedData, Old Simulators, and Homebrew Caches. |
| 🛡 Safe Mode   | Intelligently handles system files to prevent OS corruption. |

⚠️ Requirements
- macOS (Optimized for Apple Silicon & Intel)
- SSH Key configured with GitHub (required to clone this private repo).
- Sudo Access (Required to purge RAM).

© 2025 Uzair Leo. All Rights Reserved.
