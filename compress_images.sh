#!/bin/bash
# compress_images.sh: Compress images in content/ and backup originals
#
# Requirements (Ubuntu):
#   sudo apt-get install jpegoptim optipng imagemagick

# Don't exit on error; handle errors manually
# set -e

CONTENT_DIR="content"
BACKUP_DIR="$CONTENT_DIR/.original_images"
MAX_WIDTH=1920

# Calculate total size before compression
SIZE_BEFORE=$(find "$CONTENT_DIR" \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.JPG' -o -iname '*.JPEG' -o -iname '*.PNG' \) -type f -exec du -cb {} + | awk '/total$/ {print $1}')

# Create backup directory, remove old backups
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Find all jpg/jpeg/png images (case-insensitive) and copy to backup
find "$CONTENT_DIR" \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.JPG' -o -iname '*.JPEG' -o -iname '*.PNG' \) -type f | while read -r img; do
  relpath="${img#$CONTENT_DIR/}"
  backup_path="$BACKUP_DIR/$relpath"
  mkdir -p "$(dirname "$backup_path")"
  cp "$img" "$backup_path"
done

# Resize images wider than MAX_WIDTH using imagemagick (convert)
find "$CONTENT_DIR" \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.JPG' -o -iname '*.JPEG' -o -iname '*.PNG' \) -type f | while read -r img; do
  width=$(identify -format "%w" "$img" 2>/dev/null)
  if [ -n "$width" ] && [ "$width" -gt "$MAX_WIDTH" ]; then
    convert "$img" -resize "$MAX_WIDTH" "$img" || echo "resize failed for $img"
  fi
done

# Compress JPEGs (case-insensitive)
find "$CONTENT_DIR" \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.JPG' -o -iname '*.JPEG' \) -type f | while read -r img; do
  jpegoptim --max=85 --strip-all "$img" || echo "jpegoptim failed for $img"
done

# Compress PNGs (case-insensitive)
find "$CONTENT_DIR" \( -iname '*.png' -o -iname '*.PNG' \) -type f | while read -r img; do
  optipng -o2 "$img" || echo "optipng failed for $img"
done

# Calculate total size after compression
SIZE_AFTER=$(find "$CONTENT_DIR" \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.JPG' -o -iname '*.JPEG' -o -iname '*.PNG' \) -type f -exec du -cb {} + | awk '/total$/ {print $1}')

# Calculate percentage saved and convert to MB
if [ "$SIZE_BEFORE" -gt 0 ]; then
  SAVED=$((SIZE_BEFORE - SIZE_AFTER))
  PERCENT=$(awk "BEGIN {printf \"%.2f\", ($SAVED/$SIZE_BEFORE)*100}")
  SIZE_BEFORE_MB=$(awk "BEGIN {printf \"%.2f\", $SIZE_BEFORE/1048576}")
  SIZE_AFTER_MB=$(awk "BEGIN {printf \"%.2f\", $SIZE_AFTER/1048576}")
  SAVED_MB=$(awk "BEGIN {printf \"%.2f\", $SAVED/1048576}")
else
  SAVED=0
  PERCENT=0
  SIZE_BEFORE_MB=0
  SIZE_AFTER_MB=0
  SAVED_MB=0
fi

echo "Image compression complete. Originals backed up in $BACKUP_DIR."
echo "Size before: $SIZE_BEFORE_MB MB"
echo "Size after:  $SIZE_AFTER_MB MB"
echo "Saved:       $SAVED_MB MB ($PERCENT%)"
