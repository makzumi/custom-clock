#!/bin/bash

# Build script for KDE Plasmoid

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${YELLOW}Building plasmoid package...${NC}"

# Check if Python is available
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo -e "${RED}Error: Python not found!${NC}"
    exit 1
fi

# Use python3 if available, otherwise python
PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

# Check if metadata.json exists
if [ ! -f "metadata.json" ]; then
    echo -e "${RED}Error: metadata.json not found!${NC}"
    exit 1
fi

# Extract package ID and version from metadata.json
PACKAGE_ID=$(grep -oP '"Id":\s*"\K[^"]+' metadata.json)
VERSION=$(grep -oP '"Version":\s*"\K[^"]+' metadata.json)

if [ -z "$PACKAGE_ID" ]; then
    echo -e "${RED}Error: Could not extract package ID from metadata.json${NC}"
    exit 1
fi

# Create build directory
BUILD_DIR="build"
mkdir -p "$BUILD_DIR"

# Create package name
PACKAGE_NAME="${PACKAGE_ID}-v${VERSION}.plasmoid"
OUTPUT_PATH="${BUILD_DIR}/${PACKAGE_NAME}"

echo "Package ID: $PACKAGE_ID"
echo "Version: $VERSION"
echo "Output file: $OUTPUT_PATH"

# Remove old package if it exists
if [ -f "$OUTPUT_PATH" ]; then
    rm "$OUTPUT_PATH"
fi

# Create the plasmoid package using Python
echo -e "${YELLOW}Creating package...${NC}"

$PYTHON_CMD - <<EOF
import zipfile
import os
import sys

def should_exclude(filename):
    """Check if file should be excluded from package"""
    excludes = ['.git', '~', '.sh', 'readme.md', '.plasmoid']
    return any(ex in filename for ex in excludes)

def add_to_zip(zipf, path, arcname):
    """Recursively add files to zip"""
    if os.path.isfile(path):
        if not should_exclude(path):
            zipf.write(path, arcname)
    elif os.path.isdir(path):
        for item in os.listdir(path):
            item_path = os.path.join(path, item)
            item_arcname = os.path.join(arcname, item)
            add_to_zip(zipf, item_path, item_arcname)

try:
    with zipfile.ZipFile('$OUTPUT_PATH', 'w', zipfile.ZIP_DEFLATED) as zipf:
        # Add metadata.json
        zipf.write('metadata.json', 'metadata.json')
        
        # Add contents directory
        if os.path.exists('contents'):
            add_to_zip(zipf, 'contents', 'contents')
    
    print('✓ Package created successfully')
    sys.exit(0)
except Exception as e:
    print(f'✗ Error creating package: {e}', file=sys.stderr)
    sys.exit(1)
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Successfully created: $OUTPUT_PATH${NC}"
else
    echo -e "${RED}✗ Failed to create package${NC}"
    exit 1
fi
