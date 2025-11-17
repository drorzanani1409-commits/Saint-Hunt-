import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../../models/location_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../wallet/wallet_screen.dart';
import 'riddle_screen.dart';

class MapScreen3D extends StatefulWidget {
  const MapScreen3D({Key? key}) : super(key: key);

  @override
  State<MapScreen3D> createState() => _MapScreen3DState();
}

class _MapScreen3DState extends State<MapScreen3D> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;
  List<LocationModel> _locations = [];
  BitmapDescriptor? _userMarkerIcon;
  BitmapDescriptor? _activeMarkerIcon;
  BitmapDescriptor? _completedMarkerIcon;
  BitmapDescriptor? _lockedMarkerIcon;

  // 3D Map Settings (Pokemon GO style)
  static const double _tilt = 45.0; // Viewing angle
  static const double _bearing = 0.0; // Rotation
  static const double _zoom = 17.0; // Closer zoom for 3D effect

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers();
    _initializeMap();
  }

  Future<void> _loadCustomMarkers() async {
    // Load custom marker icons
    _activeMarkerIcon = await _createCustomMarker(Colors.red, '📍');
    _completedMarkerIcon = await _createCustomMarker(Colors.green, '✓');
    _lockedMarkerIcon = await _createCustomMarker(Colors.grey, '🔒');
    _userMarkerIcon = await _createUserMarker();
  }

  Future<BitmapDescriptor> _createCustomMarker(Color color, String icon) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;
    
    // Draw circular background
    canvas.drawCircle(const Offset(50, 50), 40, paint);
    
    // Draw border
    paint
      ..color = AppConstants.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(const Offset(50, 50), 40, paint);
    
    // Draw pointer at bottom
    final Path path = Path();
    path.moveTo(50, 90);
    path.lineTo(35, 70);
    path.lineTo(65, 70);
    path.close();
    paint.style = PaintingStyle.fill;
    paint.color = color;
    canvas.drawPath(path, paint);
    
    // Draw icon text
    final textPainter = TextPainter(
      text: TextSpan(
        text: icon,
        style: const TextStyle(fontSize: 30, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(35, 35));
    
    final img = await pictureRecorder.endRecording().toImage(100, 100);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createUserMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    
    // Draw pulsing circle (user location)
    final Paint paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(30, 30), 28, paint);
    
    paint.color = Colors.blue;
    canvas.drawCircle(const Offset(30, 30), 20, paint);
    
    paint.color = Colors.white;
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(30, 30), 20, paint);
    
    final img = await pictureRecorder.endRecording().toImage(60, 60);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> _initializeMap() async {
    await _loadUserData();
    await _getCurrentLocation();
    await _loadLocations();
    _checkProximityToLocations();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      final userData = await _authService.getUserData(user.uid);
      if (mounted) {
        setState(() => _currentUser = userData);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Location services are disabled. Please enable them.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError('Location permissions are permanently denied');
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (mounted) {
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      // Animate to user location with 3D tilt
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: _zoom,
            tilt: _tilt,
            bearing: _bearing,
          ),
        ),
      );
    }

    // Listen to location changes and update bearing based on movement
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      if (mounted && _currentPosition != null) {
        // Calculate bearing based on movement direction
        final bearing = Geolocator.bearingBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        
        setState(() => _currentPosition = position);
        
        // Update camera to follow user with rotation
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: _zoom,
              tilt: _tilt,
              bearing: bearing,
            ),
          ),
        );
        
        _checkProximityToLocations();
      }
    });
  }

  Future<void> _loadLocations() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .where('isActive', isEqualTo: true)
          .get();

      final locations = querySnapshot.docs
          .map((doc) => LocationModel.fromFirestore(doc))
          .toList();

      if (mounted) {
        setState(() {
          _locations = locations;
          _createMarkers();
        });
      }
    } catch (e) {
      print('Error loading locations: $e');
    }
  }

  void _createMarkers() {
    _markers.clear();

    // Add location markers with custom icons
    for (var location in _locations) {
      final isCompleted = _currentUser?.completedLocations.contains(location.id) ?? false;
      final isNearby = _currentPosition != null && 
          location.isWithinRange(LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
      
      BitmapDescriptor icon;
      if (isCompleted) {
        icon = _completedMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      } else if (isNearby) {
        icon = _activeMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      } else {
        icon = _lockedMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      }
      
      _markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: location.coordinates,
          icon: icon,
          anchor: const Offset(0.5, 1.0), // Bottom center
          infoWindow: InfoWindow(
            title: location.name,
            snippet: isCompleted ? '✅ Completed' : isNearby ? '📍 Nearby - Tap to unlock!' : '🔒 Get closer to unlock',
          ),
          onTap: () => _onLocationMarkerTapped(location),
        ),
      );
    }
  }

  void _checkProximityToLocations() {
    if (_currentPosition == null || _currentUser == null) return;

    final userLocation = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    for (var location in _locations) {
      if (_currentUser!.completedLocations.contains(location.id)) {
        continue;
      }

      if (location.isWithinRange(userLocation)) {
        _showLocationUnlocked(location);
      }
    }
  }

  void _onLocationMarkerTapped(LocationModel location) {
    if (_currentPosition == null) return;

    final userLocation = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    final isCompleted = _currentUser?.completedLocations.contains(location.id) ?? false;

    if (isCompleted) {
      _showInfo('You\'ve already completed this location! ✅');
      return;
    }

    if (location.isWithinRange(userLocation)) {
      _navigateToRiddle(location);
    } else {
      final distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        location.coordinates.latitude,
        location.coordinates.longitude,
      );
      _showInfo('Get ${(distance - location.triggerRadius).round()}m closer to unlock! 🚶');
    }
  }

  void _showLocationUnlocked(LocationModel location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.parchment,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppConstants.scrollworkBrown, width: 3),
        ),
        title: Row(
          children: [
            const Text('🎯 ', style: TextStyle(fontSize: 24)),
            Expanded(
              child: Text(
                'Location Unlocked!',
                style: TextStyle(
                  fontFamily: AppConstants.headingFont,
                  color: AppConstants.brownText,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'You\'ve reached ${location.name}. Ready to solve the riddle?',
          style: TextStyle(
            fontFamily: AppConstants.bodyFont,
            color: AppConstants.brownText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.scrollworkBrown,
            ),
            onPressed: () {
              Navigator.pop(context);
              _navigateToRiddle(location);
            },
            child: Text(
              'Solve Riddle',
              style: TextStyle(color: AppConstants.gold),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToRiddle(LocationModel location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RiddleScreen(location: location),
      ),
    ).then((_) {
      _loadUserData();
      _createMarkers();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF8B0000),
      ),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.darkTeal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 3D Map
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.darkTeal,
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          )
                        : AppConstants.centerPoint,
                    zoom: _zoom,
                    tilt: _tilt,
                    bearing: _bearing,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    // Apply custom vintage map style
                    _applyVintageMapStyle(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  markers: _markers,
                  buildingsEnabled: true, // Show 3D buildings
                  minMaxZoomPreference: const MinMaxZoomPreference(15, 20),
                  mapType: MapType.normal,
                ),

          // Top Bar with vintage design
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppConstants.darkTeal,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppConstants.gold, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      'SAINT HUNT',
                      style: TextStyle(
                        fontFamily: AppConstants.headingFont,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.gold,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WalletScreen(),
                          ),
                        ).then((_) => _loadUserData());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.scrollworkBrown,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: AppConstants.gold,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.stars,
                              color: AppConstants.gold,
                              size: 22,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${_currentUser?.tokenBalance ?? 0}',
                              style: TextStyle(
                                fontFamily: AppConstants.bodyFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Compass indicator
          Positioned(
            top: 120,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.parchment.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(color: AppConstants.scrollworkBrown, width: 2),
              ),
              child: Icon(
                Icons.navigation,
                color: AppConstants.darkTeal,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyVintageMapStyle(GoogleMapController controller) {
    // Custom vintage map style (similar to your images)
    const String mapStyle = '''
    [
      {
        "elementType": "geometry",
        "stylers": [{"color": "#d4c5a8"}]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#5c4033"}]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [{"color": "#f5e6d3"}]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [{"color": "#7ba3a3"}]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [{"color": "#b8a588"}]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [{"color": "#a8b895"}]
      }
    ]
    ''';
    
    controller.setMapStyle(mapStyle);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

