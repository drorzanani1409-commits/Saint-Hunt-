# Saint Hunt - Automated Setup Script
# Run this after installing Flutter

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   SAINT HUNT - Automated Setup" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Green
$flutterPath = Get-Command flutter -ErrorAction SilentlyContinue

if (-not $flutterPath) {
    Write-Host "❌ Flutter is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Flutter first:" -ForegroundColor Yellow
    Write-Host "1. Go to: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
    Write-Host "2. Download and extract Flutter SDK" -ForegroundColor White
    Write-Host "3. Add to PATH" -ForegroundColor White
    Write-Host "4. Run this script again" -ForegroundColor White
    Write-Host ""
    Write-Host "Or follow the complete guide in INSTALL.md" -ForegroundColor Cyan
    exit 1
}

Write-Host "✅ Flutter found at: $($flutterPath.Source)" -ForegroundColor Green
Write-Host ""

# Run Flutter Doctor
Write-Host "Running Flutter Doctor..." -ForegroundColor Green
flutter doctor
Write-Host ""

# Check if in correct directory
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Not in Saint Hunt directory!" -ForegroundColor Red
    Write-Host "Please run this script from: C:\Users\drorz\saint_hunt" -ForegroundColor Yellow
    exit 1
}

# Install dependencies
Write-Host "Installing Flutter dependencies..." -ForegroundColor Green
flutter pub get

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencies installed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Setup Status" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Firebase config files
$firebaseAndroid = Test-Path "android/app/google-services.json"
$firebaseIOS = Test-Path "ios/Runner/GoogleService-Info.plist"

Write-Host "Firebase Configuration:" -ForegroundColor Yellow
if ($firebaseAndroid) {
    Write-Host "  ✅ Android: google-services.json found" -ForegroundColor Green
} else {
    Write-Host "  ❌ Android: google-services.json MISSING" -ForegroundColor Red
    Write-Host "     Get it from: https://console.firebase.google.com/" -ForegroundColor White
}

if ($firebaseIOS) {
    Write-Host "  ✅ iOS: GoogleService-Info.plist found" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  iOS: GoogleService-Info.plist MISSING (OK if Android only)" -ForegroundColor Yellow
}

Write-Host ""

# Check for API keys in code
$constantsFile = Get-Content "lib/utils/constants.dart" -Raw
$hasApiKey = $constantsFile -match "AIza[a-zA-Z0-9_-]{35}"

Write-Host "Google Maps API Key:" -ForegroundColor Yellow
if ($hasApiKey) {
    Write-Host "  ✅ API key detected in constants.dart" -ForegroundColor Green
} else {
    Write-Host "  ❌ API key NOT SET" -ForegroundColor Red
    Write-Host "     1. Get key from: https://console.cloud.google.com/" -ForegroundColor White
    Write-Host "     2. Edit: lib/utils/constants.dart" -ForegroundColor White
    Write-Host "     3. Replace: YOUR_GOOGLE_MAPS_API_KEY" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Next Steps" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not $firebaseAndroid -or -not $hasApiKey) {
    Write-Host "⚠️  Configuration incomplete!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Before running the app, you need to:" -ForegroundColor White
    Write-Host ""
    
    if (-not $firebaseAndroid) {
        Write-Host "1. Set up Firebase:" -ForegroundColor Yellow
        Write-Host "   - Create project at https://console.firebase.google.com/" -ForegroundColor White
        Write-Host "   - Download google-services.json" -ForegroundColor White
        Write-Host "   - Place in: android/app/google-services.json" -ForegroundColor White
        Write-Host "   - See: firebase/SETUP_GUIDE.md for details" -ForegroundColor Cyan
        Write-Host ""
    }
    
    if (-not $hasApiKey) {
        Write-Host "2. Add Google Maps API key:" -ForegroundColor Yellow
        Write-Host "   - Get key from https://console.cloud.google.com/" -ForegroundColor White
        Write-Host "   - Edit lib/utils/constants.dart" -ForegroundColor White
        Write-Host "   - Edit android/app/src/main/AndroidManifest.xml" -ForegroundColor White
        Write-Host "   - See: INSTALL.md for details" -ForegroundColor Cyan
        Write-Host ""
    }
    
    Write-Host "Then run: flutter run" -ForegroundColor Green
} else {
    Write-Host "✅ Configuration looks good!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Ready to run the app!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Cyan
    Write-Host "  flutter run          - Run on connected device/emulator" -ForegroundColor White
    Write-Host "  flutter run -d chrome - Run in web browser" -ForegroundColor White
    Write-Host "  flutter devices      - List available devices" -ForegroundColor White
    Write-Host ""
    
    $response = Read-Host "Do you want to run the app now? (y/n)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        Write-Host ""
        Write-Host "Starting app..." -ForegroundColor Green
        flutter run
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "For detailed help, see:" -ForegroundColor Yellow
Write-Host "  - INSTALL.md (complete installation guide)" -ForegroundColor White
Write-Host "  - QUICKSTART.md (15-min setup)" -ForegroundColor White
Write-Host "  - firebase/SETUP_GUIDE.md (Firebase config)" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🏴‍☠️ Happy Hunting! ⚓" -ForegroundColor Yellow

