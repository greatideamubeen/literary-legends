# 📱 Literary Legends — Play Store Publishing Guide

Follow this guide to build your app and publish it on the Google Play Store.

---

## Step 1: Install Flutter & Android Studio

### 1.1 Install Flutter SDK
```bash
# macOS (using Homebrew)
brew install flutter

# Windows
# Download from: https://docs.flutter.dev/get-started/install
# Extract to C:\flutter and add to PATH

# Linux
sudo snap install flutter --classic
```

### 1.2 Verify Installation
```bash
flutter doctor
```
Fix any issues shown (usually Android Studio, Android SDK, or Java).

### 1.3 Install Android Studio
Download from: https://developer.android.com/studio

Open Android Studio → SDK Manager → Install:
- Android SDK Platform (latest)
- Android SDK Build-Tools
- Android Emulator (optional, for testing)

---

## Step 2: Set Up the Project

### 2.1 Create a New Flutter Project
```bash
flutter create literary_legends
cd literary_legends
```

### 2.2 Replace Project Files
Copy ALL files from this `book_gaming_app` folder into your new Flutter project:
- Replace `pubspec.yaml`
- Replace `lib/` folder entirely
- Create `assets/sounds/` and `assets/images/` folders

### 2.3 Install Dependencies
```bash
flutter pub get
```

### 2.4 Test the App
```bash
flutter run
```

---

## Step 3: Configure App for Release

### 3.1 Update App Name & Package ID

Edit `android/app/build.gradle`:
```gradle
android {
    namespace = "com.yourname.literarylegends"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId "com.yourname.literarylegends"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0.0"
    }
}
```

### 3.2 Create a Keystore (Signing Key)
```bash
# macOS/Linux
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA   -keysize 2048 -validity 10000 -alias upload

# Windows
keytool -genkey -v -keystore %USERPROFILE%\upload-keystore.jks -keyalg RSA   -keysize 2048 -validity 10000 -alias upload
```

**IMPORTANT:** Save this file securely. You cannot update your app without it.

### 3.3 Configure Signing

Create `android/key.properties`:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

Edit `android/app/build.gradle` and add BEFORE the `android {` block:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Inside `android {` block, replace `buildTypes` with:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

### 3.4 Add Internet Permission
Edit `android/app/src/main/AndroidManifest.xml` and add inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

---

## Step 4: Build Release APK/AAB

### 4.1 Build App Bundle (Recommended for Play Store)
```bash
flutter build appbundle
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 4.2 Build APK (For side-loading/testing)
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## Step 5: Publish on Google Play Store

### 5.1 Create Google Play Developer Account
1. Go to: https://play.google.com/console
2. Pay the **$25 one-time registration fee**
3. Complete account verification (may take 1-2 days)

### 5.2 Create Your App
1. Click **"Create app"**
2. App name: `Literary Legends`
3. Default language: English
4. App or game: **App**
5. Free or paid: **Free**
6. Check declarations → **Create app**

### 5.3 Set Up App
Complete ALL sections in the left sidebar:

#### App Access
- Select **"All functionality is available without special access"**

#### Ads
- Select **"No, my app does not contain ads"**

#### Content Ratings
- Click **"Start questionnaire"**
- Category: **Reference, Information, or Utility**
- Answer questions about violence, language, etc. (all NO for this app)
- Save → Calculate rating

#### Target Audience
- Select **18+** or **13+** (this is a general trivia app)
- Confirm compliance

#### News Apps
- Select **No**

#### Data Safety
- Click **"Start"**
- Does your app collect data? **No**
- Save

#### Select App Category
- Category: **Trivia**
- Tags: `Trivia`, `Books`, `Education`, `Quiz`
- Contact email: your email
- External marketing: optional

### 5.4 Upload App
1. Go to **Production** → **Create new release**
2. Upload your `.aab` file from Step 4.1
3. Release name: `1.0.0`
4. Release notes: 
   ```
   Initial release of Literary Legends!
   - 4 exciting game modes
   - 60+ book trivia questions
   - Local leaderboard
   - Beautiful book-themed design
   ```
5. Save → Review release

### 5.5 Add Store Listing

#### App Details
- Short description (80 chars):
  ```
  Test your book knowledge! 4 game modes, 60+ questions, leaderboard.
  ```
- Full description (4000 chars max):
  ```
  📚 Literary Legends — The Ultimate Book Trivia Game!

  Are you a true bookworm? Put your literary knowledge to the test with 4 exciting game modes:

  📖 Book Trivia — Guess the book from the clue
  ✍️ Author Quiz — Match authors to their masterpieces  
  💬 Quote Challenge — Fill in the missing words from famous quotes
  ⚡ Speed Round — Fast-paced rapid-fire questions against the clock

  Features:
  ✅ 60+ carefully curated questions
  ✅ 3 difficulty levels (Easy, Medium, Hard)
  ✅ Local leaderboard to track your best scores
  ✅ Beautiful book-themed design
  ✅ Fun facts after every question
  ✅ Perfect for book clubs, students, and trivia lovers

  Whether you're a casual reader or a literary scholar, Literary Legends has something for you. Challenge your friends and see who knows the most about the world's greatest books!

  Download now and prove you're a Literary Legend! 🏆
  ```

#### Graphics
You need to create/upload:

**App Icon (512x512 PNG)**
- Use Canva (free) to create a book-themed icon
- Suggested: Stack of books with a crown or star

**Feature Graphic (1024x500 PNG)**
- Banner image for Play Store listing
- Suggested: Dark background with golden books and "Literary Legends" text

**Phone Screenshots (minimum 2, recommended 4-8)**
- Take screenshots from the app running on your phone
- Or use Android Emulator: `flutter emulators --launch <id>`
- Screenshots should show: Home screen, gameplay, results, leaderboard

**Optional:**
- Tablet screenshots
- Promo video (30 sec - 2 min)

### 5.6 Set Up Pricing
- Select **Free**
- Available countries: All countries

### 5.7 Content Rating (already done in 5.3)

### 5.8 Review & Rollout
1. Go to **Publishing overview**
2. Click **"Send for review"**
3. Google will review your app (usually 1-3 days)
4. Once approved, click **"Start rollout to Production"**

---

## Step 6: Post-Launch

### Update Your App
When you want to release an update:
1. Update `versionCode` and `versionName` in `android/app/build.gradle`
2. Build new AAB: `flutter build appbundle`
3. Upload to Play Console → Production → Create new release

### Monitor Performance
- Check **Statistics** in Play Console for downloads, ratings, crashes
- Respond to user reviews
- Update questions/content regularly to keep users engaged

---

## 🚀 Quick Command Reference

```bash
# Run on device
flutter run

# Build release APK
flutter build apk --release

# Build release AAB (for Play Store)
flutter build appbundle

# Clean build
flutter clean && flutter pub get

# Check for issues
flutter doctor
```

---

## 🎨 Optional: Add Sound Effects

1. Add `.mp3` files to `assets/sounds/`
2. Uncomment sound code in `game_screen.dart` (marked with `// TODO: Add sound`)
3. The `audioplayers` package is already included in `pubspec.yaml`

---

## 📧 Need Help?

- Flutter docs: https://docs.flutter.dev
- Play Console help: https://support.google.com/googleplay/android-developer
- Flutter community: https://flutter.dev/community

**Good luck with your launch! 🎉📚**
