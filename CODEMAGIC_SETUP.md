# How to Build Your Saint Hunt App with Codemagic (No Flutter Needed!)

## 🎯 What is Codemagic?
Codemagic is a cloud CI/CD service that builds Flutter apps for you. You don't need Flutter installed on your PC!

## ✅ Benefits:
- **FREE** - 500 build minutes/month
- **Builds iOS** - Without a Mac!
- **Builds Android** - Without Android Studio!
- **Automatic** - Just push code to GitHub
- **Fast** - Professional build servers

## 📋 Setup Steps (15 minutes)

### Step 1: Create GitHub Account (if you don't have one)
1. Go to: https://github.com/signup
2. Create free account
3. Verify your email

### Step 2: Upload Your App to GitHub

**Option A: Use GitHub Desktop (Easier)**
1. Download: https://desktop.github.com/
2. Install and sign in
3. Click "Create New Repository"
4. Name: `saint-hunt`
5. Local Path: `C:\Users\drorz\saint_hunt`
6. Click "Create Repository"
7. Click "Publish repository"

**Option B: Use Command Line**
```bash
cd C:\Users\drorz\saint_hunt
git init
git add .
git commit -m "Initial commit"
git branch -M main
# Create repo on GitHub first, then:
git remote add origin https://github.com/YOUR_USERNAME/saint-hunt.git
git push -u origin main
```

### Step 3: Connect to Codemagic

1. **Sign Up**
   - Go to: https://codemagic.io/
   - Click "Sign up with GitHub"
   - Authorize Codemagic

2. **Add Your App**
   - Click "Add application"
   - Select "Flutter app"
   - Choose your `saint-hunt` repository
   - Click "Finish"

3. **Configure Build**
   - Codemagic will detect your `codemagic.yaml` file
   - It has 2 workflows:
     - `ios-workflow` - Builds iPhone app
     - `android-workflow` - Builds Android app

### Step 4: Add Firebase Config (Required)

**For Android:**
1. In Codemagic, go to your app settings
2. Click "Environment variables"
3. Add secure file: `google-services.json`
   - Upload: `C:\Users\drorz\saint_hunt\android\app\google-services.json`

**For iOS:**
1. Add secure file: `GoogleService-Info.plist`
   - Upload: `C:\Users\drorz\saint_hunt\ios\Runner\GoogleService-Info.plist`

### Step 5: Build Your App!

1. **Android Build:**
   - In Codemagic, select `android-workflow`
   - Click "Start new build"
   - Wait 5-10 minutes
   - Download `.apk` file
   - Install on Android phone!

2. **iOS Build:**
   - Select `ios-workflow`
   - Click "Start new build"
   - Wait 5-10 minutes
   - Download `.app` file
   - (Need Apple Developer account to install on iPhone)

## 📱 What You Get

**Android (.apk file):**
- Can install directly on any Android phone
- No App Store needed for testing
- Share with friends via file transfer

**iOS (.app file):**
- Need to sign with Apple Developer account
- Or use TestFlight for testing
- $99/year for App Store publishing

## 🎉 Advantages

✅ No Flutter install needed
✅ No Mac needed for iOS
✅ No Android Studio needed
✅ Builds on professional servers
✅ Automatic builds when you push code
✅ Both platforms from one service
✅ **FREE for 500 minutes/month**

## 💰 Free Tier Limits

- **500 build minutes/month**
- **Each build takes ~5-10 minutes**
- **You can build 50-100 times/month FREE**
- **More than enough for development!**

## 🚀 Quick Start Commands

After setting up GitHub:

```bash
# Make changes to your app
cd C:\Users\drorz\saint_hunt

# Push changes
git add .
git commit -m "Update app"
git push

# Codemagic automatically builds!
```

## 🔐 Apple Developer Account (For iOS)

To publish to App Store:
1. Sign up: https://developer.apple.com/
2. Cost: $99/year
3. Add certificates to Codemagic
4. Build and publish!

Without paid account:
- You can still BUILD iOS app
- Just can't install on physical iPhone
- Can use iOS Simulator on Mac

## 📞 Need Help?

- Codemagic Docs: https://docs.codemagic.io/flutter/
- GitHub Help: https://docs.github.com/
- Your `codemagic.yaml` is ready to use!

## ✅ Summary

1. Upload code to GitHub
2. Connect to Codemagic
3. Click "Build"
4. Download your apps!

**No Flutter, No Mac, No Android Studio needed!** 🎉

