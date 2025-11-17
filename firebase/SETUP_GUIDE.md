# Firebase Setup Guide for Saint Hunt

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Name your project: **Saint Hunt**
4. Disable Google Analytics (optional)
5. Click "Create Project"

## Step 2: Add iOS App

1. In Firebase Console, click "Add app" → iOS
2. iOS bundle ID: `com.sainthunt.saintHunt`
3. Download `GoogleService-Info.plist`
4. Add it to your project:
   - Open Xcode
   - Right-click on `Runner` folder
   - Select "Add Files to Runner"
   - Select the downloaded file
   - Check "Copy items if needed"

## Step 3: Add Android App

1. In Firebase Console, click "Add app" → Android
2. Android package name: `com.sainthunt.saint_hunt`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

## Step 4: Enable Firebase Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get Started"
3. Enable "Email/Password" sign-in method
4. Save

## Step 5: Create Firestore Database

1. In Firebase Console, go to "Firestore Database"
2. Click "Create Database"
3. Choose "Start in test mode" (we'll add rules later)
4. Select your region (choose closest to St. Augustine, FL)
5. Click "Enable"

## Step 6: Set Up Firestore Security Rules

1. In Firestore, go to "Rules" tab
2. Replace with the following:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Everyone can read locations (but not write)
    match /locations/{locationId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // Everyone can read businesses (but not write)
    match /businesses/{businessId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // Users can read their own transactions and create new ones
    match /transactions/{transactionId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if false;
    }
  }
}
```

3. Click "Publish"

## Step 7: Import Sample Data

### Using Firebase Console (Manual)

1. Go to Firestore Database
2. Click "Start collection"
3. Collection ID: `locations`
4. Add documents using data from `sample_locations.json`
5. Repeat for `businesses` collection using `sample_businesses.json`

### Using Firebase CLI (Automated)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project
cd saint_hunt
firebase init firestore

# Import data (if you have firebase-tools installed)
firebase firestore:import ./firebase/sample_locations.json --collection locations
firebase firestore:import ./firebase/sample_businesses.json --collection businesses
```

## Step 8: Enable Firebase Storage (Optional)

1. In Firebase Console, go to "Storage"
2. Click "Get Started"
3. Use default security rules for now
4. This will be used for character images and business icons

## Step 9: Configure Google Maps

### Get API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project (or create new project)
3. Enable APIs:
   - Google Maps SDK for Android
   - Google Maps SDK for iOS
   - Places API (optional, for business search)
4. Go to "Credentials" → "Create Credentials" → "API Key"
5. Copy your API key

### Add to Android

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
    <application ...>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY_HERE"/>
    </application>
</manifest>
```

### Add to iOS

Edit `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Update Constants

Edit `lib/utils/constants.dart`:

```dart
static const String googleMapsApiKey = 'YOUR_API_KEY_HERE';
```

## Step 10: Test the Setup

1. Run the app:
```bash
flutter run
```

2. Try creating an account
3. Check Firebase Console to see if user was created
4. Verify that locations appear on the map

## Troubleshooting

### iOS Build Errors
- Make sure you have CocoaPods installed: `sudo gem install cocoapods`
- Run `cd ios && pod install`
- Clean build: `flutter clean && flutter pub get`

### Android Build Errors
- Make sure `google-services.json` is in `android/app/`
- Check that `build.gradle` has the Google services plugin

### Map Not Showing
- Verify API key is correct
- Check that Google Maps SDK is enabled in Cloud Console
- Make sure location permissions are granted

### Firestore Permission Denied
- Check security rules are published
- Verify user is authenticated before accessing Firestore
- Check that collection names match exactly

## Next Steps

1. Upload character images to Firebase Storage
2. Create custom map style (optional)
3. Set up Cloud Functions for advanced features
4. Configure push notifications
5. Add analytics tracking

## Support

For issues, check:
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Firebase Plugins](https://firebase.flutter.dev/)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)

