import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart'; // NOVO: Sprint 24

/// Hook para converter DateTime <-> Firestore Timestamp
///
/// **Compatível com Web (Firestore JS)**
///
/// O Firestore Web retorna Timestamps como Maps com estrutura:
/// ```json
/// {
///   "_seconds": 1234567890,
///   "_nanoseconds": 123456789
/// }
/// ```
///
/// Este hook detecta e converte automaticamente para DateTime.
///
/// **Uso nas Entidades:**
/// ```dart
/// @MappableClass()
/// class MyEntity with MyEntityMappable {
///   @MappableField(hook: TimestampHook())
///   final DateTime createdAt;
///
///   @MappableField(hook: TimestampHook())
///   final DateTime? updatedAt;
/// }
/// ```
class TimestampHook extends MappingHook {
  const TimestampHook();

  @override
  Object? beforeDecode(Object? value) {
    // CRÍTICO: Intercepta ANTES do dart_mappable tentar decodificar
    // Converte Timestamp para DateTime ANTES da validação de tipo

    // FIX PARA ANDROID/IOS: Caso o valor seja DateTime, retorna direto
    if (value is DateTime) {
      return value;
    }

    // Converte Timestamp para DateTime ao receber do Firestore
    if (value is Timestamp) {
      return value.toDate();
    }

    // FIX CRUCIAL PARA WEB (P1):
    // No Flutter Web, o Firestore JS pode retornar Timestamps como um Map { _seconds, _nanoseconds }.
    if (kIsWeb && value is Map<String, dynamic>) {
      if (value.containsKey('_seconds') && value.containsKey('_nanoseconds')) {
        try {
          final seconds = value['_seconds'];
          final nanoseconds = value['_nanoseconds'];
          // Garante que os valores são numéricos antes da conversão
          if (seconds is num && nanoseconds is num) {
            return Timestamp(seconds.toInt(), nanoseconds.toInt()).toDate();
          }
        } catch (e) {
          debugPrint("TimestampHook failed to convert map: $e");
        }
      }
    }

    // FIX ADICIONAL: Se for String ou num (como aparece no erro), tenta converter
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        debugPrint("TimestampHook failed to parse string: $e");
      }
    }

    if (value is num) {
      try {
        // Assume que é timestamp em milliseconds
        return DateTime.fromMillisecondsSinceEpoch(value.toInt());
      } catch (e) {
        debugPrint("TimestampHook failed to parse num: $e");
      }
    }

    // FALLBACK CRÍTICO: Se receber Timestamp sem conversão, força toDate()
    try {
      if (value != null && value.toString().contains('Timestamp')) {
        // Tenta acessar método toDate() via reflexão
        final dynamic timestampValue = value;
        return (timestampValue as Timestamp).toDate();
      }
    } catch (e) {
      debugPrint("TimestampHook fallback conversion failed: $e");
    }

    return value;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is DateTime) {
      // Converte DateTime para Timestamp ao enviar para o Firestore
      return Timestamp.fromDate(value);
    }
    return value;
  }
}

/// Hook para converter GeoFirePoint <-> Map (Formato padrão do GeoFlutterFirePlus)
///
/// **Sprint 24: Geolocalização**
///
/// O GeoFlutterFirePlus armazena dados de geolocalização no Firestore como:
/// ```json
/// {
///   "geopoint": GeoPoint(latitude, longitude),
///   "geohash": "u4pruydqqvj"
/// }
/// ```
///
/// Este hook automatiza a conversão bidirecional.
///
/// **Uso nas Entidades:**
/// ```dart
/// @MappableClass()
/// class VacancyEntity with VacancyEntityMappable {
///   @MappableField(hook: GeoFirePointHook())
///   final GeoFirePoint? location;
/// }
/// ```
/// Hook para converter GeoFirePoint <-> Map<String, dynamic>
///
/// **Uso:**
/// ```dart
/// @MappableClass()
/// class ProfileEntity with ProfileEntityMappable {
///   @MappableField(hook: GeoFirePointHook())
///   final Map<String, dynamic>? preciseLocation;
/// }
/// ```
class GeoFirePointHook extends MappingHook {
  const GeoFirePointHook();

  @override
  Object? beforeEncode(Object? value) {
    // Se já é Map (formato armazenado), retorna direto
    if (value is Map<String, dynamic>) return value;

    // Se for GeoFirePoint, converte para Map
    if (value is GeoFirePoint) {
      return value.data;
    }

    return null;
  }

  @override
  Object? afterDecode(Object? value) {
    // Aceita null explicitamente (campo opcional)
    if (value == null) return null;

    // Retorna Map diretamente (não converte para GeoFirePoint aqui)
    // A conversão será feita via getter no ProfileEntity
    if (value is Map<String, dynamic>) {
      return value;
    }

    // Retorna nulo se o formato for inválido
    return null;
  }
}
