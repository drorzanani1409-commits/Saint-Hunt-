# Saint Hunt - Assets Guide

This document describes all the visual assets needed for the Saint Hunt app and where to place them.

## 📁 Directory Structure

```
assets/
├── images/
│   ├── backgrounds/
│   │   ├── parchment_texture.png
│   │   ├── home_screen_bg.png
│   │   └── teal_pattern.png
│   ├── characters/
│   │   ├── skull_pirate.png
│   │   ├── quartermaster.png
│   │   ├── ghost_captain.png
│   │   ├── salty_turtle.png
│   │   ├── vampire_pirate.png
│   │   └── elf_swashbuckler.png
│   ├── tokens/
│   │   ├── ship_5.png
│   │   ├── ghost.png
│   │   ├── fort_10.png
│   │   ├── cannon.png
│   │   ├── star.png
│   │   ├── coin_1.png
│   │   ├── coin_10.png
│   │   ├── coin_25.png
│   │   ├── coin_50.png
│   │   ├── pitcher.png
│   │   ├── lion.png
│   │   └── coins_stack.png
│   ├── business_icons/
│   │   ├── coffee.png
│   │   ├── turtle.png
│   │   ├── candy.png
│   │   ├── chest.png
│   │   └── mug.png
│   ├── ui/
│   │   ├── logo.png
│   │   ├── ribbon_banner.png
│   │   ├── ornate_frame.png
│   │   └── scrollwork.png
│   └── map/
│       ├── marker_active.png
│       ├── marker_completed.png
│       └── marker_locked.png
└── fonts/
    ├── Cinzel-Regular.ttf
    ├── Cinzel-Bold.ttf
    └── CinzelDecorative-Bold.ttf
```

## 🎨 Asset Specifications

### Character Images
**Location**: `assets/images/characters/`
**Format**: PNG with transparency
**Size**: 512x512px minimum
**Style**: Matching the pirate theme from the designs provided

Files needed:
- `skull_pirate.png` - Undead captain with burning gaze
- `quartermaster.png` - Rugged pirate with hook hand
- `ghost_captain.png` - Spectral pirate with spooky grin
- `salty_turtle.png` - Anthropomorphic sea turtle
- `vampire_pirate.png` - Undead bloodsucker with fangs
- `elf_swashbuckler.png` - Daring elf with bat wings

### Token Icons
**Location**: `assets/images/tokens/`
**Format**: PNG with transparency
**Size**: 256x256px
**Style**: Circular medallion style with ornate borders

Files needed:
- `ship_5.png` - Sailing ship (5 point value)
- `ghost.png` - Ghost figure
- `fort_10.png` - Fort/castle (10 point value)
- `cannon.png` - Historical cannon
- `star.png` - Achievement star
- `coin_1.png` - 1 point coin
- `coin_10.png` - 10 point coin
- `coin_25.png` - 25 point coin
- `coin_50.png` - 50 point coin
- `pitcher.png` - Historical pitcher/jug
- `lion.png` - Lion head (Bridge of Lions)
- `coins_stack.png` - Stack of gold coins

### Background Textures
**Location**: `assets/images/backgrounds/`
**Format**: JPG or PNG
**Size**: 1080x1920px minimum
**Style**: Vintage parchment aesthetic

Files needed:
- `parchment_texture.png` - Old paper texture for screens
- `home_screen_bg.png` - Main logo background
- `teal_pattern.png` - Dark teal background pattern

### Business Icons
**Location**: `assets/images/business_icons/`
**Format**: PNG with transparency
**Size**: 128x128px
**Style**: Matching the token design aesthetic

Files needed:
- `coffee.png` - Coffee cup (Crucial Coffee)
- `turtle.png` - Turtle icon (Salty Turtle)
- `candy.png` - Candy/sweets (The Sweet Spot)
- `chest.png` - Treasure chest (Pirate's Cove)
- `mug.png` - Beer mug (Colonial Tavern)

### UI Elements
**Location**: `assets/images/ui/`
**Format**: PNG with transparency
**Various sizes**

Files needed:
- `logo.png` - Saint Hunt main logo (1024x1024px)
- `ribbon_banner.png` - Decorative ribbon for buttons
- `ornate_frame.png` - Decorative border frame
- `scrollwork.png` - Corner decorations

### Map Markers
**Location**: `assets/images/map/`
**Format**: PNG with transparency
**Size**: 96x96px
**Style**: Custom pins matching theme

Files needed:
- `marker_active.png` - Red/orange marker for unlocked locations
- `marker_completed.png` - Green marker for completed locations
- `marker_locked.png` - Gray marker for locked locations

## 🔤 Fonts

### Required Fonts
**Location**: `assets/fonts/`

1. **Cinzel** (for body text)
   - `Cinzel-Regular.ttf`
   - `Cinzel-Bold.ttf`
   - Download: https://fonts.google.com/specimen/Cinzel

2. **Cinzel Decorative** (for headings)
   - `CinzelDecorative-Bold.ttf`
   - Download: https://fonts.google.com/specimen/Cinzel+Decorative

### Installation
```bash
# Download fonts from Google Fonts
# Place in assets/fonts/
# Already configured in pubspec.yaml
```

## 📱 App Icons

### Android
**Location**: `android/app/src/main/res/`

Sizes needed:
- `mipmap-mdpi/ic_launcher.png` (48x48px)
- `mipmap-hdpi/ic_launcher.png` (72x72px)
- `mipmap-xhdpi/ic_launcher.png` (96x96px)
- `mipmap-xxhdpi/ic_launcher.png` (144x144px)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192px)

