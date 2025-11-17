# Saint Hunt - Project Summary

## 📱 Application Overview

**Saint Hunt** is a GPS-based mobile scavenger hunt application designed for tourists visiting St. Augustine, Florida. The app gamifies the tourist experience by guiding users to historical landmarks where they solve riddles, earn tokens, and redeem rewards at local businesses.

## ✅ Completed Features

### 1. Authentication System ✅
- **Sign Up Screen**: Complete user registration with email, phone number, full name, and password
- **Login Screen**: Email/password authentication with password reset functionality
- **Firebase Integration**: Fully integrated with Firebase Authentication
- **Session Management**: Automatic authentication state handling

### 2. Character Selection ✅
- **6 Unique Characters**:
  - Skull Pirate
  - Quartermaster
  - Ghost Captain
  - Salty Turtle
  - Vampire Pirate
  - Elf Swashbuckler
- User selects their avatar after registration
- Character stored in user profile

### 3. Interactive Map ✅
- **Google Maps Integration**: Full map interface with custom styling
- **Real-time GPS Tracking**: Continuous location updates
- **2-Mile Geofence**: Circular boundary around St. Augustine center (32 Saint George St)
- **Location Markers**: Hunt locations displayed with completion status
- **Proximity Detection**: Automatic detection when user is within 50 meters
- **Visual Indicators**: Different markers for completed vs. incomplete locations

### 4. Riddle System ✅
- **Location-Based Riddles**: Unique riddle for each landmark
- **Answer Validation**: Server-side validation of user answers
- **Historical Information**: Educational content after solving
- **Token Rewards**: Varying rewards based on difficulty (5-50 tokens)
- **Progress Tracking**: Completed locations saved to user profile

### 5. Token Economy ✅
- **Token Earning**: Users earn tokens by solving riddles
- **Wallet Screen**: Displays current balance with decorative UI
- **Transaction History**: Real-time list of recent redemptions
- **Firebase Integration**: All transactions stored in Firestore
- **Automatic Updates**: Balance updates immediately upon earning/spending

### 6. Custom UI Theme ✅
- **Vintage Parchment Aesthetic**: Consistent theme across all screens
- **Dark Teal Headers**: App bar with gold text
- **Ribbon-Style Buttons**: 3D effect buttons matching design
- **Custom Text Fields**: Bordered inputs with parchment background
- **Decorative Elements**: Scrollwork corners and ornamental borders
- **Custom Fonts**: Cinzel and Cinzel Decorative for authenticity

### 7. Data Models ✅
All models created with Firestore integration:
- `UserModel`: User profile, balance, completed locations
- `Character`: Avatar information
- `LocationModel`: Hunt spots with riddles and rewards
- `BusinessModel`: Partner businesses with offers
- `TransactionModel`: Token earning/spending history

### 8. Services ✅
- **AuthService**: Complete authentication handling
- **Firebase Services**: Fully configured Firestore integration
- **Location Services**: GPS tracking and proximity detection

## 📋 Sample Data Created

### Locations (10 landmarks)
1. Castillo de San Marcos (25 tokens)
2. St. George Street (10 tokens)
3. Lightner Museum (15 tokens)
4. Pirate & Treasure Museum (20 tokens)
5. Bridge of Lions (10 tokens)
6. Old City Gates (10 tokens)
7. Fountain of Youth (20 tokens)
8. Colonial Quarter (15 tokens)
9. St. Augustine Lighthouse (25 tokens)
10. Cathedral Basilica (15 tokens)

### Businesses (5 partners)
1. Crucial Coffee (cafe)
2. Salty Turtle (restaurant)
3. The Sweet Spot (candy shop)
4. Pirate's Cove Souvenirs (shop)
5. Colonial Tavern (restaurant)

## 🔄 Features In Progress

### Business Integration
- Business profile detail screens
- QR code redemption system
- Search and filter functionality
- Business discovery on map

## 📝 Still To Do

### Phase 5: Polish & Admin
1. **Assets**
   - Character images (6 pirate avatars)
   - Token icons (ship, ghost, fort, cannon, coins, etc.)
   - Background textures
   - Business icons

2. **Admin Dashboard**
   - Business owner portal
   - Redemption analytics
   - Offer management
   - Customer insights

3. **Additional Features**
   - Push notifications for nearby locations
   - Achievement badges
   - Leaderboard (optional)
   - Social sharing
   - Onboarding tutorial

4. **Platform Configuration**
   - iOS app icon and launch screen
   - Android app icon and splash screen
   - App store metadata
   - Privacy policy and terms of service

5. **Testing**
   - User acceptance testing
   - GPS accuracy testing
   - Performance optimization
   - Bug fixes

## 🗂️ Project Structure

