#!/usr/bin/env bash
set -e

ENV_TARGET="${1:-dev}"
BANNER_FLAG="${2:-true}"

VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}')
BUILD_NAME=$(echo "$VERSION" | cut -d+ -f1)
BUILD_NUMBER=$(echo "$VERSION" | cut -d+ -f2)

ENV_FILE=".env.${ENV_TARGET}"
if [ ! -f "$ENV_FILE" ]; then
  ENV_FILE=".env"
fi

echo "🚀 Building KhelBhai APK for [$ENV_TARGET] (version: $VERSION, banner: $BANNER_FLAG)..."

fvm flutter clean
fvm flutter pub get

fvm flutter build apk \
  --dart-define-from-file="$ENV_FILE" \
  --dart-define=SHOW_BANNER="$BANNER_FLAG" \
  --build-name="$BUILD_NAME" \
  --build-number="$BUILD_NUMBER"

OUTPUT_NAME="khelbhai-${ENV_TARGET}"
if [ "$BANNER_FLAG" = "true" ]; then
  OUTPUT_NAME="${OUTPUT_NAME}-banner"
fi
OUTPUT_NAME="${OUTPUT_NAME}-${VERSION}.apk"

mkdir -p build/app/outputs/flutter-apk

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
  cp build/app/outputs/flutter-apk/app-release.apk "build/app/outputs/flutter-apk/${OUTPUT_NAME}"
elif [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
  cp build/app/outputs/flutter-apk/app-debug.apk "build/app/outputs/flutter-apk/${OUTPUT_NAME}"
fi

echo "✅ Built: build/app/outputs/flutter-apk/${OUTPUT_NAME}"
