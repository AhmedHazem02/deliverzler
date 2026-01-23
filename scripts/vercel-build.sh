#!/bin/bash

# Exit on error
set -e

echo "--- Starting Flutter Web Build on Vercel ---"

# 1. Install Flutter if not already there
if [ ! -d "$HOME/flutter" ]; then
    echo "Cloning Flutter SDK..."
    git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
fi

# 2. Add Flutter to PATH
export PATH="$PATH:$HOME/flutter/bin"

# 3. Enable Web support
echo "Enabling Flutter Web..."
flutter config --enable-web

# 4. Check Flutter version
flutter --version

# 5. Generate Firebase config (if required by the project)
if [ -f "scripts/generate-firebase-config.js" ]; then
    echo "Generating Firebase config..."
    node scripts/generate-firebase-config.js
fi

# 6. Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# 7. Build Web with dart-define for Firebase configuration
echo "Building Flutter Web (Release)..."
flutter build web --release --base-href / \
  --dart-define=FIREBASE_WEB_API_KEY="${FIREBASE_WEB_API_KEY}" \
  --dart-define=FIREBASE_WEB_APP_ID="${FIREBASE_WEB_APP_ID}" \
  --dart-define=FIREBASE_WEB_MESSAGING_SENDER_ID="${FIREBASE_WEB_MESSAGING_SENDER_ID}" \
  --dart-define=FIREBASE_WEB_PROJECT_ID="${FIREBASE_WEB_PROJECT_ID}" \
  --dart-define=FIREBASE_WEB_AUTH_DOMAIN="${FIREBASE_WEB_AUTH_DOMAIN}" \
  --dart-define=FIREBASE_WEB_STORAGE_BUCKET="${FIREBASE_WEB_STORAGE_BUCKET}" \
  --dart-define=FIREBASE_WEB_MEASUREMENT_ID="${FIREBASE_WEB_MEASUREMENT_ID:-}" \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"

echo "--- Build Finished! ---"
