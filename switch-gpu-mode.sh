#!/usr/bin/env bash
# GPU Mode Switcher for ROG Strix
# Easy script to switch between GPU modes

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GPU_MODE_FILE="$SCRIPT_DIR/hosts/rog-strix/gpu-mode.nix"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  ROG Strix GPU Mode Switcher${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}

print_current_mode() {
    local current_mode=$(grep 'config.hardware.gpuMode = ' "$GPU_MODE_FILE" | sed 's/.*"\(.*\)".*/\1/')
    echo -e "\n${GREEN}Current mode:${NC} ${YELLOW}$current_mode${NC}\n"
}

print_modes() {
    echo "Available modes:"
    echo ""
    echo -e "${GREEN}1)${NC} dedicated   - dGPU only (max performance, poor battery)"
    echo "                 └─ Best for: Gaming, 4K 120Hz, maximum performance"
    echo "                 └─ BIOS MUX: dGPU Mode"
    echo ""
    echo -e "${GREEN}2)${NC} hybrid      - Reverse sync (good performance, okay battery)"
    echo "                 └─ Best for: Balanced use, high refresh displays"
    echo "                 └─ BIOS MUX: Hybrid Mode"
    echo ""
    echo -e "${GREEN}3)${NC} integrated  - iGPU only (best battery, basic performance)"
    echo "                 └─ Best for: Web browsing, documents, battery life"
    echo "                 └─ BIOS MUX: Hybrid Mode"
    echo ""
}

switch_mode() {
    local new_mode=$1
    
    echo -e "${YELLOW}Switching to $new_mode mode...${NC}"
    
    # Update the gpu-mode.nix file
    sed -i "s/config.hardware.gpuMode = \".*\"/config.hardware.gpuMode = \"$new_mode\"/" "$GPU_MODE_FILE"
    
    echo -e "${GREEN}✓${NC} Configuration updated"
    echo ""
    echo -e "${YELLOW}Important:${NC}"
    
    case $new_mode in
        dedicated)
            echo "  1. Switch BIOS MUX to: ${GREEN}dGPU Mode${NC}"
            ;;
        hybrid)
            echo "  1. Switch BIOS MUX to: ${GREEN}Hybrid Mode${NC}"
            ;;
        integrated)
            echo "  1. Switch BIOS MUX to: ${GREEN}Hybrid Mode${NC}"
            echo "     (iGPU must be available)"
            ;;
    esac
    
    echo "  2. Run: ${GREEN}sudo nixos-rebuild switch --flake '.#rog-strix'${NC}"
    echo "  3. Reboot your system"
    echo ""
}

# Main script
print_header
print_current_mode

if [ $# -eq 0 ]; then
    print_modes
    echo -e "Usage: ${GREEN}$0 <mode>${NC}"
    echo "Example: $0 dedicated"
    echo "Example: $0 hybrid"
    echo "Example: $0 integrated"
    exit 0
fi

MODE=$1

case $MODE in
    dedicated|hybrid|integrated)
        switch_mode "$MODE"
        ;;
    *)
        echo -e "${RED}Error:${NC} Invalid mode '$MODE'"
        echo "Valid modes: dedicated, hybrid, integrated"
        exit 1
        ;;
esac

