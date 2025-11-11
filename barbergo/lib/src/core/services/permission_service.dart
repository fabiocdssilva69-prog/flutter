import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

/// Serviço de gerenciamento de permissões

class PermissionService {
  static PermissionService? _instance;

  PermissionService._();

  static PermissionService getInstance() {
    _instance ??= PermissionService._();
    return _instance!;
  }

  // ============================================
  // CAMERA
  // ============================================

  Future<bool> requestCamera() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> hasCamera() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.status;
    return status.isGranted;
  }

  // ============================================
  // PHOTOS/GALLERY
  // ============================================

  Future<bool> requestPhotos() async {
    if (kIsWeb) return true;

    Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }

    final status = await permission.request();
    return status.isGranted;
  }

  Future<bool> hasPhotos() async {
    if (kIsWeb) return true;

    Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }

    final status = await permission.status;
    return status.isGranted;
  }

  // ============================================
  // LOCATION
  // ============================================

  Future<bool> requestLocation() async {
    if (kIsWeb) return true;

    final status = await Permission.location.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      return false;
    }

    return status.isGranted;
  }

  Future<bool> requestLocationAlways() async {
    if (kIsWeb) return true;

    if (Platform.isIOS) {
      final status = await Permission.locationAlways.request();
      return status.isGranted;
    }

    return await requestLocation();
  }

  Future<bool> hasLocation() async {
    if (kIsWeb) return true;

    final status = await Permission.location.status;
    return status.isGranted;
  }

  Future<LocationPermissionStatus> getLocationStatus() async {
    if (kIsWeb) return LocationPermissionStatus.granted;

    final status = await Permission.location.status;

    if (status.isGranted) {
      return LocationPermissionStatus.granted;
    } else if (status.isDenied) {
      return LocationPermissionStatus.denied;
    } else if (status.isPermanentlyDenied) {
      return LocationPermissionStatus.permanentlyDenied;
    } else {
      return LocationPermissionStatus.restricted;
    }
  }

  // ============================================
  // MICROPHONE
  // ============================================

  Future<bool> requestMicrophone() async {
    if (kIsWeb) return true;

    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> hasMicrophone() async {
    if (kIsWeb) return true;

    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  // ============================================
  // NOTIFICATIONS
  // ============================================

  Future<bool> requestNotifications() async {
    if (kIsWeb) return true;

    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> hasNotifications() async {
    if (kIsWeb) return true;

    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // ============================================
  // CONTACTS
  // ============================================

  Future<bool> requestContacts() async {
    if (kIsWeb) return false;

    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  Future<bool> hasContacts() async {
    if (kIsWeb) return false;

    final status = await Permission.contacts.status;
    return status.isGranted;
  }

  // ============================================
  // BIOMETRIC/FINGERPRINT
  // ============================================

  Future<bool> hasBiometric() async {
    if (kIsWeb) return false;

    // Check if device supports biometric
    return await Permission.sensors.status.isGranted;
  }

  // ============================================
  // MULTIPLE PERMISSIONS
  // ============================================

  Future<Map<Permission, PermissionStatus>> requestMultiple(List<Permission> permissions) async {
    if (kIsWeb) {
      return {for (var p in permissions) p: PermissionStatus.granted};
    }

    return await permissions.request();
  }

  // ============================================
  // SETTINGS
  // ============================================

  Future<bool> openSettings() async {
    if (kIsWeb) return false;

    return await openAppSettings();
  }

  // ============================================
  // HELPERS
  // ============================================

  Future<bool> checkPermission(Permission permission) async {
    if (kIsWeb) return true;

    final status = await permission.status;
    return status.isGranted;
  }

  Future<bool> requestPermission(Permission permission) async {
    if (kIsWeb) return true;

    final status = await permission.request();
    return status.isGranted;
  }

  Future<PermissionStatus> getStatus(Permission permission) async {
    if (kIsWeb) return PermissionStatus.granted;

    return await permission.status;
  }

  bool shouldShowRationale(PermissionStatus status) {
    return status.isDenied && !status.isPermanentlyDenied;
  }

  Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    if (kIsWeb) return false;

    final status = await permission.status;
    return status.isPermanentlyDenied;
  }
}

// ============================================
// ENUMS
// ============================================

enum LocationPermissionStatus { granted, denied, permanentlyDenied, restricted }

enum PermissionType { camera, photos, location, locationAlways, microphone, notifications, contacts, biometric }
