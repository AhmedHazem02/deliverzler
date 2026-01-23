#!/usr/bin/env node
/**
 * Generate firebase-config.js and index.html from environment variables
 * This script reads .env.local and creates files with actual values
 */

const fs = require('fs');
const path = require('path');

// Read .env.local file
const envPath = path.join(__dirname, '..', '.env.local');
const firebaseTemplatePath = path.join(__dirname, '..', 'web', 'firebase-config.template.js');
const firebaseOutputPath = path.join(__dirname, '..', 'web', 'firebase-config.js');
const indexTemplatePath = path.join(__dirname, '..', 'web', 'index.template.html');
const indexOutputPath = path.join(__dirname, '..', 'web', 'index.html');

// Parse .env.local if it exists
const envVars = { ...process.env };
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf8');
  envContent.split('\n').forEach(line => {
    line = line.trim();
    // Skip comments and empty lines
    if (line.startsWith('#') || !line) return;

    const [key, ...valueParts] = line.split('=');
    if (key && valueParts.length > 0) {
      envVars[key.trim()] = valueParts.join('=').trim();
    }
  });
} else {
  console.log('ℹ️  .env.local not found, using process environment variables.');
}

console.log('🔧 Generating web configuration files from .env.local...\n');

// === Generate firebase-config.js ===
let firebaseTemplate = fs.readFileSync(firebaseTemplatePath, 'utf8');

const firebaseReplacements = {
  '%FIREBASE_WEB_API_KEY%': envVars['FIREBASE_WEB_API_KEY'] || '',
  '%FIREBASE_WEB_AUTH_DOMAIN%': envVars['FIREBASE_WEB_AUTH_DOMAIN'] || '',
  '%FIREBASE_WEB_PROJECT_ID%': envVars['FIREBASE_WEB_PROJECT_ID'] || '',
  '%FIREBASE_WEB_STORAGE_BUCKET%': envVars['FIREBASE_WEB_STORAGE_BUCKET'] || '',
  '%FIREBASE_WEB_MESSAGING_SENDER_ID%': envVars['FIREBASE_WEB_MESSAGING_SENDER_ID'] || '',
  '%FIREBASE_WEB_APP_ID%': envVars['FIREBASE_WEB_APP_ID'] || '',
  '%FIREBASE_WEB_MEASUREMENT_ID%': envVars['FIREBASE_WEB_MEASUREMENT_ID'] || ''
};

Object.entries(firebaseReplacements).forEach(([placeholder, value]) => {
  firebaseTemplate = firebaseTemplate.replace(placeholder, value);
});

fs.writeFileSync(firebaseOutputPath, firebaseTemplate, 'utf8');
console.log('✅ Generated: web/firebase-config.js');

// === Generate index.html ===
let indexTemplate = fs.readFileSync(indexTemplatePath, 'utf8');

const indexReplacements = {
  '%GOOGLE_MAPS_WEB_API_KEY%': envVars['GOOGLE_MAPS_WEB_API_KEY'] || ''
};

Object.entries(indexReplacements).forEach(([placeholder, value]) => {
  indexTemplate = indexTemplate.replace(placeholder, value);
});

fs.writeFileSync(indexOutputPath, indexTemplate, 'utf8');
console.log('✅ Generated: web/index.html');

// === Summary ===
console.log('\n📝 Configuration Summary:');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
console.log(`Google Maps API Key: ${envVars['GOOGLE_MAPS_WEB_API_KEY']?.substring(0, 20)}...`);
console.log(`Firebase Project ID: ${envVars['FIREBASE_WEB_PROJECT_ID']}`);
console.log(`Firebase API Key: ${envVars['FIREBASE_WEB_API_KEY']?.substring(0, 20)}...`);
console.log(`Firebase App ID: ${envVars['FIREBASE_WEB_APP_ID']?.substring(0, 30)}...`);

// Validate VAPID key
if (!envVars['FIREBASE_WEB_VAPID_KEY'] || envVars['FIREBASE_WEB_VAPID_KEY'] === 'YOUR_VAPID_KEY_HERE') {
  console.warn('\n⚠️  WARNING: VAPID key not set!');
  console.warn('   Please generate a VAPID key from Firebase Console:');
  console.warn('   Firebase Console > Project Settings > Cloud Messaging > Web Push certificates');
  console.warn('   Then update FIREBASE_WEB_VAPID_KEY in .env.local');
}

console.log('\n✅ Done! Web configuration files are ready.');
console.log('💡 Remember to run this script whenever you update .env.local');

