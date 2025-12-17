# 🚀 HyperClean (Leo Edition)

**The Ultimate macOS Maintenance Script for Developers.**
*Authored by Uzair Leo*

Is your Mac freezing? Is VS Code taking up 10GB of RAM? HyperClean is a bash script designed to aggressively clean system caches, purge inactive RAM, and fix the "Out of Memory" freeze on M1/M2/M3 Macs.

**✅ What it does:**
- **Purges RAM:** Instantly releases inactive memory (sudo purge).
- **Fixes VS Code Lag:** Kills memory leaks and wipes Code caches.
- **Deep Clean:** Cleans System Caches, Logs, and Xcode DerivedData.
- **Sandboxed Apps:** Cleans containers for App Store apps.

## ⚡️ Quick Start (One-Line Command)
Open your Terminal and paste this command to run it instantly:

```bash
/bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/uzairleo/HyperClean-UzairLeo/main/hyperclean.sh](https://raw.githubusercontent.com/uzairleo/HyperClean-UzairLeo/main/hyperclean.sh))"
