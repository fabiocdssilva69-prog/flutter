import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

/// Serviço de localização

class LocationService {
  static LocationService? _instance;
  StreamSubscription<Position>? _positionStream;

  LocationService._();

  static LocationService getInstance() {
    _instance ??= LocationService._();
    return _instance!;
  }

  // ============================================
  // PERMISSIONS
  // ============================================

  Future<bool> hasPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<LocationPermissionResult> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied) {
        return LocationPermissionResult.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionResult.permanentlyDenied;
    }

    return LocationPermissionResult.granted;
  }

  // ============================================
  // CURRENT LOCATION
  // ============================================

  Future<Position?> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeLimit,
  }) async {
    try {
      final hasPermission = await this.hasPermission();
      if (!hasPermission) {
        final result = await requestPermission();
        if (result != LocationPermissionResult.granted) {
          return null;
        }
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeLimit,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // LOCATION STREAMING
  // ============================================

  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // meters
    Duration? timeInterval,
  }) {
    final locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
      timeLimit: timeInterval,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  void startLocationUpdates({
    required void Function(Position position) onLocationUpdate,
    void Function(Object error)? onError,
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    _positionStream?.cancel();
    
    _positionStream = getPositionStream(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    ).listen(
      onLocationUpdate,
      onError: onError,
    );
  }

  void stopLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  // ============================================
  // DISTANCE CALCULATION
  // ============================================

  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(
      startLat,
      startLng,
      endLat,
      endLng,
    ) / 1000; // Convert to kilometers
  }

  double calculateBearing(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.bearingBetween(
      startLat,
      startLng,
      endLat,
      endLng,
    );
  }

  // ============================================
  // GEOCODING
  // ============================================

  Future<List<Placemark>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      return await placemarkFromCoordinates(latitude, longitude);
    } catch (e) {
      return [];
    }
  }

  Future<String> getFormattedAddress(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await getAddressFromCoordinates(latitude, longitude);
      
      if (placemarks.isEmpty) {
        return 'Endereço desconhecido';
      }

      final place = placemarks.first;
      final parts = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
      ].where((p) => p != null && p.isNotEmpty);

      return parts.join(', ');
    } catch (e) {
      return 'Endereço desconhecido';
    }
  }

  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      return [];
    }
  }

  // ============================================
  // LOCATION SERVICES
  // ============================================

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // ============================================
  // HELPERS
  // ============================================

  Future<UserLocation?> getUserLocation() async {
    final position = await getCurrentPosition();
    if (position == null) return null;

    final address = await getFormattedAddress(
      position.latitude,
      position.longitude,
    );

    return UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      timestamp: position.timestamp,
    );
  }

  bool isWithinRadius({
    required double centerLat,
    required double centerLng,
    required double targetLat,
    required double targetLng,
    required double radiusKm,
  }) {
    final distance = calculateDistance(
      centerLat,
      centerLng,
      targetLat,
      targetLng,
    );

    return distance <= radiusKm;
  }

  Future<void> dispose() async {
    stopLocationUpdates();
  }
}

// ============================================
// MODELS
// ============================================

class UserLocation {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime timestamp;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      address: map['address'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}

enum LocationPermissionResult {
  granted,
  denied,
  permanentlyDenied,
}
