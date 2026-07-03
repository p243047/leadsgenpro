#!/bin/bash
# LeadGen Pro - Setup and Launch Script
# ======================================
# This script sets up the virtual environment, installs dependencies,
# installs Playwright browsers, and launches the application.

set -e  # Exit on error

echo "=========================================="
echo "🚀 LeadGen Pro - Setup & Launch"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Python version
echo -e "\n${YELLOW}Checking Python version...${NC}"
python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
echo "Python version: $python_version"

# Warn if using Python 3.13 (greenlet compatibility issue)
if [[ "$python_version" == 3.13* ]]; then
    echo -e "${RED}⚠ WARNING: Python 3.13 detected!${NC}"
    echo "Some dependencies (greenlet) may not be fully compatible with Python 3.13 yet."
    echo "For best results, use Python 3.10, 3.11, or 3.12."
    echo ""
    read -p "Continue anyway? (y/n): " choice
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        echo "Installation cancelled. Please install Python 3.10-3.12 and try again."
        exit 1
    fi
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo -e "\n${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv venv
    echo -e "${GREEN}✓ Virtual environment created${NC}"
else
    echo -e "${GREEN}✓ Virtual environment already exists${NC}"
fi

# Activate virtual environment
echo -e "\n${YELLOW}Activating virtual environment...${NC}"
source venv/bin/activate

# Upgrade pip
echo -e "\n${YELLOW}Upgrading pip...${NC}"
pip install --upgrade pip

# Install dependencies (excluding greenlet explicitly)
echo -e "\n${YELLOW}Installing dependencies...${NC}"
# First install all other dependencies
pip install aiohttp dnspython customtkinter pandas openpyxl python-dateutil playwright
echo -e "${GREEN}✓ Core dependencies installed${NC}"

# Install Playwright browsers (with graceful fallback for limited disk space)
echo -e "\n${YELLOW}Installing Playwright browsers...${NC}"
echo "Note: If installation fails due to disk space, the app will use system browsers."

# Set custom browser path to /tmp if available
export PLAYWRIGHT_BROWSERS_PATH=/tmp/playwright_browsers

if playwright install chromium 2>/dev/null; then
    echo -e "${GREEN}✓ Playwright Chromium browser installed${NC}"
else
    echo -e "${YELLOW}⚠ Warning: Could not install Chromium browser${NC}"
    echo "The application will attempt to use available system browsers."
    echo "For best results, ensure Chrome/Chromium is installed on your system."
fi

# Try to install system dependencies for Playwright (Linux only)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "\n${YELLOW}Installing system dependencies for Playwright (if permissions allow)...${NC}"
    if command -v sudo &> /dev/null; then
        sudo playwright install-deps chromium 2>/dev/null || true
    else
        playwright install-deps chromium 2>/dev/null || true
    fi
    echo -e "${GREEN}✓ System dependencies handled${NC}"
fi

# Create output directory
if [ ! -d "output" ]; then
    mkdir -p output
    echo -e "${GREEN}✓ Output directory created${NC}"
fi

# Launch application
echo -e "\n${GREEN}=========================================="
echo "🎉 Setup Complete! Launching LeadGen Pro..."
echo "==========================================${NC}\n"

python main.py
