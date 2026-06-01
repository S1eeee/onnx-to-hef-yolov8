#!/bin/bash

# This will isolate up to 64 images in a new folder above its current working directory, which it will name calibration_imgs, ready to move to the root of this repo after building the docker image
# 
# Usage:
# 
# Place this script directly in the directory with your calibration images. Then run it as such: 
#
# chmod +x calibration-gathering.sh 
# ./calibration-gathering.sh
# 
# Requires a minimum of 100 images to run.
#
# Can handle thousands of images

IMAGES=$(find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" \))
IMAGE_COUNT=$(echo "$IMAGES" | wc -l)

if [ "$IMAGE_COUNT" -lt 100 ]; then
    echo "Error: Found only $IMAGE_COUNT images. Minimum 100 required."
    exit 1
fi

read -p "Enter number of images to sample (1-64): " X

if [[ ! "$X" =~ ^[0-9]+$ ]] || [ "$X" -lt 1 ] || [ "$X" -gt 64 ]; then
    echo "Error: Invalid input '$X'. Please enter a whole number between 1 and 64."
    exit 1
fi

echo "Selecting $X representative images from a pool of $IMAGE_COUNT..."

TARGET_DIR="../calibration_imgs"
mkdir -p "$TARGET_DIR"

# We shuffle the entire list once and take the first X items
# This ensures a uniform distribution across the entire dataset
echo "$IMAGES" | shuf -n "$X" | while read -r FILE; do
    cp "$FILE" "$TARGET_DIR/"
done

echo "------------------------------------------------"
echo "Success! $X images have been copied to: $TARGET_DIR"