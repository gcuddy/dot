#!/bin/bash
# Apply theme by processing templates with color values
# Usage: apply-theme.sh <colors-file>

set -e

COLORS_FILE="$1"
TEMPLATES_DIR="$HOME/.config/themes/templates"
OUTPUT_DIR="$HOME/.config/themes/current"

if [[ ! -f "$COLORS_FILE" ]]; then
    echo "Error: Colors file not found: $COLORS_FILE" >&2
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Build sed script from colors file
sed_script=$(mktemp)

# Parse TOML: convert 'key = "value"' to sed substitutions
while IFS='=' read -r key value; do
    # Skip empty lines and comments
    [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue

    # Trim whitespace
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs | tr -d '"')

    # Skip if key or value is empty
    [[ -z "$key" || -z "$value" ]] && continue

    # Add sed substitution
    echo "s|{{ ${key} }}|${value}|g" >> "$sed_script"
done < "$COLORS_FILE"

# Process each template
for tpl in "$TEMPLATES_DIR"/*.tpl; do
    [[ -f "$tpl" ]] || continue

    filename=$(basename "$tpl" .tpl)
    output_path="$OUTPUT_DIR/$filename"

    sed -f "$sed_script" "$tpl" > "$output_path"
    echo "Generated: $filename"
done

rm "$sed_script"

# Store current theme info
cp "$COLORS_FILE" "$OUTPUT_DIR/colors.toml"
grep -E "^name\s*=" "$COLORS_FILE" | head -1 | sed 's/.*=\s*"\(.*\)"/\1/' > "$OUTPUT_DIR/theme.name"
grep -E "^appearance\s*=" "$COLORS_FILE" | head -1 | sed 's/.*=\s*"\(.*\)"/\1/' > "$OUTPUT_DIR/theme.appearance"

echo "Theme applied successfully"
