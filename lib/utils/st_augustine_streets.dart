import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Real St. Augustine street data based on actual coordinates
/// This matches the streets shown in your map images
class StAugustineStreets {
  // Historic Downtown St. Augustine - Real Coordinates
  
  // Main landmarks from your map
  static const LatLng castilloDeS

anMarcos = LatLng(29.8981, -81.3124);
  static const LatLng stGeorgeStreetCenter = LatLng(29.8947, -81.3124);
  static const LatLng oldCityGate = LatLng(29.8975, -81.3140);
  static const LatLng fountainOfYouth = LatLng(29.9012, -81.3107);
  static const LatLng colonialQuarter = LatLng(29.8956, -81.3132);
  static const LatLng bridgeOfLions = LatLng(29.8934, -81.3089);
  static const LatLng stFrancisBarracks = LatLng(29.8965, -81.3128);
  static const LatLng flaglerCollege = LatLng(29.8917, -81.3142);
  static const LatLng oldestWoodenSchool = LatLng(29.8902, -81.3135);
  static const LatLng lighthouse = LatLng(29.8807, -81.2886);
  static const LatLng matanzasRiver = LatLng(29.8900, -81.3050);
  
  // Real Street Names and Coordinates
  static const List<Street> streets = [
    // St. George Street (main pedestrian street)
    Street(
      name: 'St. George Street',
      coordinates: [
        LatLng(29.8980, -81.3125),
        LatLng(29.8947, -81.3124),
        LatLng(29.8920, -81.3123),
      ],
      type: StreetType.pedestrian,
    ),
    
    // Charlotte Street
    Street(
      name: 'Charlotte Street',
      coordinates: [
        LatLng(29.8970, -81.3140),
        LatLng(29.8947, -81.3139),
        LatLng(29.8920, -81.3138),
      ],
      type: StreetType.road,
    ),
    
    // Treasury Street
    Street(
      name: 'Treasury Street',
      coordinates: [
        LatLng(29.8965, -81.3150),
        LatLng(29.8965, -81.3120),
      ],
      type: StreetType.road,
    ),
    
    // King Street
    Street(
      name: 'King Street',
      coordinates: [
        LatLng(29.8950, -81.3150),
        LatLng(29.8950, -81.3120),
      ],
      type: StreetType.road,
    ),
    
    // Hypolita Street
    Street(
      name: 'Hypolita Street',
      coordinates: [
        LatLng(29.8945, -81.3150),
        LatLng(29.8945, -81.3120),
      ],
      type: StreetType.road,
    ),
    
    // Cathedral Place
    Street(
      name: 'Cathedral Place',
      coordinates: [
        LatLng(29.8940, -81.3150),
        LatLng(29.8940, -81.3120),
      ],
      type: StreetType.road,
    ),
    
    // St. Francis Street
    Street(
      name: 'St. Francis Street',
      coordinates: [
        LatLng(29.8930, -81.3150),
        LatLng(29.8930, -81.3120),
      ],
      type: StreetType.road,
    ),
    
    // Bridge Street (near Bridge of Lions)
    Street(
      name: 'Bridge Street',
      coordinates: [
        LatLng(29.8935, -81.3130),
        LatLng(29.8935, -81.3089),
      ],
      type: StreetType.road,
    ),
    
    // Avenida Menendez (waterfront)
    Street(
      name: 'Avenida Menendez',
      coordinates: [
        LatLng(29.8990, -81.3090),
        LatLng(29.8960, -81.3095),
        LatLng(29.8930, -81.3100),
        LatLng(29.8900, -81.3105),
      ],
      type: StreetType.waterfront,
    ),
    
    // Cordova Street
    Street(
      name: 'Cordova Street',
      coordinates: [
        LatLng(29.8980, -81.3145),
        LatLng(29.8950, -81.3145),
        LatLng(29.8920, -81.3145),
        LatLng(29.8890, -81.3145),
      ],
      type: StreetType.road,
    ),
    
    // Granada Street
    Street(
      name: 'Granada Street',
      coordinates: [
        LatLng(29.8920, -81.3150),
        LatLng(29.8920, -81.3120),
      ],
      type: StreetType.road,
    ),
    
    // Valencia Street
    Street(
      name: 'Valencia Street',
      coordinates: [
        LatLng(29.8910, -81.3150),
        LatLng(29.8910, -81.3120),
      ],
      type: StreetType.road,
    ),
  ];
  
