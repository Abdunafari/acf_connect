#!/bin/bash
echo "🔧 Fixing corrupted NDK installation..."

# Define paths
SDK_ROOT="$HOME/Android/Sdk"
BROKEN_NDK="$SDK_ROOT/ndk/28.2.13676358"
STABLE_NDK="ndk;27.0.12077973"

# Remove broken NDK
if [ -d "$BROKEN_NDK" ]; then
  echo "🗑️  Removing corrupted NDK: $BROKEN_NDK"
  rm -rf "$BROKEN_NDK"
fi

# Install stable NDK via sdkmanager
CMDLINE_TOOLS="$SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"
if [ -f "$CMDLINE_TOOLS" ]; then
  echo "📦 Installing stable NDK r27..."
  "$CMDLINE_TOOLS" "$STABLE_NDK" --sdk_root="$SDK_ROOT"
else
  echo "⚠️  sdkmanager not found. Please install Android CLI tools first:"
  echo "   https://developer.android.com/studio#command-tools"
  exit 1
fi

# Verify
NEW_NDK_PATH="$SDK_ROOT/ndk/27.0.12077973"
if [ -f "$NEW_NDK_PATH/source.properties" ]; then
  echo "✅ NDK installed successfully!"
  echo "📋 Version info:"
  cat "$NEW_NDK_PATH/source.properties"
else
  echo "❌ NDK installation failed. Check sdkmanager output above."
  exit 1
fi

echo -e "\n🎉 Done! Now run: cd android && ./gradlew signingReport"
