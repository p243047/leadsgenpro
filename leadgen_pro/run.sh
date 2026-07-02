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

# Install dependencies
echo -e "\n${YELLOW}Installing dependencies...${NC}"
pip install -r requirements.txt
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Install Playwright browsers
echo -e "\n${YELLOW}Installing Playwright browsers (this may take a few minutes)...${NC}"
playwright install chromium
echo -e "${GREEN}✓ Playwright browsers installed${NC}"

# Install system dependencies for Playwright (Linux only)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "\n${YELLOW}Installing system dependencies for Playwright...${NC}"
    playwright install-deps chromium || true
    echo -e "${GREEN}✓ System dependencies installed${NC}"
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