**Design**: Saint Hunt logo/icon on transparent or themed background

### iOS
**Location**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Sizes needed (all PNG):
- 20x20, 29x29, 40x40, 58x58, 60x60, 76x76, 80x80, 87x87, 120x120, 152x152, 167x167, 180x180, 1024x1024

**Tool**: Use https://appicon.co/ to generate all sizes

## 🎨 Design Guidelines

### Color Palette
Use the colors defined in `lib/utils/constants.dart`:
- **Dark Teal**: #1A3A3A (backgrounds, accents)
- **Parchment**: #F5E6D3 (main background)
- **Gold**: #D4A574 (text, borders)
- **Brown Text**: #3D2817 (body text)
- **Scrollwork Brown**: #5C4033 (decorative elements)

### Style Consistency
- **Vintage Theme**: All assets should match the aged, historical aesthetic
- **Pirate Era**: 17th-18th century Spanish colonial style
- **Hand-drawn Look**: Slightly weathered, not too modern
- **Consistent Borders**: Token and icon designs use similar ornamental borders

## 🖼️ Creating Assets

### Option 1: Use Provided Designs
The user has provided design mockups for:
- Home screen logo
- Sign up screen layout
- Character designs
- Token designs
- Wallet screen

Extract these images and place them in the appropriate folders.

### Option 2: Generate with AI
Use AI image generation tools like:
- Midjourney
- DALL-E
- Stable Diffusion

**Prompt example**:
```
"pirate character avatar, vintage style, aged parchment aesthetic, 
circular frame with ornate gold border, dark teal background, 
17th century Spanish colonial theme"
```

### Option 3: Commission Artist
Hire a digital artist familiar with:
- Game UI design
- Historical/pirate themes
- Mobile app assets

## 📝 Asset Checklist

Before deployment, ensure:
- [ ] All 6 character images added
- [ ] All 12 token icons added
- [ ] Background textures added
- [ ] Business icons for all 5 partners
- [ ] Logo and UI elements
- [ ] Map markers (3 types)
- [ ] Fonts downloaded and placed
- [ ] Android app icons (all sizes)
- [ ] iOS app icons (all sizes)
- [ ] Splash screens for both platforms

## 🔧 Testing Assets

After adding assets:

1. **Run the app** and verify images load
2. **Check character selection** screen shows all avatars
3. **View wallet screen** and check token display
4. **Test on different screen sizes**
5. **Verify app icon** on home screen
6. **Check splash screen** on app launch

## 💾 Optimization

Before deployment, optimize all images:

### PNG Optimization
```bash
# Install pngquant
brew install pngquant  # Mac
sudo apt install pngquant  # Linux

# Optimize all PNGs
find assets -name "*.png" -exec pngquant --ext .png --force {} \;
```

### Image Size Guidelines
- Characters: < 200KB each
- Tokens: < 50KB each
- Backgrounds: < 500KB each
- Icons: < 20KB each

## 📤 Exporting from Design Tools

### From Figma
1. Select asset
2. Export settings: PNG, 2x or 3x
3. Export
4. Place in appropriate folder

### From Photoshop
1. File → Export → Export As
2. Format: PNG-24
3. Uncheck "Convert to sRGB" if using specific colors
4. Export

### From Illustrator
1. File → Export → Export for Screens
2. Format: PNG
3. Scale: 1x, 2x, 3x (export all)
4. Export

## 🆘 Need Help?

If you need assistance with:
- **Asset creation**: Consider hiring a designer on Fiverr or Upwork
- **Icon generation**: Use https://www.flaticon.com/ for placeholder icons
- **Font licenses**: Verify Google Fonts are free for commercial use

---

**Note**: The app will run without these assets, but will show placeholder icons and default fonts. Add assets progressively as they become available.

