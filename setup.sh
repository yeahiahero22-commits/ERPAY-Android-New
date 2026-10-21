
#!/usr/bin/env bash
set -euo pipefail

mkdir -p app/src/main/java/com/erpay/demo
mkdir -p app/src/main/assets
mkdir -p .github/workflows

cat > settings.gradle <<'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "ERPAY"
include(":app")
EOF

cat > build.gradle <<'EOF'
plugins {
    id 'com.android.application' version '8.7.3' apply false
}
EOF

cat > gradle.properties <<'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
EOF

cat > app/build.gradle <<'EOF'
plugins {
    id 'com.android.application'
}
android {
    namespace 'com.erpay.demo'
    compileSdk 35
    defaultConfig {
        applicationId 'com.erpay.demo'
        minSdk 23
        targetSdk 35
        versionCode 1
        versionName '1.0-demo'
    }
}
EOF

cat > app/src/main/AndroidManifest.xml <<'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:allowBackup="false"
        android:label="ERPAY Demo"
        android:theme="@android:style/Theme.Material.Light.NoActionBar">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

cat > app/src/main/java/com/erpay/demo/MainActivity.java <<'EOF'
package com.erpay.demo;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        WebView web = new WebView(this);
        WebSettings s = web.getSettings();
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true);
        web.setWebViewClient(new WebViewClient());
        setContentView(web);
        web.loadUrl("file:///android_asset/index.html");
    }
}
EOF

cat > app/src/main/assets/index.html <<'EOF'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="theme-color" content="#090d18">
<title>ERPAY Demo</title>
<style>
*{box-sizing:border-box}body{margin:0;padding:22px;background:#080c16;color:#f4f7ff;font:16px system-ui;max-width:560px;margin:auto}header{color:#f1c879;font-size:25px;font-weight:900;letter-spacing:3px}.notice,.card{padding:18px;margin:18px 0;border:1px solid #263754;border-radius:18px;background:#111a2b}.notice{color:#ffe7b5;background:#302615;font-size:12px}input,button{width:100%;padding:14px;margin:8px 0;border-radius:12px;font-size:15px}input{background:#0b1220;color:white;border:1px solid #334866}button{border:0;background:#f1c879;color:#111827;font-weight:bold}.secondary{background:#1a2942;color:white}.muted{color:#9aa9c4;font-size:13px}.hidden{display:none!important}nav{display:flex;gap:8px}nav button{flex:1}.stat{padding:14px;background:#0c1423;border-radius:12px;margin:8px 0}
</style>
</head>
<body>
<header>ERPAY</header>
<div class="notice"><b>DEMO ONLY</b><br>No real payments, bank connections, or real balances. Login is local prototype functionality only.</div>
<section id="auth" class="card">
<h2 id="heading">Welcome back</h2>
<div id="namebox" class="hidden"><input id="name" placeholder="Full name"></div>
<input id="email" type="email" placeholder="Email address">
<input id="password" type="password" placeholder="Demo password">
<button onclick="enter()">Sign in to demo</button>
<button class="secondary" onclick="toggle()">Create demo account</button>
<p class="muted">Do not enter real banking passwords or OTPs.</p>
</section>
<section id="dashboard" class="hidden">
<h2 id="hello">Dashboard</h2>
<div class="card"><div class="stat">Demo wallet: ₹0.00</div><div class="stat">Demo activity: 0</div><p class="muted">All values are simulated.</p></div>
<div class="card" id="profile"><h3>Profile</h3><p id="details"></p><input id="displayname" placeholder="Display name"><button onclick="save()">Save profile</button></div>
<div class="card"><h3>Settings</h3><p class="muted">Dark navy and gold theme · Local demo data</p><button class="secondary" onclick="logout()">Sign out</button></div>
</section>
<script>
let registering=false;
function toggle(){registering=!registering;document.getElementById('namebox').classList.toggle('hidden',!registering);document.getElementById('heading').textContent=registering?'Create demo account':'Welcome back'}
function enter(){let e=document.getElementById('email').value.trim(),n=document.getElementById('name').value.trim()||'Demo User',p=document.getElementById('password').value;if(!e.includes('@')||!p||(registering&&!n)){alert('Enter a valid email and demo password.');return}let u={name:n,email:e};try{let old=JSON.parse(localStorage.getItem('erpayProfile')||'null');if(!registering&&old&&old.email===e)u=old}catch(err){}localStorage.setItem('erpayProfile',JSON.stringify(u));show(u)}
function show(u){document.getElementById('auth').classList.add('hidden');document.getElementById('dashboard').classList.remove('hidden');document.getElementById('hello').textContent='Hello, '+u.name;document.getElementById('details').textContent=u.name+' · '+u.email;document.getElementById('displayname').value=u.name}
function save(){let u=JSON.parse(localStorage.getItem('erpayProfile')||'{}');u.name=document.getElementById('displayname').value.trim()||u.name;localStorage.setItem('erpayProfile',JSON.stringify(u));show(u);alert('Demo profile saved')}
function logout(){document.getElementById('dashboard').classList.add('hidden');document.getElementById('auth').classList.remove('hidden')}
</script>
</body>
</html>
EOF

cat > .github/workflows/build-apk.yml <<'EOF'
name: Build ERPAY APK
on:
  workflow_dispatch:
  push:
    branches: [main]
permissions:
  contents: read
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'
      - uses: android-actions/setup-android@v3
      - name: Install Android SDK packages
        run: sdkmanager "platforms;android-35" "build-tools;35.0.0"
      - uses: gradle/actions/setup-gradle@v4
        with:
          gradle-version: '8.9'
      - name: Build debug APK
        run: gradle --no-daemon assembleDebug
      - uses: actions/upload-artifact@v4
        with:
          name: ERPAY-debug-APK
          path: app/build/outputs/apk/debug/app-debug.apk
EOF

echo "ERPAY project files created."
