import 'dart:math';

import 'package:intl/intl.dart';

/// Funções utilitárias globais

class AppUtils {
  // ============================================
  // DATE & TIME
  // ============================================

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'agora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return '${difference.inDays ~/ 7}sem';
    } else if (difference.inDays < 365) {
      return '${difference.inDays ~/ 30}m';
    } else {
      return '${difference.inDays ~/ 365}a';
    }
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else {
      return '${minutes}min';
    }
  }

  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  // ============================================
  // STRING
  // ============================================

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  static String removeAccents(String text) {
    const withAccents = 'áàãâäéèêëíìîïóòõôöúùûüçñÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ';
    const withoutAccents = 'aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN';

    String result = text;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return result;
  }

  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    return cleaned.length >= 10 && cleaned.length <= 15;
  }

  static String maskPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length == 11) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 7)}-${cleaned.substring(7)}';
    } else if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 6)}-${cleaned.substring(6)}';
    }

    return phone;
  }

  // ============================================
  // NUMBERS
  // ============================================

  static String formatCurrency(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
  }

  static String formatNumber(int number) {
    return NumberFormat('#,###', 'pt_BR').format(number);
  }

  static String formatCompactNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
  }

  static String formatPercentage(double value, {int decimals = 0}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }

  // ============================================
  // DISTANCE
  // ============================================

  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()}m';
    } else if (distanceInKm < 100) {
      return '${distanceInKm.toStringAsFixed(1)}km';
    } else {
      return '${distanceInKm.round()}km';
    }
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // ============================================
  // FILE & MEDIA
  // ============================================

  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  static String getFileExtension(String filename) {
    return filename.split('.').last.toLowerCase();
  }

  static bool isImageFile(String filename) {
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'heic', 'webp'];
    return imageExtensions.contains(getFileExtension(filename));
  }

  static bool isVideoFile(String filename) {
    const videoExtensions = ['mp4', 'mov', 'avi', 'mkv'];
    return videoExtensions.contains(getFileExtension(filename));
  }

  // ============================================
  // VALIDATION
  // ============================================

  static String? validateRequired(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }
    if (!isValidEmail(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 8) {
      return 'Senha deve ter no mínimo 8 caracteres';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return 'Senha deve conter letras';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Senha deve conter números';
    }
    return null;
  }

  static String? validateAge(int? age) {
    if (age == null) {
      return 'Idade é obrigatória';
    }
    if (age < 18) {
      return 'Você deve ter pelo menos 18 anos';
    }
    if (age > 99) {
      return 'Idade inválida';
    }
    return null;
  }

  // ============================================
  // MISC
  // ============================================

  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static T? randomFromList<T>(List<T> list) {
    if (list.isEmpty) return null;
    return list[Random().nextInt(list.length)];
  }

  static List<T> shuffleList<T>(List<T> list) {
    final newList = List<T>.from(list);
    newList.shuffle();
    return newList;
  }

  static Map<K, V> sortMapByValue<K, V extends Comparable>(Map<K, V> map, {bool descending = false}) {
    final entries = map.entries.toList()
      ..sort((a, b) => descending ? b.value.compareTo(a.value) : a.value.compareTo(b.value));
    return Map.fromEntries(entries);
  }
}
