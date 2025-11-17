import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/location_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../wallet/wallet_screen.dart';
import 'riddle_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;
  List<LocationModel> _locations = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
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

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Location services are disabled. Please enable them.');
      return;
    }

    // Check for location permissions
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

    // Get current location
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (mounted) {
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      // Move camera to user location
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    }

    // Listen to location changes
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      if (mounted) {
        setState(() => _currentPosition = position);
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

    // Add location markers
    for (var location in _locations) {
      final isCompleted = _currentUser?.completedLocations.contains(location.id) ?? false;
      
      _markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: location.coordinates,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isCompleted ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: isCompleted ? 'Completed' : 'Tap to view',
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
      // Skip if already completed
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
      _showInfo('You\'ve already completed this location!');
      return;
    }

    if (location.isWithinRange(userLocation)) {
      _navigateToRiddle(location);
    } else {
      _showInfo('Get closer to unlock this location!');
    }
  }

  void _showLocationUnlocked(LocationModel location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Location Unlocked!',
          style: TextStyle(
            fontFamily: AppConstants.headingFont,
            color: AppConstants.brownText,
          ),
        ),
        content: Text(
          'You\'ve reached ${location.name}. Ready to solve the riddle?',
          style: TextStyle(
            fontFamily: AppConstants.bodyFont,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToRiddle(location);
            },
            child: const Text('Solve Riddle'),
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
      // Reload user data after returning
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
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
                    zoom: AppConstants.defaultMapZoom,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    // Apply custom map style here if needed
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
                  circles: {
                    Circle(
                      circleId: const CircleId('game_area'),
                      center: AppConstants.centerPoint,
                      radius: AppConstants.radiusMeters,
                      fillColor: AppConstants.darkTeal.withOpacity(0.1),
                      strokeColor: AppConstants.darkTeal,
                      strokeWidth: 2,
                    ),
                  },
                  minMaxZoomPreference: const MinMaxZoomPreference(
                    AppConstants.minMapZoom,
                    AppConstants.maxMapZoom,
                  ),
                ),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppConstants.darkTeal,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      'SAINT HUNT',
                      style: TextStyle(
                        fontFamily: AppConstants.headingFont,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.gold,
                        letterSpacing: 1.5,
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
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.scrollworkBrown,
                          borderRadius: BorderRadius.circular(20),
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
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_currentUser?.tokenBalance ?? 0}',
                              style: TextStyle(
                                fontFamily: AppConstants.bodyFont,
                                fontSize: 16,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

