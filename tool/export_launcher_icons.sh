#!/usr/bin/env bash
# Export the square master without baking a launcher-specific mask into it.
set -euo pipefail

task_root="$(cd "$(dirname "$0")/.." && pwd)"
task_master="$task_root/assets/branding/khelbhai_launcher_master.png"
task_android="$task_root/android/app/src/main/res"
task_ios="$task_root/ios/Runner/Assets.xcassets/AppIcon.appiconset"

command -v sips >/dev/null || { echo 'This export uses macOS sips.' >&2; exit 1; }

for task_spec in mdpi:48:108 hdpi:72:162 xhdpi:96:216 xxhdpi:144:324 xxxhdpi:192:432; do
  IFS=: read -r task_density task_icon_size task_foreground_size <<< "$task_spec"
  task_dir="$task_android/mipmap-$task_density"
  mkdir -p "$task_dir"
  sips -s format png --resampleHeightWidth "$task_icon_size" "$task_icon_size" \
    "$task_master" --out "$task_dir/ic_launcher.png" >/dev/null
  cp "$task_dir/ic_launcher.png" "$task_dir/ic_launcher_round.png"
  sips -s format png --resampleHeightWidth "$task_foreground_size" "$task_foreground_size" \
    "$task_master" --out "$task_dir/ic_launcher_foreground.png" >/dev/null
done

while IFS=$'\t' read -r task_name task_size; do
  sips -s format png --resampleHeightWidth "$task_size" "$task_size" \
    "$task_master" --out "$task_ios/$task_name" >/dev/null
done < <(python3 - "$task_ios/Contents.json" <<'PY'
import json, sys
from decimal import Decimal
for item in json.load(open(sys.argv[1]))['images']:
    if 'filename' not in item:
        continue
    size = int(Decimal(item['size'].split('x')[0]) * Decimal(item['scale'].rstrip('x')))
    print(f"{item['filename']}\t{size}")
PY
)

echo 'Exported Android launcher densities and iOS AppIcon sizes.'
