#!/bin/bash

# ==============================================================================
#  HYPERCLEAN v3.1 - Maximum Clean (Unguarded)
#  Combines Anti-Freeze RAM Purge + Deep System/Container Cleaning
#  ⚠️ AGGRESSIVE MODE: Wipes ALL app caches (No exceptions)
# ==============================================================================

# --- CONFIGURATION ---
VERSION="3.1"

# --- COLORS & UTILS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Catch errors but don't exit
set +e

spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

bytesToHumanReadable() {
    local bytes="${1}"
    if [ "$bytes" -lt 1024 ]; then echo "${bytes}B";
    elif [ "$bytes" -lt $((1024 * 1024)) ]; then awk "BEGIN {printf \"%.2fKB\", $bytes/1024}";
    elif [ "$bytes" -lt $((1024 * 1024 * 1024)) ]; then awk "BEGIN {printf \"%.2fMB\", $bytes/1024/1024}";
    else awk "BEGIN {printf \"%.2fGB\", $bytes/1024/1024/1024}"; fi
}

get_available_space() { df -k / | awk 'NR==2 {print $4}'; }

show_header() {
    clear
    echo -e "${CYAN}"
    echo "   __  __                      ____ _                  "
    echo "  / / / /_  ______  ___  _____/ / /(_)__  ____  ____  "
    echo " / /_/ / / / / __ \/ _ \/ ___/ / // / _ \/ __ \/ __ \ "
    echo "/ __  / /_/ / /_/ /  __/ /  / /___/  __/ / / / / / / "
    echo "/_/ /_/\__, / .___/\___/_/  /_____/_/\___/_/ /_/_/ /_/  "
    echo "      /____/_/                                         "
    echo -e "${NC}"
    echo -e "${BLUE}  v${VERSION} | RAM Purge + Total Cache Wipe${NC}"
    echo "========================================================"
    echo ""
}

# --- MAIN LOGIC ---

show_header

# 1. PERMISSION CHECK
echo -e "${YELLOW}[?] Admin access is required for /var/log and RAM purge.${NC}"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

START_SPACE=$(get_available_space)

echo -e "\n${BOLD}PHASE 1: ANTI-FREEZE (RAM & APPS)${NC}"
echo "--------------------------------------------------------"

# 2. APP TERMINATION
echo -n "[-] Closing Chrome & VS Code..."
pkill "Google Chrome" > /dev/null 2>&1
pkill "Code" > /dev/null 2>&1
pkill "Electron" > /dev/null 2>&1
sleep 1
echo -e "${GREEN} Done${NC}"

# 3. RAM PURGE
echo -n "[-] Purging Inactive Memory (RAM)..."
sudo purge & spinner
echo -e "${GREEN} Done${NC}"

echo -e "\n${BOLD}PHASE 2: DEEP SYSTEM CLEANING${NC}"
echo "--------------------------------------------------------"

# 4. TOTAL CACHE CLEANING (No Guards)
echo -n "[-] Cleaning ALL User Caches (~/Library/Caches)..."
rm -rf ~/Library/Caches/* > /dev/null 2>&1 & spinner
echo -e "${GREEN} Done${NC}"

echo -n "[-] Cleaning System Caches (/Library/Caches)..."
sudo rm -rf /Library/Caches/* > /dev/null 2>&1 & spinner
echo -e "${GREEN} Done${NC}"

# 5. CONTAINER CACHES (Sandboxed Apps)
echo -n "[-] Cleaning Sandboxed App Caches (~/Library/Containers)..."
# Loops through containers and deletes their internal cache folder
for container in ~/Library/Containers/*; do
    [ -d "$container/Data/Library/Caches" ] && rm -rf "$container/Data/Library/Caches/"* 2>/dev/null
done & spinner
echo -e "${GREEN} Done${NC}"

# 6. SYSTEM LOGS & TEMP FOLDERS (Aggressive)
echo -n "[-] Cleaning System Logs (/var/log)..."
sudo rm -rf /var/log/* 2>/dev/null
rm -rf ~/Library/Logs/* 2>/dev/null
echo -e "${GREEN} Done${NC}"

echo -n "[-] Cleaning Private Temp Folders (/private/var/folders)..."
# This clears system temp files. Can fix weird OS glitches.
sudo rm -rf /private/var/folders/* 2>/dev/null & spinner
echo -e "${GREEN} Done${NC}"

# 7. DEVELOPER TOOLS
echo -n "[-] Cleaning Xcode DerivedData & Unavailable Simulators..."
rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null
xcrun simctl delete unavailable > /dev/null 2>&1
echo -e "${GREEN} Done${NC}"

# 8. LEGACY / MISC
if [ -d ~/Pictures/iPhoto\ Library/iPod\ Photo\ Cache ]; then
    echo -n "[-] Cleaning iPod Photo Cache..."
    rm -rf ~/Pictures/iPhoto\ Library/iPod\ Photo\ Cache/* 2>/dev/null
    echo -e "${GREEN} Done${NC}"
fi

# 9. TRASH
echo -n "[-] Emptying Trash..."
rm -rf ~/.Trash/* > /dev/null 2>&1
echo -e "${GREEN} Done${NC}"

# --- REPORTING ---

END_SPACE=$(get_available_space)
FREED_SPACE=$((END_SPACE - START_SPACE))
FREED_BYTES=$((FREED_SPACE * 1024))

echo -e "\n========================================================"
echo -e "   ${GREEN}✨ CLEANUP COMPLETE ✨${NC}"
echo "========================================================"
if [ "$FREED_BYTES" -gt 0 ]; then
    echo -e "   📦 Storage Recovered: ${BOLD}$(bytesToHumanReadable "$FREED_BYTES")${NC}"
else
    echo -e "   📦 Storage Recovered: ${BOLD}0B${NC} (System already clean)"
fi
echo -e "   🚀 RAM Status:       ${BOLD}Optimized & Purged${NC}"
echo "========================================================"
echo ""
