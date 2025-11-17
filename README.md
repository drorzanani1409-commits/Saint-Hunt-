# Saint Hunt - GPS Scavenger Hunt App

A GPS-based mobile scavenger hunt application for tourists in St. Augustine, Florida. Players explore historical landmarks, solve riddles, collect tokens, and redeem rewards at local businesses.

## 🎮 Features

- **GPS-Triggered Locations**: Real-time location tracking activates riddles when players are near landmarks
- **Character Selection**: Choose from 6 unique pirate characters
- **Token Economy**: Earn tokens by solving riddles, spend them at participating businesses
- **Historical Education**: Learn about St. Augustine's rich history
- **Beautiful UI**: Vintage pirate-themed interface with parchment textures
- **Real-time Updates**: Live token balance and location tracking

## 🛠️ Tech Stack

- **Framework**: Flutter (iOS & Android)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Maps**: Google Maps SDK
- **Location**: Geolocator package
- **State Management**: Provider

## 📍 Game Area

- **Center Point**: 32 Saint George Street, St. Augustine, FL 32084
- **Radius**: 2 miles from center
- **Coordinates**: 29.8947° N, 81.3124° W

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Firebase account
- Google Maps API key
- iOS: Xcode 14+
- Android: Android Studio

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/saint_hunt.git
cd saint_hunt
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
   - Create a new Firebase project at [firebase.google.com](https://firebase.google.com)
   - Add iOS and Android apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Configure Google Maps**
   - Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com)
   - Enable Google Maps SDK for iOS and Android
   - Add the API key:
     - Android: `android/app/src/main/AndroidManifest.xml`
     - iOS: `ios/Runner/AppDelegate.swift`
   - Update `lib/utils/constants.dart` with your API key

5. **Set up Firestore Database**
   - Enable Firestore in your Firebase console
   - Create the following collections:
     - `users`
     - `locations`
     - `businesses`
     - `transactions`
   - Import sample data (see `firebase/sample_data.json`)

6. **Run the app**
```bash
flutter run
```

## 📱 Firebase Configuration

### Firestore Collections

#### users
```json
{
  "uid": "string",
  "email": "string",
  "fullName": "string",
  "phoneNumber": "string",
  "selectedCharacterId": "string",
  "tokenBalance": "number",
  "completedLocations": ["array of location IDs"],
  "createdAt": "timestamp"
}
```

#### locations
```json
{
  "name": "string",
  "description": "string",
  "latitude": "number",
  "longitude": "number",
  "riddle": "string",
  "answer": "string",
  "tokenReward": "number",
  "triggerRadius": "number",
  "category": "string",
  "iconType": "string",
  "historicalInfo": "string",
  "isActive": "boolean"
}
```

#### businesses
```json
{
  "name": "string",
  "description": "string",
  "latitude": "number",
  "longitude": "number",
  "category": "string",
  "iconPath": "string",
  "offers": ["array of token offers"],
  "operatingHours": {"object"},
  "phoneNumber": "string",
  "website": "string",
  "address": "string",
  "isActive": "boolean"
}
```

## 🎨 App Screens

1. **Home Screen** - Saint Hunt logo and branding
2. **Sign Up** - User registration with email, phone, password
3. **Login** - Email/password authentication
4. **Character Selection** - Choose your pirate avatar
5. **Map Screen** - Interactive map with location markers
6. **Riddle Screen** - Solve riddles at locations
7. **Wallet Screen** - View token balance and redemptions
8. **Business Profile** - View offers and redeem tokens

## 🎯 Gameplay Flow

1. User signs up and selects a character
2. Explores St. Augustine with map guidance
3. Gets notified when near a hunt location
4. Solves riddles to earn tokens
5. Spends tokens at local businesses
6. Completes the hunt and collects rewards

## 🔐 Security Rules

Update your Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /locations/{locationId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins through console
    }
    
    match /businesses/{businessId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins through console
    }
    
    match /transactions/{transactionId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }
  }
}
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  provider: ^6.1.1
```

## 🎨 Custom Assets

Place the following assets in the `assets` directory:

- Character images: `assets/images/characters/`
- Token icons: `assets/images/tokens/`
- Background textures: `assets/images/backgrounds/`
- Fonts: `assets/fonts/`

## 🐛 Troubleshooting

### iOS Location Permission
Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby scavenger hunt spots</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to notify you of nearby locations</string>
```

### Android Location Permission
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## 📝 License

Copyright © 2025 Saint Hunt. All rights reserved.

## 🤝 Contributing

This is a private project. For business inquiries, please contact the project owner.

## 📧 Support

For support, email support@sainthunt.com

---

**Happy Hunting! 🏴‍☠️**

