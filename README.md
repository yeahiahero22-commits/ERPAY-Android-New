# ERPAY Android Demo

A self-contained Android WebView project. The UI includes local demo registration/sign-in, dashboard, profile editing, settings and online/offline status.

**Important:** This is a UI prototype only. It does not process payments, verify UTRs, connect to banks, or provide server-side authentication. Demo balances are not real money.

## Project layout
- `settings.gradle` — project modules and repositories
- `build.gradle` — Android Gradle Plugin version
- `gradle.properties` — Gradle settings
- `app/build.gradle` — Android app configuration
- `app/src/main/AndroidManifest.xml` — Android app manifest
- `app/src/main/java/com/erpay/demo/MainActivity.java` — WebView activity
- `app/src/main/assets/index.html` — app interface

## Build APK using GitHub Actions (phone-friendly)
1. Create/open a GitHub repository.
2. Upload the **contents** of this ZIP while preserving the folder structure. Do not upload the outer `ERPAY-Android-Complete` folder itself.
3. Make sure `.github/workflows/build-apk.yml` is also uploaded.
4. Commit the files to the `main` branch.
5. Open the repository's **Actions** tab and choose **Build ERPAY APK**.
6. Tap **Run workflow** if it does not start automatically.
7. Open the completed run, scroll to **Artifacts**, and download `ERPAY-debug-APK`.
8. Extract the artifact ZIP and install `app-debug.apk`. Android may ask you to allow installation from your browser/files app.

## Build locally
Install JDK 17, Android SDK Platform 35, Build Tools 35.0.0 and Gradle 8.9, then run:
`gradle --no-daemon assembleDebug`

No Gradle wrapper is included; GitHub Actions installs Gradle for you.