  // Business locations from your map
  static const List<BusinessLocation> businesses = [
    BusinessLocation(
      name: 'Crucial Coffee',
      coordinates: LatLng(29.8950, -81.3128),
      icon: '☕',
    ),
    BusinessLocation(
      name: 'Salty Turtle',
      coordinates: LatLng(29.8945, -81.3115),
      icon: '🐢',
    ),
    BusinessLocation(
      name: 'The Sweet Spot',
      coordinates: LatLng(29.8952, -81.3130),
      icon: '🍭',
    ),
    BusinessLocation(
      name: 'Pirate\'s Cove Souvenirs',
      coordinates: LatLng(29.8958, -81.3125),
      icon: '🏴‍☠️',
    ),
    BusinessLocation(
      name: 'Colonial Tavern',
      coordinates: LatLng(29.8940, -81.3132),
      icon: '🍺',
    ),
  ];
  
  // Historical markers from your map
  static const List<HistoricalMarker> historicalMarkers = [
    HistoricalMarker(
      name: 'Castillo de San Marcos',
      coordinates: castilloDeSanMarcos,
      icon: '🏰',
      description: 'Oldest masonry fort in continental US',
    ),
    HistoricalMarker(
      name: 'Old City Gate',
      coordinates: oldCityGate,
      icon: '⛩️',
      description: 'Historic entrance to colonial city',
    ),
    HistoricalMarker(
      name: 'Fountain of Youth',
      coordinates: fountainOfYouth,
      icon: '⛲',
      description: 'Archaeological park',
    ),
    HistoricalMarker(
      name: 'Colonial Quarter',
      coordinates: colonialQuarter,
      icon: '🏘️',
      description: 'Living history museum',
    ),
    HistoricalMarker(
      name: 'Bridge of Lions',
      coordinates: bridgeOfLions,
      icon: '🦁',
      description: 'Iconic drawbridge with marble lions',
    ),
    HistoricalMarker(
      name: 'St. Augustine Lighthouse',
      coordinates: lighthouse,
      icon: '🗼',
      description: '165-foot lighthouse from 1874',
    ),
  ];
  
  // Get nearest street to a coordinate
  static Street? getNearestStreet(LatLng location) {
    double minDistance = double.infinity;
    Street? nearest;
    
    for (var street in streets) {
      for (var coord in street.coordinates) {
        final distance = _calculateDistance(location, coord);
        if (distance < minDistance) {
          minDistance = distance;
          nearest = street;
        }
      }
    }
    
    return nearest;
  }
  
  // Calculate distance between two coordinates
  static double _calculateDistance(LatLng pos1, LatLng pos2) {
    const double earthRadius = 6371000; // meters
    final lat1 = pos1.latitude * 0.017453292519943295;
    final lat2 = pos2.latitude * 0.017453292519943295;
    final deltaLat = (pos2.latitude - pos1.latitude) * 0.017453292519943295;
    final deltaLng = (pos2.longitude - pos1.longitude) * 0.017453292519943295;
    
    final a = (deltaLat / 2).abs() * (deltaLat / 2).abs() +
        lat1.abs() * lat2.abs() * (deltaLng / 2).abs() * (deltaLng / 2).abs();
    final c = 2 * (a.abs().clamp(0, 1));
    
    return earthRadius * c;
  }
}

class Street {
  final String name;
  final List<LatLng> coordinates;
  final StreetType type;
  
  const Street({
    required this.name,
    required this.coordinates,
    required this.type,
  });
}

enum StreetType {
  pedestrian,
  road,
  waterfront,
}

class BusinessLocation {
  final String name;
  final LatLng coordinates;
  final String icon;
  
  const BusinessLocation({
    required this.name,
    required this.coordinates,
    required this.icon,
  });
}

class HistoricalMarker {
  final String name;
  final LatLng coordinates;
  final String icon;
  final String description;
  
  const HistoricalMarker({
    required this.name,
    required this.coordinates,
    required this.icon,
    required this.description,
  });
}

