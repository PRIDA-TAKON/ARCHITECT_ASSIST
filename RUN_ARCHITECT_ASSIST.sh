#!/bin/bash
clear
echo "=========================================="
echo "   🏛️ ARCHITECT_ASSIST: Checking for Updates"
echo "=========================================="

# Get the directory where the script is located
cd "$(dirname "$0")"

# Check if it's a git repo
if [ -d ".git" ]; then
    echo "Checking for new features from GitHub..."
    git pull origin main
else
    echo "[Notice] Not a git repository. Skipping auto-update."
fi

echo ""
echo "Installing/Updating requirements..."
pip install -r requirements.txt --quiet

echo ""
echo "Starting ARCHITECT_ASSIST..."
streamlit run src/app.py
