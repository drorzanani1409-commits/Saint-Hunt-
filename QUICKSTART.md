# Saint Hunt - Quick Start Guide

## ⚡ Get Running in 15 Minutes

### Prerequisites Check
- [ ] Flutter SDK installed (`flutter --version`)
- [ ] Android Studio or Xcode installed
- [ ] Google account (for Firebase)
- [ ] Physical device or emulator ready

### Step 1: Get the Code (1 min)
```bash
cd saint_hunt
flutter pub get
```

### Step 2: Firebase Setup (5 min)

1. **Create Firebase Project**
   - Go to https://console.firebase.google.com/
   - Click "Add Project" → Name it "Saint Hunt"
   - Click through the setup wizard

2. **Add Android App**
   - Package name: `com.sainthunt.saint_hunt`
   - Download `google-services.json`
   - Place in `android/app/google-services.json`

3. **Add iOS App** (if testing on iOS)
   - Bundle ID: `com.sainthunt.saintHunt`
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/GoogleService-Info.plist`

4. **Enable Services**
   - Authentication → Email/Password (enable it)
   - Firestore Database → Create database (test mode)
   - Storage → Get started

### Step 3: Google Maps API (3 min)

1. Go to https://console.cloud.google.com/
2. Enable these APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
3. Create API Key → Copy it
4. Add to your code:

**Android**: Edit `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

**iOS**: Edit `ios/Runner/AppDelegate.swift`
```swift
import GoogleMaps
// In didFinishLaunchingWithOptions:
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

**Code**: Edit `lib/utils/constants.dart`
```dart
static const String googleMapsApiKey = 'YOUR_API_KEY_HERE';
```

### Step 4: Add Sample Data (2 min)

**In Firebase Console → Firestore:**

1. Create collection: `locations`
   - Copy data from `firebase/sample_locations.json`
   - Add as individual documents

2. Create collection: `businesses`
   - Copy data from `firebase/sample_businesses.json`
   - Add as individual documents

**Quick tip**: You can add just 2-3 locations initially for testing!

### Step 5: Run the App! (2 min)

```bash
# For Android
flutter run

# For iOS
cd ios
pod install
cd ..
flutter run
```

### Step 6: Test the Flow (2 min)

1. **Sign Up**: Create a test account
   - Email: test@example.com
   - Password: test123456
   - Phone: (555) 123-4567
   - Name: Test User

2. **Select Character**: Choose any pirate

3. **View Map**: You should see:
   - Your current location (blue dot)
   - Location markers (red/green pins)
   - 2-mile radius circle

4. **Simulate Location** (if not in St. Augustine):
   - Use Android Studio or Xcode location simulator
   - Set to: 29.8947, -81.3124 (St. Augustine)
   - Get close to a marker to unlock riddle

## 🐛 Common Issues & Fixes

### "Flutter SDK not found"
```bash
# Add Flutter to PATH
export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"
```

### "Google Maps not showing"
- Check API key is correct
- Verify Maps SDKs are enabled in Cloud Console
- Check internet connection

### "Location permission denied"
- Android: Grant permission in Settings → Apps → Saint Hunt
- iOS: Grant permission when prompted

### "Firestore permission denied"
**Update Firestore Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### "Build failed" on iOS
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### "Build failed" on Android
- Make sure `google-services.json` exists in `android/app/`
- Check Android Studio is updated
- Try: `flutter clean && flutter pub get`

## 🎯 Testing Checklist

Once app is running, verify:

- [ ] Sign up creates user in Firebase Console
- [ ] Login works with created account
- [ ] Character selection saves to profile
- [ ] Map loads and shows location markers
- [ ] GPS tracking shows blue dot
- [ ] Wallet shows 0 tokens initially
- [ ] Can navigate between screens

## 📱 Testing Locations Without Travel

You can't physically visit St. Augustine? No problem!

### Android Emulator
1. In emulator, click "..." (Extended Controls)
2. Go to "Location"
3. Enter coordinates: 29.8947, -81.3124
4. Click "Send"

### iOS Simulator
1. Debug → Location → Custom Location
2. Latitude: 29.8947
3. Longitude: -81.3124

### Test Specific Locations
```
Castillo de San Marcos: 29.8981, -81.3124
St. George Street: 29.8947, -81.3124
Pirate Museum: 29.8960, -81.3126
```

## 🚀 Next Steps

Now that your app is running:

1. **Add More Content**
   - Add remaining locations from sample data
   - Create custom riddles
   - Add business partners

2. **Customize Branding**
   - Add character images to `assets/images/characters/`
   - Add token icons to `assets/images/tokens/`
   - Add app icon

3. **Test Features**
   - Try solving riddles
   - Check token balance updates
   - Test wallet screen

4. **Deploy**
   - Follow iOS deployment guide
   - Follow Android deployment guide
   - Submit to app stores

## 💡 Pro Tips

1. **Use Firebase Emulator** for faster development
2. **Enable Debug Mode** to see detailed logs
3. **Test on Real Device** for GPS accuracy
4. **Use Version Control** (Git) for code safety

## 📚 Documentation

- Full setup: `firebase/SETUP_GUIDE.md`
- Project details: `PROJECT_SUMMARY.md`
- Architecture: `README.md`

## 🆘 Need Help?

- Check Firebase docs: https://firebase.google.com/docs
- Check Flutter docs: https://flutter.dev/docs
- Google Maps Flutter: https://pub.dev/packages/google_maps_flutter

---

**You're ready to hunt! 🏴‍☠️**

