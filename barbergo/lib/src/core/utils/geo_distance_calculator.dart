import 'dart:math' show asin, cos, pi, sin, sqrt;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Calcula a distância em km entre dois pontos usando fórmula de Haversine
class GeoDistanceCalculator {
  static const double earthRadiusKm = 6371.0;

  /// Calcula distância entre dois GeoPoints
  static double calculateDistance(GeoPoint point1, GeoPoint point2) {
    final lat1 = _toRadians(point1.latitude);
    final lon1 = _toRadians(point1.longitude);
    final lat2 = _toRadians(point2.latitude);
    final lon2 = _toRadians(point2.longitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = _haversin(dLat) + cos(lat1) * cos(lat2) * _haversin(dLon);
    final c = 2 * asin(sqrt(a));

    return earthRadiusKm * c;
  }

  /// Formata distância para exibição (ex: "2.5 km", "850 m")
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m';
    } else if (distanceKm < 10) {
      return '${distanceKm.toStringAsFixed(1)} km';
    } else {
      return '${distanceKm.round()} km';
    }
  }

  static double _toRadians(double degrees) => degrees * pi / 180;

  static double _haversin(double theta) {
    final sinHalfTheta = sin(theta / 2);
    return sinHalfTheta * sinHalfTheta;
  }
}