```
saint_hunt/
├── android/                    # Android-specific files
├── ios/                        # iOS-specific files
├── lib/
│   ├── config/                # Configuration files
│   ├── models/                # Data models
│   │   ├── character.dart
│   │   ├── user_model.dart
│   │   ├── location_model.dart
│   │   ├── business_model.dart
│   │   └── transaction_model.dart
│   ├── screens/               # App screens
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── map/
│   │   │   ├── map_screen.dart
│   │   │   └── riddle_screen.dart
│   │   ├── wallet/
│   │   │   └── wallet_screen.dart
│   │   └── character_selection_screen.dart
│   ├── services/              # Business logic
│   │   └── auth_service.dart
│   ├── widgets/               # Reusable UI components
│   │   ├── parchment_background.dart
│   │   ├── parchment_text_field.dart
│   │   └── ribbon_button.dart
│   ├── utils/                 # Utilities
│   │   ├── constants.dart
│   │   └── theme.dart
│   └── main.dart              # App entry point
├── assets/
│   ├── images/
│   │   ├── characters/        # Character avatars
│   │   ├── tokens/            # Token icons
│   │   └── backgrounds/       # UI textures
│   └── fonts/                 # Custom fonts
├── firebase/                  # Firebase configuration
│   ├── sample_locations.json
│   ├── sample_businesses.json
│   └── SETUP_GUIDE.md
├── pubspec.yaml              # Dependencies
└── README.md                 # Documentation
```

## 🎯 Game Flow

1. **Onboarding**
   - User opens app
   - Views home screen with Saint Hunt logo
   - Taps "Sign Up" or "Log In"

2. **Registration**
   - Enters email, phone, name, password
   - Agrees to terms of service
   - Selects pirate character

3. **Exploration**
   - Views map with current location
   - Sees nearby hunt locations marked
   - Walks to a location

4. **Riddle Solving**
   - Gets notification when within 50 meters
   - Opens riddle screen
   - Reads historical riddle
   - Submits answer
   - Earns tokens if correct

5. **Reward Redemption**
   - Views wallet balance
   - Browses participating businesses
   - Visits business and shows QR code
   - Redeems tokens for offers
   - Transaction recorded in history

## 📊 Database Schema

### Firestore Collections

**users**
```
{
  uid: string,
  email: string,
  fullName: string,
  phoneNumber: string,
  selectedCharacterId: string,
  tokenBalance: number,
  completedLocations: string[],
  createdAt: timestamp
}
```

**locations**
```
{
  name: string,
  description: string,
  latitude: number,
  longitude: number,
  riddle: string,
  answer: string,
  tokenReward: number,
  triggerRadius: number,
  category: string,
  iconType: string,
  historicalInfo: string,
  isActive: boolean
}
```

**businesses**
```
{
  name: string,
  description: string,
  latitude: number,
  longitude: number,
  category: string,
  iconPath: string,
  offers: TokenOffer[],
  operatingHours: object,
  phoneNumber: string,
  website: string,
  address: string,
  isActive: boolean
}
```

**transactions**
```
{
  userId: string,
  businessId: string,
  businessName: string,
  amount: number,
  type: string,
  description: string,
  timestamp: timestamp
}
```

## 🔑 API Keys Required

1. **Firebase**
   - Authentication
   - Firestore Database
   - Storage (for images)

2. **Google Maps**
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API (optional)

## 🚀 Deployment Checklist

### Before Launch
- [ ] Add all character images
- [ ] Add all token icons
- [ ] Configure Firebase project
- [ ] Import location and business data
- [ ] Set up Google Maps API
- [ ] Configure iOS provisioning profiles
- [ ] Configure Android signing keys
- [ ] Test on real devices
- [ ] Create app store listings
- [ ] Write privacy policy
- [ ] Write terms of service

### App Store
- [ ] iOS: Submit to App Store Connect
- [ ] Android: Submit to Google Play Console
- [ ] Create promotional graphics
- [ ] Write app description
- [ ] Set pricing (free)
- [ ] Configure in-app purchases (if any)

## 💡 Future Enhancements

1. **Multiplayer Features**
   - Team challenges
   - Friend leaderboards
   - Social sharing

2. **Advanced Gamification**
   - Daily challenges
   - Seasonal events
   - Limited-time locations
   - Streak bonuses

3. **Business Portal**
   - Web dashboard for businesses
   - Analytics and insights
   - Custom offer creation
   - Customer engagement tools

4. **Content Expansion**
   - More locations (50+ total)
   - Different difficulty levels
   - Photo challenges
   - Audio guides

5. **Monetization**
   - Premium character unlocks
   - Hint purchases
   - Ad-free experience
   - Business partnerships

## 📞 Support & Contact

For technical support or business inquiries:
- Email: support@sainthunt.com
- Website: www.sainthunt.com

---

**Built with ❤️ for St. Augustine tourists**

